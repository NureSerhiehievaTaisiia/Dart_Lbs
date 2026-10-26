/// Роздільник полів у рядку каталогу.
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

/// Поріг високої оцінки.
const highRatingThreshold = 8.0;

/// Межа короткого метра в хвилинах.
const shortFilmMaxMinutes = 40;

/// Хронометраж, який ще зручно дивитися за один вечір.
const comfortableDurationMinutes = 130;

/// Рік, до якого фільм вважається класикою каталогу.
const classicYear = 1980;

/// Скільки днів запис вважається свіжим.
const freshLimitDays = 400;

/// Чим замінюється числова частина коду.
const maskedCodeNumber = '***';

/// Шаблон коду каталогу з іменованими групами prefix і number.
final catalogCodePattern = RegExp(r'^(?<prefix>[A-Z]{2})-(?<number>\d{3})$');
