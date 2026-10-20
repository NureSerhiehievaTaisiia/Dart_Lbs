import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'film.dart';
import 'genre.dart';

/// Базова адреса відкритого API студії Ghibli без ключа.
const ghibliFilmsUrl = 'https://ghibliapi.vercel.app/films';

/// Клієнт зовнішнього REST API для доповнення каталогу.
class RemoteCatalogClient {
  /// Створює клієнт. Якщо [client] не передано, відкриває власний http.Client.
  RemoteCatalogClient({http.Client? client, this.endpoint = ghibliFilmsUrl})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;

  /// URL списку фільмів.
  final String endpoint;

  /// Завантажує фільми й перетворює їх на модель каталогу.
  Future<List<Film>> fetchFilms({int limit = 5}) async {
    try {
      final response = await _client.get(Uri.parse(endpoint));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'HTTP ${response.statusCode} для $endpoint',
          uri: Uri.parse(endpoint),
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Очікувався JSON-масив фільмів Ghibli.');
      }
      final films = <Film>[];
      var index = 1;
      for (final item in decoded.take(limit)) {
        films.add(_mapGhibli(item, index));
        index++;
      }
      return films;
    } on SocketException catch (error) {
      throw ClientException('Немає з\'єднання: $error');
    } on http.ClientException {
      rethrow;
    } on FormatException {
      rethrow;
    }
  }

  /// Закриває власний клієнт.
  void close() {
    if (_ownsClient) {
      _client.close();
    }
  }

  Film _mapGhibli(dynamic raw, int index) {
    final map = Map<String, Object?>.from(raw as Map);
    final code = 'GH-${index.toString().padLeft(3, '0')}';
    final title = map['title'] as String;
    final director = map['director'] as String? ?? 'Невідомий';
    final year = int.tryParse('${map['release_date']}') ?? 1980;
    final minutes = int.tryParse('${map['running_time']}') ?? 90;
    return Film(
      code,
      title,
      director,
      year,
      minutes,
      Genre.animation,
      8.0,
      DateTime(year, 1, 1),
    );
  }
}

/// Спрощений виняток клієнта для тестів і звіту.
class ClientException implements Exception {
  /// Створює опис відмови клієнта.
  ClientException(this.message);

  /// Текст помилки.
  final String message;

  @override
  String toString() => 'ClientException: $message';
}
