import 'constants.dart';
import 'film.dart';
import 'genre.dart';
import 'picture_kind.dart';
import 'sample_data.dart';

/// Підсумок добірки: кількість, середня оцінка й сумарний хронометраж.
typedef CatalogSummary = ({int count, double averageRating, int totalMinutes});

/// Результат завантаження каталогу з текстових рядків.
typedef LoadOutcome = ({
  List<Film> valid,
  List<String> parseErrors,
  List<String> violations,
});

/// Розбирає [lines] і відділяє придатні фільми від помилок.
LoadOutcome loadCatalog(List<String> lines, {required DateTime today}) {
  final valid = <Film>[];
  final parseErrors = <String>[];
  final violations = <String>[];

  for (final line in lines) {
    final film = Film.tryParseCsv(line);
    if (film == null) {
      parseErrors.add(line);
      continue;
    }
    final found = validateFilm(film, today: today);
    if (found.isEmpty) {
      valid.add(film);
    } else {
      violations.add('${film.code}: ${found.join('; ')}');
    }
  }

  return (valid: valid, parseErrors: parseErrors, violations: violations);
}

/// Завантажує вбудований каталог.
LoadOutcome loadSample({required DateTime today}) {
  return loadCatalog(sampleLines, today: today);
}

/// Середня оцінка. Для порожньої добірки повертає 0.
double averageRating(Iterable<Film> films) {
  final list = films.toList();
  if (list.isEmpty) {
    return 0;
  }
  final sum = list.fold<double>(0, (total, film) => total + film.rating);
  return sum / list.length;
}

/// Згортає добірку в один запис із трьома числами.
CatalogSummary summarize(Iterable<Film> films) {
  final list = films.toList();
  final totalMinutes = list.fold<int>(
    0,
    (total, film) => total + film.durationMinutes,
  );
  return (
    count: list.length,
    averageRating: averageRating(list),
    totalMinutes: totalMinutes,
  );
}

/// Групує фільми за підписом жанру.
Map<String, List<Film>> groupByGenre(Iterable<Film> films) {
  return films.fold<Map<String, List<Film>>>(<String, List<Film>>{}, (
    groups,
    film,
  ) {
    groups.putIfAbsent(film.genre.label, () => <Film>[]).add(film);
    return groups;
  });
}

/// Визначає вид картини за жанром і хронометражем.
PictureKind classify(Film film) => switch (film) {
  Film(:final genre) when genre == Genre.documentary =>
    const DocumentaryPicture(),
  Film(:final durationMinutes) when durationMinutes <= shortFilmMaxMinutes =>
    const ShortPicture(),
  _ => const FeaturePicture(),
};

/// Рекомендація з охоронцем when.
String recommendation(Film film) => switch (film) {
  Film(:final rating, :final durationMinutes)
      when rating >= highRatingThreshold &&
          durationMinutes <= comfortableDurationMinutes =>
    'зручний перегляд із високою оцінкою',
  Film(:final rating) when rating >= highRatingThreshold =>
    'висока оцінка, довгий хронометраж',
  Film(:final year) when year < classicYear => 'класика каталогу',
  _ => 'звичайний запис каталогу',
};
