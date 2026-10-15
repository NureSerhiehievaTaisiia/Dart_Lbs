import 'constants.dart';
import 'types.dart';

/// Фабрика предикатів: замикає поріг [minimum].
bool Function(FilmRecord film) ratingAtLeast(double minimum) {
  return (film) => film.rating >= minimum;
}

/// Назва фільму. Зручно передавати як tear-off у map.
String filmTitle(FilmRecord film) => film.title;

/// Середня оцінка. Для порожнього списку повертає 0.
double averageRating(List<FilmRecord> films) {
  if (films.isEmpty) {
    return 0;
  }
  final sum = films.fold<double>(0, (total, film) => total + film.rating);
  return sum / films.length;
}

/// Сумарна тривалість у хвилинах.
int totalDuration(List<FilmRecord> films) {
  return films.fold<int>(0, (total, film) => total + film.durationMinutes);
}

/// Фільми з оцінкою не нижче [highRatingThreshold].
List<FilmRecord> highRatedFilms(List<FilmRecord> films) {
  return films.where(ratingAtLeast(highRatingThreshold)).toList();
}

/// Групує фільми за жанром.
Map<String, List<FilmRecord>> groupByGenre(List<FilmRecord> films) {
  return films.fold<Map<String, List<FilmRecord>>>(
    <String, List<FilmRecord>>{},
    (groups, film) {
      groups.putIfAbsent(film.genre, () => <FilmRecord>[]).add(film);
      return groups;
    },
  );
}

/// Середня оцінка кожного жанру.
Map<String, double> averageRatingByGenre(List<FilmRecord> films) {
  final grouped = groupByGenre(films);
  return grouped.map((genre, items) {
    return MapEntry(genre, averageRating(items));
  });
}

/// Вік запису в днях на дату [today].
int ageInDays(FilmRecord film, DateTime today) {
  final current = DateTime(today.year, today.month, today.day);
  final watched = DateTime(
    film.watchedOn.year,
    film.watchedOn.month,
    film.watchedOn.day,
  );
  return current.difference(watched).inDays;
}

/// Шукає фільм за кодом. Якщо коду немає, повертає null.
FilmRecord? findByCode(List<FilmRecord> films, String code) {
  return films.where((film) => film.code == code).firstOrNull;
}

/// Бере перший фільм із високою оцінкою або перший запис списку.
FilmRecord pickHighlighted(List<FilmRecord> films) {
  return films.firstWhere(
    ratingAtLeast(highRatingThreshold),
    orElse: () => films.first,
  );
}

/// Сортує копію списку за [criterion].
///
/// [ascending] керує напрямом. Невідомий критерій завершує виклик помилкою.
List<FilmRecord> sortFilms(
  List<FilmRecord> films, {
  required int criterion,
  bool ascending = true,
}) {
  if (criterion != sortByYear && criterion != sortByRating) {
    throw ArgumentError.value(criterion, 'criterion', 'невідомий критерій');
  }

  final copy = [...films];
  copy.sort((a, b) {
    final compared = criterion == sortByYear
        ? a.year.compareTo(b.year)
        : a.rating.compareTo(b.rating);
    if (compared != 0) {
      return ascending ? compared : -compared;
    }
    final byTitle = a.title.compareTo(b.title);
    return ascending ? byTitle : -byTitle;
  });
  return copy;
}

/// Текстовий звіт за списком [films].
///
/// Рядки збирає [StringBuffer]. Іменовані параметри мають значення
/// за замовчуванням.
String buildReport(
  List<FilmRecord> films, {
  int topCount = defaultTopCount,
  bool ascending = false,
  String separator = defaultSeparator,
  DateTime? today,
}) {
  final clock = today ?? DateTime.now();
  final ranked = sortFilms(
    films,
    criterion: sortByRating,
    ascending: ascending,
  );
  final selected = ranked.take(topCount);
  final buffer = StringBuffer()
    ..writeln('Каталог фільмів')
    ..writeln('Записів у добірці: ${films.length}')
    ..writeln(
      'Середня оцінка: ${averageRating(films).toStringAsFixed(2)}'
      '$separator'
      'Сумарна тривалість: ${totalDuration(films)} хв',
    )
    ..writeln('Топ-$topCount за оцінкою:');

  var place = 1;
  for (final film in selected) {
    buffer.writeln(
      '$place. ${film.title}$separator${film.year}$separator'
      '${film.genre}$separator${film.rating}'
      '$separator${ageInDays(film, clock)} дн.',
    );
    place++;
  }
  return buffer.toString().trimRight();
}
