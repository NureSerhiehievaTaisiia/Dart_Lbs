import 'constants.dart';

/// Маскування коду каталогу для показу у звіті.
extension CatalogCodeMasking on String {
  /// Замінює числову частину коду на зірочки.
  String get maskedCatalogCode {
    return replaceAllMapped(catalogCodePattern, (match) {
      final captured = match as RegExpMatch;
      final prefix = captured.namedGroup('prefix');
      if (prefix == null) {
        return captured[0] ?? '';
      }
      return '$prefix-$maskedCodeNumber';
    });
  }
}
