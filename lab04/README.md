# lab04 — Каталог фільмів (лабораторна робота 4)

Консольний застосунок і HTTP-сервіс для варіанта 17 / предметної області № 2 «Каталог фільмів». Робота завершує наскрізний проєкт: файли, JSON, HTTP-клієнт, shelf, тести й документація.

## Чому така структура програми

Обрано канонічну структуру пакета Dart, а не один файл у `bin/`:

| Шлях | Роль |
|------|------|
| `bin/lab04.dart` | лише точка входу: розбір CLI, `import` / `fetch` / `list` / `serve` |
| `lib/lab04.dart` | фасад з `export` — тести й споживачі імпортують пакет, а не шлях до реалізації |
| `lib/src/` | реалізація (Film, JSON/CSV, HTTP-клієнт, CLI, сховище) |
| `lib/src/server/app.dart` | маршрути shelf і middleware |
| `test/` | ≥10 модульних тестів без мережі |
| `data/` | `films.json`, `catalog.csv` для демо |

Логіку не тримаємо в `bin/`: код звідти не імпортується в тести — це прямий критерій методички. Розділення `lib/` і `lib/src/` ховає деталі за фасадом і повторно використовує модель з попередніх робіт.

## Чому такі типи даних

- **`Film`** — незмінний клас із `final`-полями (як у ЛР2): один тип і для JSON, і для CSV, і для HTTP.
- **`Genre`** — `enum` з міткою `label`, щоб фільтр CLI і query `genre` порівнювали рядок однаково.
- **`JsonFilmStore`** — список `List<Film>` у файлі; `toJson` / `fromJson` вручну, без кодогенерації.
- **`Object?` після `jsonDecode`** — одразу звуження через `is List` / `is Map`, далі `as String` / `as num`. Тип `dynamic` у бібліотеці не залишається.
- **`FilmRepository`** — in-memory `Map` за кодом фільму: швидко для CLI і для Handler у тестах.
- **Записи `({List<Film> films, List<String> errors})`** — результат потокового CSV без окремого DTO-класу.

## Залежності з pub.dev

| Пакет | Навіщо | Що розглядалося як альтернатива |
|-------|--------|----------------------------------|
| `args` | команди й опції CLI (`list`, `import`, `fetch`, `serve`, `--data-dir`, `--limit`, `--genre`, `--verbose`, `--help`) | власний розбір `argv` — крихкий і без довідки |
| `path` | `p.join` для шляхів до JSON/CSV | конкатенація з `\` / `/` — ламається між ОС |
| `http` | REST-клієнт до Ghibli API, `http.Client` + `finally` | `dart:io HttpClient` — багатослівніше |
| `shelf` | власний HTTP-сервіс | сирий `HttpServer` — більше ручної роботи |
| `shelf_router` | маршрути `/items`, `/items/<id>` | лише `shelf` без router — ручний розбір шляху |
| `test` (dev) | модульні тести | обов’язковий з методички; у `dependencies` не ставлять |
| `lints` (dev) | `package:lints/recommended.yaml` для `dart analyze` | слабший набір правил |

Чому `test` у `dev_dependencies`: тести не потрібні тому, хто лише запускає каталог; у `dependencies` їх би тягнув кожен залежний пакет.

Зовнішнє API: [Ghibli API](https://ghibliapi.vercel.app/films) без ключа. Секрети не використовуються; `.gitignore` містить `.dart_tool/`, `build/`, `.env`, `secrets.json`.

## `!`, `late`, `dynamic`

Оператор `!` не використовується. `jsonDecode` зберігається як `Object?` і звужується перевірками типу. `late` є лише в тестах (`setUp` готує каталог, тимчасову теку й `Handler`) — шаблон `package:test`.

## Команди

```bash
dart run bin/lab04.dart --help
dart run bin/lab04.dart import --data-dir data
dart run bin/lab04.dart list --data-dir data --limit 5 --genre драма
dart run bin/lab04.dart fetch --data-dir data --limit 3
dart run bin/lab04.dart serve --data-dir data
```

Сервіс: `GET /items`, `GET /items/<id>`, `POST /items` на `http://127.0.0.1:8080`.

## Перевірка

Вивід `dart analyze` і `dart test` збережено в `docs/lab04_analyze.txt` та `docs/lab04_test.txt`.

```bash
dart analyze
dart test
dart format .
dart pub deps --style=compact
dart pub outdated
dart compile exe bin/lab04.dart -o build/lab04.exe
```

Порівняння старту довідки (на цій машині): `dart run` ≈ 1961 мс, `lab04.exe` ≈ 26 мс.

## Відеозапис

Посилання на відео 3–5 хв додається здобувачкою під час здачі в dl.nure.ua.
