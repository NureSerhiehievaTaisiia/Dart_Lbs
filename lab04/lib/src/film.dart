import 'constants.dart';
import 'freshness.dart';
import 'genre.dart';
import 'identifiable.dart';

/// Незмінний фільм каталогу.
///
/// Первинний конструктор оголошує поля й генеративний конструктор разом.
/// Константним він не зроблений: [DateTime] не має константного конструктора.
class Film(
  final String code,
  final String title,
  final String director,
  final int year,
  final int durationMinutes,
  final Genre genre,
  final double rating,
  final DateTime watchedOn,
) extends DatedEntry with Freshness implements Identifiable {
  /// Розбирає рядок каталогу або повертає null, якщо формат пошкоджено.
  static Film? tryParseCsv(String line) {
    final parts = line.split(fieldSeparator);
    if (parts.length != expectedFieldCount) {
      return null;
    }

    final code = parts[0].trim();
    if (catalogCodePattern.firstMatch(code) == null) {
      return null;
    }

    final title = parts[1].trim();
    final director = parts[2].trim();
    final genre = Genre.tryParse(parts[5]);
    final year = int.tryParse(parts[3].trim());
    final durationMinutes = int.tryParse(parts[4].trim());
    final rating = double.tryParse(parts[6].trim());
    final watchedOn = DateTime.tryParse(parts[7].trim());
    if (title.isEmpty ||
        director.isEmpty ||
        genre == null ||
        year == null ||
        durationMinutes == null ||
        rating == null ||
        watchedOn == null) {
      return null;
    }

    return Film(
      code,
      title,
      director,
      year,
      durationMinutes,
      genre,
      rating,
      watchedOn,
    );
  }

  /// Іменований конструктор для рядка, який вже має бути коректним.
  factory Film.fromCsv(String line) {
    final film = tryParseCsv(line);
    if (film == null) {
      throw FormatException('Рядок не відповідає формату каталогу.');
    }
    return film;
  }

  static final Map<String, Film> _cache = {};

  /// Повертає раніше створений фільм з тим самим [code] або зберігає новий.
  factory Film.cached({
    required String code,
    required String title,
    required String director,
    required int year,
    required int durationMinutes,
    required Genre genre,
    required double rating,
    required DateTime watchedOn,
  }) {
    final existing = _cache[code];
    if (existing != null) {
      return existing;
    }
    final created = Film(
      code,
      title,
      director,
      year,
      durationMinutes,
      genre,
      rating,
      watchedOn,
    );
    _cache[code] = created;
    return created;
  }

  /// Очищає кеш фабрики [Film.cached].
  static void clearCache() => _cache.clear();

  @override
  String get id => code;

  @override
  DateTime get eventDate => watchedOn;

  /// Коротка підписана назва.
  String get label => '$title ($year)';

  /// Збирає JSON-карту з явними типами значень.
  Map<String, Object?> toJson() => {
    'code': code,
    'title': title,
    'director': director,
    'year': year,
    'durationMinutes': durationMinutes,
    'genre': genre.label,
    'rating': rating,
    'watchedOn': watchedOn.toIso8601String(),
  };

  /// Будує [Film] з JSON-карти після jsonDecode.
  factory Film.fromJson(Map<String, Object?> json) {
    final genre = Genre.tryParse(json['genre'] as String);
    if (genre == null) {
      throw FormatException('Невідомий жанр: ${json['genre']}');
    }
    return Film(
      json['code'] as String,
      json['title'] as String,
      json['director'] as String,
      (json['year'] as num).toInt(),
      (json['durationMinutes'] as num).toInt(),
      genre,
      (json['rating'] as num).toDouble(),
      DateTime.parse(json['watchedOn'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Film &&
        other.code == code &&
        other.title == title &&
        other.director == director &&
        other.year == year &&
        other.durationMinutes == durationMinutes &&
        other.genre == genre &&
        other.rating == rating &&
        other.watchedOn == watchedOn;
  }

  @override
  int get hashCode => Object.hash(
    code,
    title,
    director,
    year,
    durationMinutes,
    genre,
    rating,
    watchedOn,
  );

  @override
  String toString() => '$code $label, ${genre.label}, $rating';
}

/// Перевіряє діапазони полів [film] на дату [today].
List<String> validateFilm(Film film, {required DateTime today}) {
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
  if (film.ageOn(today) < 0) {
    violations.add('дата перегляду у майбутньому');
  }
  return violations;
}
