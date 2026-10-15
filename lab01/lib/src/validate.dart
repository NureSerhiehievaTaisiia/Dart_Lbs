import 'constants.dart';
import 'types.dart';

/// Перевіряє діапазони полів [film] на дату [today].
///
/// Порожній список означає, що запис придатний до агрегації.
List<String> validateFilm(FilmRecord film, {required DateTime today}) {
  final violations = <String>[];

  if (film.year < minReleaseYear || film.year > maxReleaseYear) {
    violations.add(
      'рік ${film.year} поза межами $minReleaseYear–$maxReleaseYear',
    );
  }
  if (film.durationMinutes < minDurationMinutes ||
      film.durationMinutes > maxDurationMinutes) {
    violations.add(
      'тривалість ${film.durationMinutes} хв поза межами '
      '$minDurationMinutes–$maxDurationMinutes',
    );
  }
  if (film.rating < minRating || film.rating > maxRating) {
    violations.add('оцінка ${film.rating} поза межами $minRating–$maxRating');
  }

  final current = DateTime(today.year, today.month, today.day);
  final watched = DateTime(
    film.watchedOn.year,
    film.watchedOn.month,
    film.watchedOn.day,
  );
  if (watched.isAfter(current)) {
    violations.add(
      'дата перегляду ${film.watchedOn.toIso8601String()} у майбутньому',
    );
  }

  return violations;
}
