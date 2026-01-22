import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import puppeteer from "puppeteer";
import { marked } from "marked";

/* ==================================================
   Setup base
   ================================================== */
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, "../..");

/* ==================================================
   Prompt por sección
   ================================================== */
const PROMPT_SECCION = `
Eres una IA encargada de COMPLETAR marcadores de documentación técnica.

REGLAS OBLIGATORIAS:
- Devuelve EXCLUSIVAMENTE un JSON válido
- NO incluyas texto fuera del JSON
- Las claves deben coincidir EXACTAMENTE con los marcadores
- Cada valor DEBE ser un STRING listo para insertarse en Markdown
- Usa SOLO el contexto proporcionado
- NO inventes información
- Si el contexto no es suficiente para un marcador, devuelve null

CONTEXTO:
{{CONTEXTO}}

MARCADORES:
{{MARCADORES}}
`;

/* ==================================================
   Ollama
   ================================================== */
async function generarSeccion(prompt) {
  const res = await fetch("http://localhost:11434/api/generate", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      model: "llama3",
      prompt,
      stream: false,
      format: "json",
      options: { temperature: 0 }
    })
  });

  if (!res.ok) {
    throw new Error(`Ollama respondió ${res.status}`);
  }

  const json = await res.json();
  return String(json.response ?? "").trim();
}

/* ==================================================
   Utils Markdown
   ================================================== */
function dividirPorSubtitulos(md) {
  const r = /(## .+?\n[\s\S]*?)(?=\n## |\n?$)/g;
  return md.match(r) ?? [md];
}

function extraerMarcadores(seccion) {
  const r = /{{\s*([^}]+?)\s*}}/g;
  return [...new Set([...seccion.matchAll(r)].map(m => m[1]))];
}

function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

/* ==================================================
   Metadata semántica (GENÉRICA)
   ================================================== */
function extraerMetadataSeccion(seccion) {
  const titulo = seccion.match(/^##\s+(.+)$/m)?.[1] ?? null;

  return {
    titulo,
    texto: seccion
      .replace(/^## .+$/m, "")
      .trim()
      .slice(0, 1500)
  };
}

/* ==================================================
   Normalizador Markdown
   ================================================== */
function normalizarValorMarkdown(valor) {
  if (valor == null) return null;
  if (typeof valor === "string") return valor.trim();
  if (Array.isArray(valor)) return valor.join(", ");
  if (typeof valor === "object") {
    return Object.entries(valor)
      .map(([k, v]) => `${k}: ${JSON.stringify(v)}`)
      .join(". ");
  }
  return String(valor);
}

/* ==================================================
   Cargar analysis y config
   ================================================== */
const analysis = JSON.parse(
  fs.readFileSync(path.join(REPO_ROOT, "analysis.json"), "utf8")
);
const config = JSON.parse(
  fs.readFileSync(path.join(REPO_ROOT, "docs/config.json"), "utf8")
);

/* ==================================================
   Contexto genérico por sección
   ================================================== */
function construirContextoDesdeSeccion(seccion) {
  return {
    seccion: extraerMetadataSeccion(seccion),
    proyecto: analysis
  };
}

/* ==================================================
   Completar marcadores
   ================================================== */
async function completarMarcadoresEnSeccion(seccion) {
  const marcadores = extraerMarcadores(seccion);
  if (!marcadores.length) return seccion;

  const contextoBase = construirContextoDesdeSeccion(seccion);
  const contexto = Object.fromEntries(
    marcadores.map(m => [m, contextoBase])
  );

  const prompt = PROMPT_SECCION
    .replace("{{CONTEXTO}}", JSON.stringify(contexto, null, 2))
    .replace("{{MARCADORES}}", JSON.stringify(marcadores));

  const raw = await generarSeccion(prompt);

  let mapping;
  try {
    mapping = JSON.parse(raw.includes("```")
      ? raw.match(/```json\s*([\s\S]*?)```/)?.[1]
      : raw);
  } catch {
    console.warn("⚠ JSON inválido:\n", raw);
    return seccion;
  }

  let result = seccion;

  for (const m of marcadores) {
    const valor = normalizarValorMarkdown(mapping[m]);
    if (valor !== null) {
      result = result.replace(
        new RegExp(`{{\\s*${escapeRegex(m)}\\s*}}`, "g"),
        valor
      );
    }
  }

  return result;
}

/* ==================================================
   Markdown → PDF con Puppeteer
   ================================================== */
async function markdownToPDF(mdPath, pdfPath) {
  const md = fs.readFileSync(mdPath, "utf8");
  const html = marked.parse(md);

  const browser = await puppeteer.launch({
    headless: "new"
  });

  const page = await browser.newPage();
  await page.setContent(`
    <html>
      <head>
        <meta charset="utf-8" />
        <style>
          body { font-family: Arial, sans-serif; padding: 40px; }
          h1, h2, h3 { color: #222; }
          pre { background: #f5f5f5; padding: 12px; }
          code { font-family: monospace; }
        </style>
      </head>
      <body>${html}</body>
    </html>
  `, { waitUntil: "networkidle0" });

  await page.pdf({
    path: pdfPath,
    format: "A4",
    printBackground: true
  });

  await browser.close();
}

/* ==================================================
   Generación de manuales
   ================================================== */
fs.mkdirSync(path.join(REPO_ROOT, "docs/outputs"), { recursive: true });

for (const manual of config.manuales) {
  try {
    const plantillaPath = path.resolve(REPO_ROOT, manual.plantilla);
    const salidaMd = path.resolve(REPO_ROOT, manual.salida);
    const salidaPdf = salidaMd.replace(/\.md$/, ".pdf");

    const plantilla = fs.readFileSync(plantillaPath, "utf8");
    const secciones = dividirPorSubtitulos(plantilla);

    let cuerpo = "";
    for (const seccion of secciones) {
      cuerpo += (await completarMarcadoresEnSeccion(seccion)).trim() + "\n\n";
    }

    const header = `# MANUAL ${(manual.titulo ?? manual.nombre).toUpperCase()}\n\n`;
    fs.writeFileSync(salidaMd, header + cuerpo.trim(), "utf8");

    await markdownToPDF(salidaMd, salidaPdf);

    console.log(`✔ Manual generado: ${salidaMd}`);
    console.log(`✔ PDF generado: ${salidaPdf}`);
  } catch (err) {
    console.error(`✖ Error en ${manual.nombre}: ${err.message}`);
  }
}
