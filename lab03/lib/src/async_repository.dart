import 'dart:async';

import 'identifiable.dart';

/// Асинхронне сховище сутностей предметної області.
class AsyncRepository<T extends Identifiable> {
  /// Створює сховище з затримкою [ioDelay] на кожну операцію.
  AsyncRepository({Map<String, T>? items, this.ioDelay = defaultIoDelay})
    : _items = Map<String, T>.of(items ?? <String, T>{});

  /// Затримка, якою на цьому етапі імітується введення-виведення.
  final Duration ioDelay;

  final Map<String, T> _items;

  /// Чи тіло генератора [watchAll] уже почало виконання.
  bool generatorStarted = false;

  /// Повертає сутність за [id] або null.
  Future<T?> load(String id) async {
    await Future<void>.delayed(ioDelay);
    return _items[id];
  }

  /// Зберігає [item]. Порожній ідентифікатор є помилкою.
  Future<void> save(T item) async {
    if (item.id.isEmpty) {
      throw ArgumentError.value(item.id, 'id', 'ідентифікатор порожній');
    }
    await Future<void>.delayed(ioDelay);
    _items[item.id] = item;
  }

  /// Видаляє сутність. Повертає false, якщо такого ідентифікатора не було.
  Future<bool> delete(String id) async {
    await Future<void>.delayed(ioDelay);
    return _items.remove(id) != null;
  }

  /// Повертає копію всіх сутностей.
  Future<List<T>> loadAll() async {
    await Future<void>.delayed(ioDelay);
    return List<T>.unmodifiable(_items.values);
  }

  /// Видає сутності по одній. Тіло не виконується до підписки.
  Stream<T> watchAll({Duration step = defaultStep}) async* {
    generatorStarted = true;
    for (final item in _items.values) {
      await Future<void>.delayed(step);
      yield item;
    }
  }
}

/// Затримка операції сховища у демонстраційній програмі.
const defaultIoDelay = Duration(milliseconds: 300);

/// Крок між подіями потоку у демонстраційній програмі.
const defaultStep = Duration(milliseconds: 100);
