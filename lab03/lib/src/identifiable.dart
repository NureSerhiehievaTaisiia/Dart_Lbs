/// Сутність, яка вміє повідомити власний ідентифікатор.
abstract interface class Identifiable {
  /// Стабільний ідентифікатор у каталозі.
  String get id;
}
