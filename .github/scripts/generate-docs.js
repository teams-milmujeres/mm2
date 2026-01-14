import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// --------------------------------------------------
// setup de rutas seguras
// --------------------------------------------------
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// --------------------------------------------------
// Prompt por SECCIÓN
// --------------------------------------------------
const PROMPT_SECCION = `
Eres una IA encargada de COMPLETAR una SECCIÓN de documentación existente.

REGLAS ESTRICTAS (OBLIGATORIAS):
- NO reescribas el contenido existente
- NO reformatees títulos, listas ni párrafos
- NO cambies redacción, estilo ni orden
- CONSERVA el Markdown exactamente como está
- SOLO debes reemplazar los marcadores en formato {{ marcador }}
- Si un marcador no puede completarse, déjalo tal cual
- NO agregues comentarios ni explicaciones

SECCIÓN ORIGINAL:
{{SECCION}}

ANÁLISIS DEL REPOSITORIO:
{{ANALISIS}}
`;

// --------------------------------------------------
// función robusta para llamar a Ollama
// --------------------------------------------------
async function generarSeccion(prompt) {
  const controller = new AbortController();

  const timeout = setTimeout(() => {
    controller.abort();
  }, 300_000); // 5 minutos

  try {
    const res = await fetch("http://localhost:11434/api/generate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "llama3",
        prompt,
        stream: false,
        options: {
          temperature: 0.1,
          num_predict: 600,
        },
      }),
      signal: controller.signal,
    });

    if (!res.ok) {
      throw new Error(`Ollama respondió con ${res.status}`);
    }

    return await res.json();
  } catch (err) {
    if (err.name === "AbortError") {
      throw new Error("Timeout: Ollama tardó demasiado en responder");
    }
    throw err;
  } finally {
    clearTimeout(timeout);
  }
}

// --------------------------------------------------
// util: dividir markdown por subtítulos (##)
// --------------------------------------------------
function dividirPorSubtitulos(markdown) {
  const regex = /(## .+?\n[\s\S]*?)(?=\n## |\n?$)/g;
  return markdown.match(regex) ?? [];
}

// --------------------------------------------------
// carga de archivos de entrada
// --------------------------------------------------
const analysisPath = path.join(__dirname, "../../analysis.json");
const configPath = path.join(__dirname, "../../docs/config.json");

if (!fs.existsSync(analysisPath)) {
  throw new Error("No existe analysis.json");
}

if (!fs.existsSync(configPath)) {
  throw new Error("No existe docs/config.json");
}

const analysisJson = JSON.parse(fs.readFileSync(analysisPath, "utf8"));
const config = JSON.parse(fs.readFileSync(configPath, "utf8"));

// --------------------------------------------------
// reducir análisis (ajusta si tu estructura cambia)
// --------------------------------------------------
const analisisReducido =
  analysisJson.organizacion_codigo ??
  analysisJson.flutter ??
  analysisJson.structure ??
  analysisJson;

// --------------------------------------------------
// carpeta de salida
// --------------------------------------------------
fs.mkdirSync("docs/outputs", { recursive: true });

// --------------------------------------------------
// generación de manuales por subtítulos
// --------------------------------------------------
for (const manual of config.manuales) {
  try {
    if (!fs.existsSync(manual.plantilla)) {
      console.warn(`Plantilla no encontrada: ${manual.plantilla}`);
      continue;
    }

    const plantillaCompleta = fs.readFileSync(manual.plantilla, "utf8");
    const secciones = dividirPorSubtitulos(plantillaCompleta);

    let documentoFinal = "";

    // helper: escapar texto para usar en RegExp
    function escapeRegex(str) {
      return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    }

    // helper: completar marcadores {{ marcador }} dentro de una sección sin tocar el resto
    async function completarMarcadoresEnSeccion(seccion) {
      const marcadorRegex = /{{\s*([^}]+?)\s*}}/g;
      const marcadores = [
        ...new Set(
          Array.from(seccion.matchAll(marcadorRegex)).map((m) => m[1])
        ),
      ];

      if (marcadores.length === 0) return seccion;

      // intenta obtener todos los marcadores de una sola vez, forzando un bloque ```json```
      async function tryPromptForMarkers(markers) {
        const prompt = `Eres una IA encargada de RELLENAR MARCADORES en formato {{marcador}} dentro de una sección de Markdown.\n\nREGLAS ESTRICTAS:\n- NO reescribas el contenido existente fuera de los marcadores\n- SOLO devuelve UN BLOQUE de código con formato \`\`\`json\\n{...}\\n\`\`\` que contenga un OBJETO JSON cuya clave sea el nombre del marcador y el valor el texto de reemplazo (puede contener Markdown).\n- Si no puedes completar un marcador, asigna el valor null.\n- NO agregues texto fuera del bloque \`\`\`json\`\`\` (si hay texto adicional, será ignorado).\n\nSECCIÓN ORIGINAL:\n${seccion}\n\nANÁLISIS DEL REPOSITORIO:\n${JSON.stringify(
          analisisReducido,
          null,
          2
        )}\n\nMARCADORES:\n${JSON.stringify(markers, null, 2)}\n`;

        const data = await generarSeccion(prompt);
        const raw = data.response.trim();

        // extraer contenido dentro de ```json ... ``` preferentemente
        let jsonText = null;
        const codeMatch = raw.match(/```json\n([\s\S]*?)\n```/);
        if (codeMatch) {
          jsonText = codeMatch[1];
        } else {
          const braceMatch = raw.match(/{[\s\S]*}/);
          if (braceMatch) jsonText = braceMatch[0];
        }

        if (!jsonText) return null;

        try {
          return JSON.parse(jsonText);
        } catch (err) {
          return null;
        }
      }

      let mapping = await tryPromptForMarkers(marcadores);

      // reintentar una vez si no obtuvo JSON válido
      if (!mapping) {
        console.warn(
          "Respuesta no parseable, intentando un reintento estricto..."
        );
        mapping = await tryPromptForMarkers(marcadores);
      }

      // si aún no hay mapping o faltan claves, intentar por marcador individual
      if (!mapping) mapping = {};

      const faltantes = marcadores.filter(
        (m) => !(m in mapping) || mapping[m] === null
      );
      for (const name of faltantes) {
        console.warn(`Intentando completar marcador individual: ${name}`);
        const singlePrompt = `Devuelve SOLO un bloque de código con formato \`\`\`json\\n{ "${name}": "valor_completado" }\\n\`\`\`\\n\\nReemplaza el marcador "${name}" para esta sección.\\n\\nSECCIÓN:\\n${seccion}\\n\\nANÁLISIS:\\n${JSON.stringify(
          analisisReducido,
          null,
          2
        )}\\n`;

        const data = await generarSeccion(singlePrompt);
        const raw = data.response.trim();
        let jsonText = null;
        const codeMatch = raw.match(/```json\n([\s\S]*?)\n```/);
        if (codeMatch) jsonText = codeMatch[1];
        else {
          const braceMatch = raw.match(/{[\s\S]*}/);
          if (braceMatch) jsonText = braceMatch[0];
        }

        if (!jsonText) {
          console.warn(
            `No se pudo obtener JSON para el marcador ${name}; se dejará sin cambios`
          );
          continue;
        }

        try {
          const parsed = JSON.parse(jsonText);
          if (parsed && parsed[name] != null) {
            mapping[name] = parsed[name];
            console.log(`Marcador ${name} completado individualmente`);
          } else {
            console.warn(`Respuesta individual no contenía la clave ${name}`);
          }
        } catch (err) {
          console.warn(
            `Error parseando JSON individual para ${name}: ${err.message}`
          );
        }
      }

      // aplicar reemplazos (solo las claves con valor no nulo)
      let result = seccion;
      const completados = [];
      const noCompletados = [];

      for (const m of marcadores) {
        if (mapping[m] != null) {
          const markerRe = new RegExp(`{{\\s*${escapeRegex(m)}\\s*}}`, "g");
          result = result.replace(markerRe, mapping[m]);
          completados.push(m);
        } else {
          noCompletados.push(m);
        }
      }

      if (completados.length)
        console.log(`Marcadores completados: ${completados.join(", ")}`);
      if (noCompletados.length)
        console.warn(`Marcadores NO completados: ${noCompletados.join(", ")}`);

      return result;
    }

    for (const seccion of secciones) {
      const matchTitulo = seccion.match(/^##\s+(.*)/m);
      const subtitulo = matchTitulo
        ? matchTitulo[1].trim()
        : "Sección sin título";

      console.log(`Escribiendo ${subtitulo}`);

      const seccionCompletada = await completarMarcadoresEnSeccion(seccion);
      documentoFinal += seccionCompletada.trim() + "\n\n";
    }

    // Construir título en mayúsculas e índice a partir de los subtítulos
    const prettyName = (manual.titulo ?? manual.nombre ?? "Manual").toString().replace(/[_-]+/g, ' ').trim();
    const title = `MANUAL ${prettyName}`.toUpperCase() + " DE LA APLICACIÓN".toUpperCase() + "\n\n" + manual.version;
    const sectionTitles = secciones
      .map((s) => {
        const m = s.match(/^##\s+(.*)/m);
        return m ? m[1].trim() : null;
      })
      .filter(Boolean);

    function slugify(str) {
      return str
        .toString()
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .replace(/[^\w\s-]/g, "")
        .trim()
        .replace(/\s+/g, "-");
    }

    const index = sectionTitles
      .map((t) => `- [${t}](#${slugify(t)})`)
      .join("\n");

    const header = `# ${title}\n\n## Índice\n\n${index}\n\n`;

    const finalContent = header + documentoFinal.trim();

    // Insertar anchors HTML después de cada subtítulo '##' para que los links del índice funcionen
    const finalContentWithAnchors = finalContent.replace(/^##\s+(.*)$/gm, (m, p1) => `## ${p1}\n<a id="${slugify(p1)}"></a>`);

    // helper: localizar archivo de imagen en varios directorios (plantilla, repo assets, etc.)
    function findImageFile(imgPath) {
      const candidates = [];

      // path relativo a la plantilla (ej: ../assets/foo.png -> docs/assets/foo.png)
      try {
        candidates.push(path.resolve(path.dirname(manual.plantilla), imgPath));
      } catch (e) {}

      // path relativo al repo root
      candidates.push(path.resolve(__dirname, "../../", imgPath));

      // basename in common asset dirs
      const base = path.basename(imgPath);
      const baseNoExt = base.replace(/\.[^.]+$/, "").toLowerCase();
      candidates.push(path.resolve(__dirname, "../../assets", base));
      candidates.push(path.resolve(__dirname, "../../assets/images", base));
      candidates.push(path.resolve(__dirname, "../../images", base));
      candidates.push(path.resolve(__dirname, "../../icon", base));

      for (const c of candidates) {
        if (fs.existsSync(c)) return c;
      }

      // fallback: buscar en assets por coincidencia parcial del nombre
      const searchDirs = [path.resolve(__dirname, "../../assets"), path.resolve(__dirname, "../../assets/images")];
      for (const dir of searchDirs) {
        if (!fs.existsSync(dir)) continue;
        const files = fs.readdirSync(dir);
        for (const f of files) {
          const candidateName = f.toLowerCase();
          if (candidateName.includes(baseNoExt)) return path.join(dir, f);
        }
      }

      return null;
    }

    // helper: reemplazar imágenes locales en Markdown por <img src="data:..."> para que Puppeteer las incluya
    function embedImagesInMarkdown(md, baseDir) {
      return md.replace(/!\[([^\]]*)\]\s*\(\s*([^\)]+?)\s*\)/g, (m, alt, imgPath) => {
        imgPath = imgPath.trim();
        // dejar URLs remotas/data tal cual
        if (/^(https?:)?\/\//.test(imgPath) || /^data:/.test(imgPath)) {
          return `<img alt="${alt}" src="${imgPath}">`;
        }

        // intentar localizar el archivo en varias ubicaciones
        const resolved = findImageFile(imgPath);

        if (!resolved) {
          console.warn(`Imagen no encontrada: ${imgPath} (buscada en varios directorios)`);
          return `<img alt="${alt}" src="${imgPath}">`;
        }

        console.log(`Incrustando imagen para PDF: ${imgPath} -> ${resolved}`);

        const ext = path.extname(resolved).toLowerCase();
        const bin = fs.readFileSync(resolved);

        try {
          if (ext === ".svg") {
            const svgText = bin.toString("utf8");
            const data = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svgText);
            return `<img alt="${alt}" src="${data}">`;
          } else {
            let mime = "image/png";
            if (ext === ".jpg" || ext === ".jpeg") mime = "image/jpeg";
            else if (ext === ".gif") mime = "image/gif";
            else if (ext === ".webp") mime = "image/webp";
            const data = `data:${mime};base64,${bin.toString("base64")}`;
            return `<img alt="${alt}" src="${data}">`;
          }
        } catch (err) {
          console.warn(`Error al incrustar imagen ${imgPath}: ${err.message}`);
          return `<img alt="${alt}" src="${imgPath}">`;
        }
      });
    }

    // Restaurar imágenes embebidas en data: a la sintaxis Markdown original si se encuentra en la plantilla
    function restoreEmbeddedImages(md, plantilla) {
      return md.replace(/<img\s+[^>]*alt="([^"]+)"[^>]*>/g, (m, alt) => {
        const re = new RegExp("!\\[" + escapeRegex(alt) + "\\]\\s*\\(\\s*([^\\)]+?)\\s*\\)", "i");
        const tplMatch = plantilla.match(re);
        if (tplMatch) return tplMatch[0];
        return m;
      });
    }

    // Normalizar espacio en sintaxis de imagen Markdown ('] (') -> '](' ) para consistencia
    function normalizeMarkdownImageSyntax(md) {
      // elimina espacios entre '] (' y normaliza espacios internos en el alt
      return md.replace(/!\[\s*([^\]]+?)\s*\]\s*\(\s*/g, "![$1](");
    }

    const sanitizedContent = restoreEmbeddedImages(finalContentWithAnchors, plantillaCompleta);
    const normalizedContent = normalizeMarkdownImageSyntax(sanitizedContent);

    fs.writeFileSync(manual.salida, normalizedContent);
    console.log(`Manual "${manual.nombre}" generado correctamente`);

    // Intentar convertir a PDF usando Puppeteer + marked (renderiza Markdown a HTML en memoria)
    try {
      const pdfPath = manual.salida.replace(/\.md$/i, ".pdf");

      let puppeteer;
      try {
        puppeteer = await import("puppeteer");
      } catch (err) {
        console.warn(
          "Puppeteer no está instalado. Instálalo con: npm i -D puppeteer"
        );
        puppeteer = null;
      }

      if (puppeteer) {
        const mdForHtml = embedImagesInMarkdown(finalContentWithAnchors, path.dirname(manual.plantilla));

        const html = `<!doctype html>
                      <html>
                      <head>
                      <meta charset="utf-8" />
                      <meta name="viewport" content="width=device-width,initial-scale=1"/>
                      <title>${manual.nombre}</title>
                      <style>
                        body{font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial; padding:36px; color:#222}
                        img{max-width:100%}
                        pre{white-space:pre-wrap; word-wrap:break-word}
                        .markdown-body{max-width:900px; margin:0 auto}
                      </style>
                      </head>
                      <body>
                      <div class="markdown-body" id="content">Cargando...</div>
                      <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
                      <script>
                        const md = ${JSON.stringify(mdForHtml)};
                        document.getElementById('content').innerHTML = marked.parse(md);
                      </script>
                      </body>
                      </html>`;

        const browser = await puppeteer.launch();
        const page = await browser.newPage();
        await page.setContent(html, { waitUntil: "networkidle0" });
        await page.pdf({ path: pdfPath, format: "A4", printBackground: true });
        await browser.close();
        console.log(`PDF creado: ${pdfPath}`);
      }
    } catch (err) {
      console.warn("No se pudo generar PDF con Puppeteer:", err.message);
    }
  } catch (err) {
    console.error(`Error generando "${manual.nombre}": ${err.message}`);
  }
}

console.log("Proceso de documentación finalizado");
