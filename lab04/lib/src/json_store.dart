import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'film.dart';

/// Зберігає каталог фільмів у JSON-файлі.
class JsonFilmStore {
  /// Створює сховище для файлу [fileName] у каталозі [directory].
  JsonFilmStore({required this.directory, this.fileName = defaultFileName});

  /// Каталог даних на диску.
  final String directory;

  /// Ім'я JSON-файлу.
  final String fileName;

  /// Ім'я файлу за замовчуванням.
  static const defaultFileName = 'films.json';

  /// Повний шлях до файлу через path.join.
  String get filePath => p.join(directory, fileName);

  /// Читає список фільмів. Порожній файл дає порожній список.
  Future<List<Film>> load() async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return <Film>[];
    }
    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return <Film>[];
    }
    final decoded = jsonDecode(raw);
    if (decoded is! List<dynamic>) {
      throw const FormatException('Очікувався JSON-масив фільмів.');
    }
    return decoded
        .map((item) => Film.fromJson(Map<String, Object?>.from(item as Map)))
        .toList();
  }

  /// Записує [films] у файл, створюючи каталог за потреби.
  Future<void> save(List<Film> films) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final payload = films.map((film) => film.toJson()).toList();
    await File(filePath)
        .writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
  }
}
