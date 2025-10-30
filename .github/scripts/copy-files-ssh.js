const fs = require("fs");
const path = require("path");
const { Client } = require("ssh2");

const conn = new Client();

// VARIABLES DE ENTORNO 
const deployPath = process.env.DEPLOY_PATH;
const host = process.env.SERVER_HOST;
const user = process.env.SERVER_USER;
const b64 = process.env.SERVER_SSH_KEY_BASE64;

if (!b64 || !deployPath || !host || !user) {
  console.error("Faltan variables de entorno requeridas.");
  process.exit(1);
}

//CREAR CLAVE TEMPORAL
const sshDir = path.join(process.cwd(), ".ssh");
if (!fs.existsSync(sshDir)) fs.mkdirSync(sshDir);

const keyPath = path.join(sshDir, "id_ed25519");
fs.writeFileSync(keyPath, Buffer.from(b64, "base64"));
fs.chmodSync(keyPath, 0o600);

//SUBIDA RECURSIVA
function uploadDirectory(sftp, localDir, remoteDir) {
  const items = fs.readdirSync(localDir);

  return Promise.all(
    items.map(async (item) => {
      const localPath = path.join(localDir, item);
      const remotePath = path.posix.join(remoteDir, item);
      const stats = fs.statSync(localPath);

      if (stats.isDirectory()) {
        try {
          await new Promise((res) => sftp.mkdir(remotePath, { mode: 0o755 }, res));
        } catch (_) {}
        return uploadDirectory(sftp, localPath, remotePath);
      } else {
        return new Promise((resolve, reject) => {
          sftp.fastPut(localPath, remotePath, (err) => {
            if (err) {
              console.error(`Error subiendo ${item}: ${err.message}`);
              reject(err);
            } else {
              console.log(`Subido: ${remotePath}`);
              resolve();
            }
          });
        });
      }
    })
  );
}

// CONEXIÓN SSH 
conn
  .on("ready", () => {
    console.log(`Conectado a ${user}@${host}`);
    const cleanCommand = `rm -rf ${deployPath}/*`;

    // Limpiar carpeta remota
    conn.exec(cleanCommand, (err, stream) => {
      if (err) throw err;
      stream
        .on("close", (code) => {
          if (code === 0) console.log("Carpeta remota limpiada correctamente.");
          else console.warn(`Limpieza finalizada con código ${code}`);

          // Iniciar SFTP para subir archivos
          conn.sftp(async (err, sftp) => {
            if (err) {
              console.error("Error iniciando SFTP:", err.message);
              conn.end();
              process.exit(1);
            }

            const localDir = path.join(process.cwd(), "build", "web");
            if (!fs.existsSync(localDir)) {
              console.error(`No existe el directorio local: ${localDir}`);
              conn.end();
              process.exit(1);
            }

            console.log(`Subiendo archivos desde ${localDir} a ${deployPath}`);

            try {
              await uploadDirectory(sftp, localDir, deployPath);
              console.log("Despliegue completado correctamente.");
            } catch (err) {
              console.error("Error durante la subida:", err);
              process.exit(1);
            } finally {
              sftp.end();
              conn.end();
            }
          });
        })
        .stderr.on("data", (data) => {
          console.error(`Error en limpieza remota: ${data.toString()}`);
        });
    });
  })
  .on("error", (err) => {
    console.error(`Error SSH: ${err.message}`);
    process.exit(1);
  })
  .on("end", () => console.log("Conexión finalizada."))
  .connect({
    host,
    username: user,
    privateKey: keyPath,
    keepaliveInterval: 10000, 
    readyTimeout: 30000,
  });
