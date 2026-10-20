# lab04 — Каталог фільмів (лабораторна робота 4)

Канонічна структура пакета: CLI, JSON/CSV на диску, HTTP-клієнт, HTTP-сервіс на `shelf`.

## Структура

```
bin/lab04.dart          # точка входу CLI / запуск сервера
lib/lab04.dart          # фасад з export
lib/src/                # реалізація (не імпортувати ззовні пакета)
lib/src/server/app.dart # маршрути shelf
data/catalog.csv        # зразок для import
test/                   # ≥10 тестів
```

Логіку тримаємо в `lib/`, бо код із `bin/` неможливо імпортувати в тести.

## Залежності з pub.dev

| Пакет | Навіщо | Альтернатива |
|-------|--------|--------------|
| `args` | команди й опції CLI | власний розбір `argv` — відкинуто як крихкий |
| `path` | `p.join` для шляхів | конкатенація рядків — ламається між ОС |
| `http` | REST-клієнт до Ghibli API | `dart:io HttpClient` — багатослівніше |
| `shelf` + `shelf_router` | власний HTTP-сервіс | `shelf` alone без router — більше ручної роботи |
| `test` (dev) | модульні тести | обов’язковий за методичкою |
| `lints` (dev) | `dart analyze` | — |

Чому `test` у `dev_dependencies`: тести не потрібні користувачу пакета під час `dart pub get` у production-залежностях.

Зовнішнє API: [Ghibli API](https://ghibliapi.vercel.app/films) без ключа автентифікації.

## Команди

```bash
dart run bin/lab04.dart --help
dart run bin/lab04.dart import --data-dir data
dart run bin/lab04.dart list --data-dir data --limit 5 --genre драма
dart run bin/lab04.dart fetch --data-dir data --limit 3
dart run bin/lab04.dart serve --data-dir data
```

Сервіс: `GET /items`, `GET /items/<id>`, `POST /items` на `http://127.0.0.1:8080`.

## `!`, `late`, `dynamic`

Не використовуються. Результат `jsonDecode` одразу приводиться через `Film.fromJson` з явними `as String` / `as num`.

## Перевірка

```bash
dart analyze   # No issues found!
dart test
dart format .
dart compile exe bin/lab04.dart -o build/lab04.exe
```

Порівняння старту довідки (на цій машині): `dart run` ≈ 1961 мс, `lab04.exe` ≈ 26 мс.

## Відеозапис

Посилання на відео 3–5 хв додається здобувачкою під час здачі в dl.nure.ua.
