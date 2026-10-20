import 'package:lab04/lab04.dart';
import 'package:test/test.dart';

void main() {
  group('Film JSON', () {
    test('toJson/fromJson round-trip', () {
      final original = sampleFilm();
      final restored = Film.fromJson(original.toJson());
      expect(restored, original);
    });

    test('fromJson rejects unknown genre', () {
      expect(
        () => Film.fromJson({
          'code': 'FM-001',
          'title': 'X',
          'director': 'Y',
          'year': 2000,
          'durationMinutes': 100,
          'genre': 'немає',
          'rating': 5,
          'watchedOn': '2024-01-01T00:00:00.000',
        }),
        throwsFormatException,
      );
    });
  });
}
