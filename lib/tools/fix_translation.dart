import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final dir = Directory('lib/l10n');
  if (!dir.existsSync()) {
    print('❌ No se encontró la carpeta lib/l10n');
    return;
  }

  final arbFiles = dir.listSync().where((f) => f.path.endsWith('.arb'));

  for (var file in arbFiles) {
    final path = file.path;
    final content = await File(path).readAsString();
    final data = json.decode(content) as Map<String, dynamic>;
    var modified = false;

    final keys = List<String>.from(data.keys);

    // 1️⃣ Eliminar metadatos huérfanos
    for (final key in keys) {
      if (key.startsWith('@')) {
        final baseKey = key.substring(1);
        if (!data.containsKey(baseKey)) {
          print('🗑️  Eliminando metadato huérfano: $key en $path');
          data.remove(key);
          modified = true;
        }
      }
    }

    // 2️⃣ Agregar metadatos faltantes
    for (final key in List<String>.from(data.keys)) {
      if (!key.startsWith('@')) {
        final metaKey = '@$key';
        if (!data.containsKey(metaKey)) {
          data[metaKey] = {'description': 'Auto-added metadata for "$key".'};
          modified = true;
        }
      }
    }

    // 3️⃣ Opcional: Detectar claves de agrupación vacías (por convención "_")
    for (final key in List<String>.from(data.keys)) {
      if (key.startsWith('_') && data[key] == "") {
        // Si quieres mantener las agrupaciones, no hagas nada.
        // Si quieres eliminarlas, descomenta la siguiente línea:
        // data.remove(key);
      }
    }

    if (modified) {
      final encoder = const JsonEncoder.withIndent('  ');
      await File(path).writeAsString(encoder.convert(data));
      print('✅ Archivo actualizado: $path');
    } else {
      print('👌 Nada que cambiar en $path');
    }
  }

  print('\n✨ Limpieza completada.');
}
