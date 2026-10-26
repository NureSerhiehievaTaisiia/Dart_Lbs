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

Оператор `!` і тип `dynamic` не використовуються. `late` є лише в `test/async_repository_test.dart`: поле `repository` створюється в `setUp`, бо кожен тест має власний екземпляр. Це шаблон `package:test`, не відкладена ініціалізація бібліотеки. Навмисний «забутий await» у демонстрації оформлено через `unawaited(...)`, щоб лінт `unawaited_futures` не вважав пропуск помилкою там, де він показаний свідомо.

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
