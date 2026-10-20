import 'package:lab04/lab04.dart';
import 'package:test/test.dart';

void main() {
  group('FilmRepository', () {
    test('save and findById', () {
      final repository = FilmRepository()..save(sampleFilm());
      expect(repository.findById('FM-001')?.title, 'Тіні забутих предків');
    });

    test('where filters by genre', () {
      final repository = FilmRepository([sampleFilm()]);
      expect(
        repository.where((film) => film.genre == Genre.drama),
        hasLength(1),
      );
      expect(repository.where((film) => film.genre == Genre.comedy), isEmpty);
    });
  });

  group('CLI', () {
    test('parseCli reads list command and options', () {
      final options = parseCli([
        'list',
        '--data-dir',
        'tmp',
        '--limit',
        '3',
        '--genre',
        'драма',
        '--verbose',
      ]);
      expect(options.command, 'list');
      expect(options.dataDir, 'tmp');
      expect(options.limit, 3);
      expect(options.genre, 'драма');
      expect(options.verbose, isTrue);
    });

    test('parseCli rejects invalid limit', () {
      expect(() => parseCli(['list', '--limit', '0']), throwsFormatException);
    });

    test('usageText mentions commands', () {
      expect(usageText(), contains('list'));
      expect(usageText(), contains('serve'));
    });
  });
}
