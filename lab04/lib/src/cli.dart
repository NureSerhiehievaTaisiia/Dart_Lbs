import 'package:args/args.dart';

/// Результат розбору аргументів командного рядка.
class CliOptions {
  /// Створює набір опцій після успішного розбору.
  CliOptions({
    required this.command,
    required this.dataDir,
    required this.limit,
    required this.genre,
    required this.verbose,
    required this.help,
  });

  /// Обрана команда: list, import, fetch або serve.
  final String? command;

  /// Каталог із JSON-даними.
  final String dataDir;

  /// Обмеження кількості рядків у виводі.
  final int limit;

  /// Фільтр за жанром, якщо задано.
  final String? genre;

  /// Чи потрібні докладні повідомлення.
  final bool verbose;

  /// Чи просили довідку.
  final bool help;
}

/// Будує парсер з двома командами та трьома опціями.
ArgParser buildParser() {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Показати довідку.')
    ..addOption('data-dir', defaultsTo: 'data', help: 'Каталог для films.json.')
    ..addOption('limit', defaultsTo: '10', help: 'Скільки записів показати.')
    ..addOption('genre', help: 'Фільтр за жанром (наприклад, драма).')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Докладний вивід.');

  parser.addCommand('list');
  parser.addCommand('import');
  parser.addCommand('fetch');
  parser.addCommand('serve');
  return parser;
}

/// Розбирає [arguments] або кидає [FormatException].
CliOptions parseCli(List<String> arguments) {
  final parser = buildParser();
  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException {
    rethrow;
  }

  final limit = int.tryParse(results['limit'] as String);
  if (limit == null || limit < 1) {
    throw const FormatException('Опція --limit має бути додатним цілим.');
  }

  return CliOptions(
    command: results.command?.name,
    dataDir: results['data-dir'] as String,
    limit: limit,
    genre: results['genre'] as String?,
    verbose: results['verbose'] as bool,
    help: results['help'] as bool || results.command == null,
  );
}

/// Текст довідки для stdout.
String usageText() {
  final parser = buildParser();
  return 'Каталог фільмів (lab04)\n\n'
      'Команди:\n'
      '  list     показати локальний JSON-каталог\n'
      '  import   імпортувати CSV через openRead\n'
      '  fetch    доповнити каталог з Ghibli API\n'
      '  serve    запустити HTTP-сервіс shelf\n\n'
      '${parser.usage}';
}
