import 'dart:io';

import 'package:lab04/lab04.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('JsonFilmStore and CSV', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('lab04_');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('save and load JSON', () async {
      final store = JsonFilmStore(directory: tempDir.path);
      await store.save([sampleFilm()]);
      final loaded = await store.load();
      expect(loaded, hasLength(1));
      expect(loaded.first.code, 'FM-001');
    });

    test('loadFilmsFromCsv reads line by line', () async {
      final file = File(p.join(tempDir.path, 'in.csv'));
      await file.writeAsString(
        'FM-001;Тіні забутих предків;Сергій Параджанов;1965;97;драма;8.6;2023-11-02\n'
        'broken-line\n',
      );
      final result = await loadFilmsFromCsv(file);
      expect(result.films, hasLength(1));
      expect(result.errors, hasLength(1));
    });
  });
}
