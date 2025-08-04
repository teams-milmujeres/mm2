const fs = require('fs');
const { google } = require('googleapis');
const path = require('path');

async function uploadFile() {
  try {
    const CLIENT_ID = process.env.CLIENT_ID;
    const CLIENT_SECRET = process.env.CLIENT_SECRET;
    const REFRESH_TOKEN = process.env.REFRESH_TOKEN;
    const FOLDER_ID = process.env.FOLDER_ID;
    const FILE_NAME = 'archive.zip';

    // Validar variables de entorno
    if (!CLIENT_ID || !CLIENT_SECRET || !REFRESH_TOKEN || !FOLDER_ID) {
      throw new Error('❌ Faltan variables de entorno');
    }

    // Verificar archivo ZIP
    const filePath = path.join(process.cwd(), FILE_NAME);
    if (!fs.existsSync(filePath)) {
      throw new Error(`❌ Archivo no encontrado: ${filePath}`);
    }
    console.log(`📦 Archivo encontrado (${fs.statSync(filePath).size} bytes)`);

    // Configurar OAuth
    const oauth2Client = new google.auth.OAuth2(
      CLIENT_ID,
      CLIENT_SECRET,
      'https://developers.google.com/oauthplayground'
    );

    // Intento de autenticación con manejo de errores
   try {
    console.log('🔐 Autenticando...');
    oauth2Client.setCredentials({ refresh_token: REFRESH_TOKEN });

    // Forzar refresco del token (esto no lanza tokens, solo asegura que el token esté actualizado)
    const accessToken = await oauth2Client.getAccessToken();

    console.log('✅ Autenticación exitosa');
    console.log(`🆔 Token de acceso: ${accessToken.token?.slice(0, 15)}...`);
  } catch (authError) {
    console.error('❌ Error de autenticación:');
    console.error(authError.message);

    if (authError.response) {
      console.error('Detalles:');
      console.error(`- Código: ${authError.response.status}`);
      console.error(`- Error: ${authError.response.data.error}`);
      console.error(`- Descripción: ${authError.response.data.error_description}`);
    }

    throw new Error('Verifica CLIENT_ID, CLIENT_SECRET y REFRESH_TOKEN');
  }


    const drive = google.drive({ version: 'v3', auth: oauth2Client });

    // Subir archivo (sin verificar carpeta primero)
    const fileMetadata = {
      name: `mm.zip`,
      parents: [FOLDER_ID],
    };

    const media = {
      mimeType: 'application/zip',
      body: fs.createReadStream(filePath),
    };

    console.log('⬆️ Subiendo archivo...');
    const response = await drive.files.create({
      resource: fileMetadata,
      media: media,
      fields: 'id,webViewLink',
    });

    console.log(`✅ Subido correctamente!`);
    console.log(`🔗 Enlace: ${response.data.webViewLink}`);
    
  } catch (error) {
    console.error('❌ Error crítico:', error.message);
    process.exit(1);
  }
}

uploadFile();