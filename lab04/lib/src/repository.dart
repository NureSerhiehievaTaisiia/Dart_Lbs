import 'identifiable.dart';

/// Сховище сутностей, які вміють повідомляти власний ідентифікатор.
class Repository<T extends Identifiable> {
  final Map<String, T> _items = {};

  /// Кількість збережених сутностей.
  int get length => _items.length;

  /// Усі сутності в порядку додавання.
  List<T> get values => List<T>.unmodifiable(_items.values);

  /// Додає або замінює сутність за її ідентифікатором.
  void add(T item) => _items[item.id] = item;

  /// Додає кожну сутність з [items].
  void addAll(Iterable<T> items) {
    for (final item in items) {
      add(item);
    }
  }

  /// Повертає сутність за [id] або null.
  T? findById(String id) => _items[id];

  /// Сутності, для яких [test] повертає true.
  Iterable<T> where(bool Function(T item) test) => _items.values.where(test);
}
