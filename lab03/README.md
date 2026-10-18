# lab03 — Каталог фільмів (лабораторна робота 3)

Асинхронний шар над моделлю ЛР2: `Future`, `Stream`, ізоляти, модульні тести.

## Структура

- `lib/src/async_repository.dart` — асинхронне сховище з імітацією затримок.
- `lib/src/async_demos.dart` — порівняння `Future.wait` / `.wait`, буфер потоку, помилки.
- `lib/src/workload.dart` — важкий підрахунок простих чисел і `Isolate.run`.
- `test/async_repository_test.dart` — щонайменше 6 тестів (`group`, `setUp`, `expectLater`).

## Типи та рішення

- Кожна операція сховища повертає `Future`, тож забутий `await` підсвічують лінти `unawaited_futures` і `discarded_futures`.
- Події статусу демонструють буфер `StreamController` до підписки.
- Ізолят застосовується лише до синхронно важкого підрахунку простих чисел; зміна `isolateProbe` в іншому ізоляті не видима в головному.

## Залежності

- `test` (dev) — модульні тести. Альтернатива `package:checks` відкинута: у методичних вказівках зазначено `package:test`.
- `lints` (dev) — статичний аналіз.

## `!`, `late`, `dynamic`

Не використовуються. Для навмисного «забутого await» у демонстрації застосовано `unawaited(...)`.

## Запуск

```bash
dart pub get
dart analyze
dart test
dart run
```

## dart analyze

```
Analyzing lab03...
No issues found!
```
