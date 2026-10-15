/// Один фільм каталогу після успішного розбору рядка.
typedef FilmRecord = ({
  String code,
  String title,
  String director,
  int year,
  int durationMinutes,
  String genre,
  double rating,
  DateTime watchedOn,
});

/// Результат розбору: або запис [film], або текст [error].
///
/// Обидва поля одночасно не заповнюються.
typedef ParseResult = ({FilmRecord? film, String? error});
