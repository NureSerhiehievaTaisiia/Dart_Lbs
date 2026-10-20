import 'dart:convert';
import 'dart:io';

import 'film.dart';

/// Читає великий CSV-подібний файл рядково через openRead.
Stream<String> readLines(File file) {
  return file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
}

/// Розбирає файл каталогу без завантаження цілком у пам'ять.
Future<({List<Film> films, List<String> errors})> loadFilmsFromCsv(
  File file,
) async {
  final films = <Film>[];
  final errors = <String>[];
  await for (final line in readLines(file)) {
    if (line.trim().isEmpty) {
      continue;
    }
    final film = Film.tryParseCsv(line);
    if (film == null) {
      errors.add(line);
    } else {
      films.add(film);
    }
  }
  return (films: films, errors: errors);
}
