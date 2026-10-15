import 'dart:io';

import 'package:lab01/lab01.dart';

void main() {
  final today = DateTime.now();
  final counter = createProcessedCounter();
  final parsed = <FilmRecord>[];
  final failures = <String>[];

  for (final line in sampleLines) {
    counter.increment();
    final result = parseLine(line);
    final film = result.film;
    final error = result.error;
    if (film != null) {
      parsed.add(film);
    } else if (error != null) {
      failures.add('$line -> $error');
    }
  }

  final valid = <FilmRecord>[];
  final rejected = <String>[];
  for (final film in parsed) {
    final violations = validateFilm(film, today: today);
    if (violations.isEmpty) {
      valid.add(film);
    } else {
      rejected.add('${film.code}: ${violations.join('; ')}');
    }
  }

  final titles = valid.map(filmTitle).toList();
  final highlighted = pickHighlighted(valid);
  final byYear = sortFilms(valid, criterion: sortByYear, ascending: true);
  final byRating = sortFilms(valid, criterion: sortByRating, ascending: false);
  final genreAverages = averageRatingByGenre(valid);
  final genres = genreAverages.keys.toList()..sort();

  stdout
    ..writeln('Оброблено рядків: ${counter.read()}')
    ..writeln('Розібрано: ${parsed.length}')
    ..writeln('Придатних: ${valid.length}')
    ..writeln('Помилки розбору: ${failures.length}')
    ..writeln('Порушення діапазонів: ${rejected.length}')
    ..writeln('');

  stdout.writeln('--- Помилки розбору ---');
  for (final failure in failures) {
    stdout.writeln(failure);
  }

  stdout
    ..writeln('')
    ..writeln('--- Порушення діапазонів ---');
  for (final line in rejected) {
    stdout.writeln(line);
  }

  stdout
    ..writeln('')
    ..writeln('--- Конвеєри ---')
    ..writeln(
      'Висока оцінка (>= $highRatingThreshold): ${highRatedFilms(valid).length}',
    )
    ..writeln('Середня оцінка: ${averageRating(valid).toStringAsFixed(2)}')
    ..writeln('Сумарна тривалість: ${totalDuration(valid)} хв')
    ..writeln('Назви: ${titles.join(', ')}')
    ..writeln('Акцент: ${highlighted.title} (${highlighted.code})')
    ..writeln('Пошук FM-010: ${findByCode(valid, 'FM-010')?.title}')
    ..writeln(
      'Пошук FM-999: ${findByCode(valid, 'FM-999')?.title ?? 'не знайдено'}',
    );

  stdout
    ..writeln('')
    ..writeln('--- Середня оцінка за жанром ---');
  for (final genre in genres) {
    final average = genreAverages[genre];
    stdout.writeln('$genre: ${average?.toStringAsFixed(2)}');
  }

  stdout
    ..writeln('')
    ..writeln('--- Сортування за роком (зростання) ---');
  for (final film in byYear) {
    stdout.writeln('${film.year} ${film.title}');
  }

  stdout
    ..writeln('')
    ..writeln('--- Сортування за оцінкою (спадання) ---');
  for (final film in byRating) {
    stdout.writeln('${film.rating} ${film.title}');
  }

  stdout
    ..writeln('')
    ..writeln('--- Маскування кодів ---');
  for (final film in valid) {
    stdout.writeln('${film.code} -> ${maskCatalogCode(film.code)}');
  }

  stdout
    ..writeln('')
    ..writeln('--- Вік записів на ${today.toIso8601String()} ---');
  for (final film in byYear) {
    stdout.writeln('${film.code}: ${ageInDays(film, today)} дн.');
  }

  stdout
    ..writeln('')
    ..writeln(buildReport(valid, today: today));
}
