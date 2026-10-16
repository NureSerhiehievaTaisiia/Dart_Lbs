import 'dart:io';

import 'package:lab02/lab02.dart';

void main() {
  final today = DateTime.now();
  final loaded = loadSample(today: today);
  final films = loaded.valid;
  final repository = Repository<Film>()..addAll(films);
  final summary = summarize(films);
  final (:count, :averageRating, :totalMinutes) = summary;

  stdout
    ..writeln('Придатних фільмів: $count')
    ..writeln('Помилок розбору: ${loaded.parseErrors.length}')
    ..writeln('Порушень діапазонів: ${loaded.violations.length}')
    ..writeln('Середня оцінка: ${averageRating.toStringAsFixed(2)}')
    ..writeln('Сумарна тривалість: $totalMinutes хв')
    ..writeln('');

  stdout.writeln('--- Порушення ---');
  for (final line in loaded.violations) {
    stdout.writeln(line);
  }

  final first = films.first;
  final copy = Film.fromCsv(sampleLines.first);
  stdout
    ..writeln('')
    ..writeln('--- Рівність ---')
    ..writeln('== : ${first == copy}')
    ..writeln('identical: ${identical(first, copy)}')
    ..writeln('розмір множини: ${{first, copy}.length}');

  Film.clearCache();
  final cached = Film.cached(
    code: first.code,
    title: first.title,
    director: first.director,
    year: first.year,
    durationMinutes: first.durationMinutes,
    genre: first.genre,
    rating: first.rating,
    watchedOn: first.watchedOn,
  );
  final cachedAgain = Film.cached(
    code: first.code,
    title: 'інша назва',
    director: first.director,
    year: first.year,
    durationMinutes: first.durationMinutes,
    genre: first.genre,
    rating: first.rating,
    watchedOn: first.watchedOn,
  );
  stdout
    ..writeln('')
    ..writeln('--- Фабрика кешу ---')
    ..writeln('той самий екземпляр: ${identical(cached, cachedAgain)}')
    ..writeln('назва з кешу: ${cachedAgain.title}');

  final note = CriticNote(
    'Олена',
    'Варто переглянути повторно',
    DateTime(2026, 9, 1),
  );
  stdout
    ..writeln('')
    ..writeln('--- Домішка Freshness ---')
    ..writeln(
      '${first.label}: ${first.ageOn(today)} дн., свіжий = ${first.isFreshOn(today)}',
    )
    ..writeln(
      '$note: ${note.ageOn(today)} дн., свіжий = ${note.isFreshOn(today)}',
    );

  stdout
    ..writeln('')
    ..writeln('--- Види картин ---');
  for (final film in films) {
    final kind = classify(film);
    stdout.writeln(
      '${film.code} ${film.title}: ${describeKind(kind)}; ${recommendation(film)}',
    );
  }
  const episode = EpisodePicture(season: 2, episode: 5);
  stdout.writeln('окремий епізод: ${describeKind(episode)}');

  final found = repository.findById('FM-010');
  stdout
    ..writeln('')
    ..writeln('--- Сховище ---')
    ..writeln('знайдено: ${found?.label}')
    ..writeln(
      'драм: ${repository.where((film) => film.genre == Genre.drama).length}',
    )
    ..writeln('код у звіті: ${first.code.maskedCatalogCode}');
}
