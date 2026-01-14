import fs from "fs";

const analysis = {
  framework: "Flutter",
  carpetas_lib: fs.existsSync("lib")
    ? fs.readdirSync("lib")
    : [],
  pubspec: fs.readFileSync("pubspec.yaml", "utf8")
};

fs.writeFileSync("analysis.json", JSON.stringify(analysis, null, 2));
console.log("📊 Análisis Flutter generado");
