/// Жанр фільму з підписом, який збігається з текстом у каталозі.
enum Genre(final String label) {
  /// Драма.
  drama('драма'),

  /// Фантастика.
  sciFi('фантастика'),

  /// Трилер.
  thriller('трилер'),

  /// Біографія.
  biography('біографія'),

  /// Комедія.
  comedy('комедія'),

  /// Мюзикл.
  musical('мюзикл'),

  /// Анімація.
  animation('анімація'),

  /// Воєнний фільм.
  war('воєнний'),

  /// Жахи.
  horror('жахи'),

  /// Документальний фільм.
  documentary('документальний');

  /// Повертає жанр за підписом або за іменем константи.
  static Genre? tryParse(String raw) {
    final key = raw.trim().toLowerCase();
    for (final genre in Genre.values) {
      if (genre.label == key || genre.name.toLowerCase() == key) {
        return genre;
      }
    }
    return null;
  }
}
