import 'film.dart';
import 'identifiable.dart';

/// Синхронне сховище в пам'яті для CLI та HTTP-сервісу.
class MemoryRepository<T extends Identifiable> {
  /// Створює порожнє сховище або наповнює його з [seed].
  MemoryRepository([Iterable<T>? seed]) {
    if (seed != null) {
      for (final item in seed) {
        _items[item.id] = item;
      }
    }
  }

  final Map<String, T> _items = {};

  /// Усі сутності.
  List<T> get all => List<T>.unmodifiable(_items.values);

  /// Кількість записів.
  int get length => _items.length;

  /// Повертає сутність або null.
  T? findById(String id) => _items[id];

  /// Додає або замінює сутність.
  void save(T item) => _items[item.id] = item;

  /// Видаляє за ідентифікатором.
  bool delete(String id) => _items.remove(id) != null;

  /// Фільтрує сутності предикатом.
  List<T> where(bool Function(T item) test) =>
      _items.values.where(test).toList();
}

/// Зручний тип для каталогу фільмів.
typedef FilmRepository = MemoryRepository<Film>;
