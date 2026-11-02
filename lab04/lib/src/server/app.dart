import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../film.dart';
import '../genre.dart';
import '../memory_repository.dart';

/// JSON UTF-8 заголовок відповідей.
const jsonHeaders = <String, String>{
  'content-type': 'application/json; charset=utf-8',
};

/// Журналює метод, шлях і код відповіді у [log].
Middleware requestLogMiddleware({void Function(String line)? log}) {
  final write = log ?? (_) {};
  return (Handler inner) {
    return (Request request) async {
      final response = await inner(request);
      write(
        '${request.method} ${request.requestedUri.path} -> ${response.statusCode}',
      );
      return response;
    };
  };
}

/// Збирає Router для [repository].
Router buildRouter(FilmRepository repository) {
  final router = Router();

  router.get('/items', (Request request) async {
    final genre = request.url.queryParameters['genre'];
    final minRatingRaw = request.url.queryParameters['minRating'];
    final minRating = double.tryParse(minRatingRaw ?? '');

    var items = repository.all;
    if (genre != null && genre.isNotEmpty) {
      items = items.where((film) => film.genre.label == genre).toList();
    }
    if (minRating != null) {
      items = items.where((film) => film.rating >= minRating).toList();
    }

    return Response.ok(
      jsonEncode(items.map((film) => film.toJson()).toList()),
      headers: jsonHeaders,
    );
  });

  router.get('/items/<id>', (Request request, String id) async {
    final film = repository.findById(id);
    if (film == null) {
      return Response.notFound(
        jsonEncode({'error': 'фільм $id не знайдено'}),
        headers: jsonHeaders,
      );
    }
    return Response.ok(jsonEncode(film.toJson()), headers: jsonHeaders);
  });

  router.post('/items', (Request request) async {
    try {
      final raw = await request.readAsString();
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return Response.badRequest(
          body: jsonEncode({'error': 'очікувався JSON-об\'єкт'}),
          headers: jsonHeaders,
        );
      }
      final film = Film.fromJson(Map<String, Object?>.from(decoded));
      repository.save(film);
      return Response(
        201,
        body: jsonEncode(film.toJson()),
        headers: jsonHeaders,
      );
    } on FormatException catch (error) {
      return Response.badRequest(
        body: jsonEncode({'error': error.message}),
        headers: jsonHeaders,
      );
    } on TypeError catch (error) {
      return Response.badRequest(
        body: jsonEncode({'error': 'некоректне тіло: $error'}),
        headers: jsonHeaders,
      );
    }
  });

  return router;
}

/// Повний pipeline: лог + маршрути.
Handler buildHandler(
  FilmRepository repository, {
  void Function(String line)? log,
}) {
  final router = buildRouter(repository);
  return Pipeline()
      .addMiddleware(requestLogMiddleware(log: log))
      .addHandler(router.call);
}

/// Зразок фільму для тестів і стартового наповнення.
Film sampleFilm() {
  return Film(
    'FM-001',
    'Тіні забутих предків',
    'Сергій Параджанов',
    1965,
    97,
    Genre.drama,
    8.6,
    DateTime(2023, 11, 2),
  );
}
