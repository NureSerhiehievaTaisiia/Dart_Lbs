# lab02 — Каталог фільмів (лабораторна робота 2)

Варіант **17 → 2**: каталог фільмів. Програму ЛР1 переписано на об’єктну модель.

## Структура

- `bin/lab02.dart` — демонстрація рівності, кешу, домішки, sealed-ієрархії, сховища.
- `lib/src/film.dart` — незмінний клас із первинним конструктором, `fromCsv`, `cached`.
- `lib/src/picture_kind.dart` — `sealed` ієрархія видів картини.
- `lib/src/freshness.dart` — домішка `Freshness on DatedEntry`.
- `lib/src/repository.dart` — `Repository<T extends Identifiable>`.
- `lib/src/genre.dart` — перелічення з членами.

## Чому така модель

- Незмінний `Film` з `final`-полями захищає каталог від випадкових змін.
- Первинний конструктор (Dart 3.13) скорочує оголошення полів без зміни поведінки.
- Фабрика `Film.cached` показує сценарій, де генеративного конструктора недостатньо.
- `sealed PictureKind` дає вичерпний `switch` без `default`.
- Домішка `Freshness` спільна для `Film` і `CriticNote`, які не утворюють одну гілку успадкування.
- Обмеження `T extends Identifiable` у сховищі гарантує наявність `id`.

## Залежності

Лише `lints` у `dev_dependencies`. Runtime-пакети не потрібні.

## `!`, `late`, `dynamic`

Не використовуються.

## Запуск

```bash
dart pub get
dart analyze
dart run
```

## dart analyze

```
Analyzing lab02...
No issues found!
```
