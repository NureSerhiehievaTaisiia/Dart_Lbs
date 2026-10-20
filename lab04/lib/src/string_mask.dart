import 'constants.dart';

/// Маскування коду каталогу для показу у звіті.
extension CatalogCodeMasking on String {
  /// Замінює числову частину коду на зірочки.
  String get maskedCatalogCode {
    return replaceAllMapped(catalogCodePattern, (match) {
      if (match is! RegExpMatch) {
        return this;
      }
      final prefix = match.namedGroup('prefix');
      if (prefix == null) {
        return this;
      }
      return '$prefix-$maskedCodeNumber';
    });
  }
}
