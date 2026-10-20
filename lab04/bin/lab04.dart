import 'dart:io';

import 'package:lab04/lab04.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main(List<String> arguments) async {
  late final CliOptions options;
  try {
    options = parseCli(arguments);
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
    return;
  }

  if (options.help) {
    stdout.writeln(usageText());
    return;
  }

  final store = JsonFilmStore(directory: options.dataDir);
  final repository = FilmRepository(await store.load());

  switch (options.command) {
    case 'list':
      await _list(repository, options);
    case 'import':
      await _import(store, repository, options);
    case 'fetch':
      await _fetch(store, repository, options);
    case 'serve':
      await _serve(repository);
    default:
      stdout.writeln(usageText());
  }
}

Future<void> _list(FilmRepository repository, CliOptions options) async {
  var films = repository.all;
  if (options.genre != null) {
    films = films.where((film) => film.genre.label == options.genre).toList();
  }
  films = films.take(options.limit).toList();
  if (options.verbose) {
    stdout.writeln('Записів після фільтра: ${films.length}');
  }
  for (final film in films) {
    stdout.writeln(
      '${film.code}\t${film.title}\t${film.genre.label}\t${film.rating}',
    );
  }
}

Future<void> _import(
  JsonFilmStore store,
  FilmRepository repository,
  CliOptions options,
) async {
  final csvPath = p.join(options.dataDir, 'catalog.csv');
  final file = File(csvPath);
  if (!file.existsSync()) {
    stderr.writeln('Не знайдено файл $csvPath');
    exitCode = 66;
    return;
  }
  final loaded = await loadFilmsFromCsv(file);
  for (final film in loaded.films) {
    repository.save(film);
  }
  await store.save(repository.all);
  stdout.writeln(
    'Імпортовано ${loaded.films.length}, помилок рядків: ${loaded.errors.length}',
  );
  if (options.verbose) {
    for (final error in loaded.errors) {
      stderr.writeln(error);
    }
  }
}

Future<void> _fetch(
  JsonFilmStore store,
  FilmRepository repository,
  CliOptions options,
) async {
  final client = RemoteCatalogClient();
  try {
    final remote = await client.fetchFilms(limit: options.limit);
    for (final film in remote) {
      repository.save(film);
    }
    await store.save(repository.all);
    stdout.writeln('Додано з мережі: ${remote.length}');
    for (final film in remote) {
      stdout.writeln('${film.code} ${film.title}');
    }
  } on SocketException catch (error) {
    stderr.writeln('Рівень 1, немає з\'єднання: $error');
    exitCode = 69;
  } on ClientException catch (error) {
    stderr.writeln('Рівень 1, клієнт: $error');
    exitCode = 69;
  } on HttpException catch (error) {
    stderr.writeln('Рівень 2, код відповіді: $error');
    exitCode = 69;
  } on FormatException catch (error) {
    stderr.writeln('Рівень 3, тіло відповіді: $error');
    exitCode = 65;
  } finally {
    client.close();
  }
}

Future<void> _serve(FilmRepository repository) async {
  final handler = buildHandler(repository);
  final server = await shelf_io.serve(
    handler,
    InternetAddress.loopbackIPv4,
    8080,
  );
  stdout.writeln('HTTP-сервіс: http://${server.address.host}:${server.port}');
}
