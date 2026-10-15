import 'constants.dart';
import 'types.dart';

/// Розбирає рядок [line] у запис фільму.
///
/// Очікувані помилки формату повертає в [ParseResult.error].
/// Для них не використовується try/catch.
ParseResult parseLine(String line) {
  final parts = line.split(fieldSeparator);
  if (parts.length != expectedFieldCount) {
    return (
      film: null,
      error: 'очікувалося $expectedFieldCount полів, отримано ${parts.length}',
    );
  }

  final code = parts[0].trim();
  if (catalogCodePattern.firstMatch(code) == null) {
    return (film: null, error: 'код «$code» не відповідає шаблону AA-000');
  }

  final title = parts[1].trim();
  final director = parts[2].trim();
  if (title.isEmpty || director.isEmpty) {
    return (film: null, error: 'назва або режисер порожні');
  }

  final year = int.tryParse(parts[3].trim());
  if (year == null) {
    return (film: null, error: 'рік «${parts[3].trim()}» не є цілим числом');
  }

  final durationMinutes = int.tryParse(parts[4].trim());
  if (durationMinutes == null) {
    return (
      film: null,
      error: 'тривалість «${parts[4].trim()}» не є цілим числом',
    );
  }

  final genre = parts[5].trim();
  if (genre.isEmpty) {
    return (film: null, error: 'жанр порожній');
  }

  final rating = double.tryParse(parts[6].trim());
  if (rating == null) {
    return (film: null, error: 'оцінка «${parts[6].trim()}» не є числом');
  }

  final watchedOn = DateTime.tryParse(parts[7].trim());
  if (watchedOn == null) {
    return (film: null, error: 'дата «${parts[7].trim()}» не розбирається');
  }

  return (
    film: (
      code: code,
      title: title,
      director: director,
      year: year,
      durationMinutes: durationMinutes,
      genre: genre,
      rating: rating,
      watchedOn: watchedOn,
    ),
    error: null,
  );
}

/// Маскує числову частину коду каталогу через replaceAllMapped.
String maskCatalogCode(String code) {
  return code.replaceAllMapped(catalogCodePattern, (match) {
    if (match is! RegExpMatch) {
      return code;
    }
    final prefix = match.namedGroup('prefix');
    if (prefix == null) {
      return code;
    }
    return '$prefix-$maskedCodeNumber';
  });
}

/// Лічильник, який замикає власну змінну processed.
typedef ProcessedCounter = ({void Function() increment, int Function() read});

/// Створює лічильник оброблених рядків.
///
/// Замикання утримує змінну processed, доки живе повернутий запис.
ProcessedCounter createProcessedCounter() {
  var processed = 0;
  return (
    increment: () {
      processed++;
    },
    read: () => processed,
  );
}
