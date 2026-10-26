import 'package:lab03/lab03.dart';
import 'package:test/test.dart';

Film _film({String code = 'FM-001', String title = 'Дюна', double rating = 8}) {
  return Film(
    code,
    title,
    'Режисер',
    2021,
    120,
    Genre.drama,
    rating,
    DateTime(2024, 1, 2),
  );
}

void main() {
  group('AsyncRepository', () {
    late AsyncRepository<Film> repository;

    setUp(() {
      repository = AsyncRepository<Film>(ioDelay: Duration.zero);
    });

    test('load returns null for an unknown id', () async {
      expect(await repository.load('FM-000'), isNull);
    });

    test('save then load returns the same film', () async {
      final film = _film();
      await repository.save(film);
      expect(await repository.load(film.id), film);
    });

    test('delete removes a stored film', () async {
      final film = _film();
      await repository.save(film);
      expect(await repository.delete(film.id), isTrue);
      expect(await repository.load(film.id), isNull);
    });

    test('delete of a missing id returns false', () async {
      expect(await repository.delete('немає'), isFalse);
    });

    test('save rejects an empty id', () {
      expect(repository.save(_film(code: '')), throwsA(isA<ArgumentError>()));
    });

    test('watchAll emits codes in insertion order', () async {
      final first = _film();
      final second = _film(code: 'FM-002', title: 'Земля', rating: 8.2);
      await repository.save(first);
      await repository.save(second);

      await expectLater(
        repository.watchAll(step: Duration.zero).map((film) => film.code),
        emitsInOrder(<Object>[first.code, second.code, emitsDone]),
      );
    });

    test('watchAll does not start before a subscription', () async {
      await repository.save(_film());
      repository.watchAll(step: Duration.zero);
      expect(repository.generatorStarted, isFalse);
      await repository.watchAll(step: Duration.zero).first;
      expect(repository.generatorStarted, isTrue);
    });
  });
}
