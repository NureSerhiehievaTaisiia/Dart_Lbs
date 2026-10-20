import 'dart:convert';

import 'package:lab04/lab04.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('HTTP handlers', () {
    late FilmRepository repository;
    late Handler handler;

    setUp(() {
      repository = FilmRepository([sampleFilm()]);
      handler = buildHandler(repository);
    });

    test('GET /items returns list', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/items')),
      );
      expect(response.statusCode, 200);
      final body = jsonDecode(await response.readAsString()) as List<dynamic>;
      expect(body, hasLength(1));
      expect(body.first['code'], 'FM-001');
    });

    test('GET /items filters by genre', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/items?genre=драма')),
      );
      final body = jsonDecode(await response.readAsString()) as List<dynamic>;
      expect(body, hasLength(1));
    });

    test('GET /items/<id> returns 404 for missing film', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/items/FM-999')),
      );
      expect(response.statusCode, 404);
    });

    test('GET /items/<id> returns film', () async {
      final response = await handler(
        Request('GET', Uri.parse('http://localhost/items/FM-001')),
      );
      expect(response.statusCode, 200);
      final body =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;
      expect(body['title'], 'Тіні забутих предків');
    });

    test('POST /items creates film', () async {
      final payload = Film(
        'FM-777',
        'Новий',
        'Автор',
        2024,
        100,
        Genre.comedy,
        7.1,
        DateTime(2024, 5, 1),
      ).toJson();
      final response = await handler(
        Request(
          'POST',
          Uri.parse('http://localhost/items'),
          body: jsonEncode(payload),
        ),
      );
      expect(response.statusCode, 201);
      expect(repository.findById('FM-777'), isNotNull);
    });

    test('POST /items returns 400 on bad body', () async {
      final response = await handler(
        Request(
          'POST',
          Uri.parse('http://localhost/items'),
          body: '{"code":1}',
        ),
      );
      expect(response.statusCode, 400);
    });
  });
}
