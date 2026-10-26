/// Вид картини. Набір підтипів закритий, тож switch перевіряється на вичерпність.
sealed class PictureKind {
  /// Створює вид картини.
  const PictureKind();

  /// Коротка назва виду.
  String get label;
}

/// Повнометражний фільм.
final class FeaturePicture extends PictureKind {
  /// Створює повнометражний вид.
  const FeaturePicture();

  @override
  String get label => 'повнометражний';
}

/// Короткий метр.
final class ShortPicture extends PictureKind {
  /// Створює короткий метр із поясненням [note].
  const ShortPicture({this.note = 'до 40 хвилин'});

  /// Пояснення, чому картину віднесено до короткого метра.
  final String note;

  @override
  String get label => 'короткий метр';
}

/// Окремий епізод серіалу.
final class EpisodePicture extends PictureKind {
  /// Створює епізод сезону [season] з номером [episode].
  const EpisodePicture({required this.season, required this.episode});

  /// Номер сезону.
  final int season;

  /// Номер епізоду в сезоні.
  final int episode;

  @override
  String get label => 'епізод серіалу';
}

/// Документальна стрічка.
final class DocumentaryPicture extends PictureKind {
  /// Створює документальний вид.
  const DocumentaryPicture();

  @override
  String get label => 'документальний';
}

/// Текстовий опис [kind] без гілки default.
String describeKind(PictureKind kind) => switch (kind) {
  FeaturePicture() => 'повнометражний фільм',
  ShortPicture(:final note) => 'короткий метр ($note)',
  EpisodePicture(:final season, :final episode) =>
    'серія, сезон $season, епізод $episode',
  DocumentaryPicture() => 'документальна стрічка',
};
