/// Роздільник полів у вхідному рядку каталогу.
const fieldSeparator = ';';

/// Скільки полів має містити коректний рядок.
const expectedFieldCount = 8;

/// Найраніший рік, який приймає валідатор.
const minReleaseYear = 1888;

/// Найпізніший рік випуску, який приймає валідатор.
const maxReleaseYear = 2026;

/// Найменша допустима тривалість у хвилинах.
const minDurationMinutes = 1;

/// Найбільша допустима тривалість у хвилинах.
const maxDurationMinutes = 240;

/// Нижня межа оцінки глядача.
const minRating = 0.0;

/// Верхня межа оцінки глядача.
const maxRating = 10.0;

/// Поріг оцінки для добірки «високий рейтинг».
const highRatingThreshold = 8.0;

/// Скільки позицій потрапляє у звіт, якщо виклик не змінив параметр.
const defaultTopCount = 5;

/// Роздільник колонок звіту за замовчуванням.
const defaultSeparator = ' | ';

/// Критерій сортування за роком випуску.
const sortByYear = 1;

/// Критерій сортування за оцінкою глядача.
const sortByRating = 2;

/// Чим замінюється числова частина коду під час маскування.
const maskedCodeNumber = '***';

/// Шаблон коду каталогу з іменованими групами prefix і number.
final catalogCodePattern = RegExp(r'^(?<prefix>[A-Z]{2})-(?<number>\d{3})$');
