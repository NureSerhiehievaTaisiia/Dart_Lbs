import 'dart:async';
import 'dart:io';

import 'package:lab03/lab03.dart';

/// Верхня межа підрахунку простих чисел у демонстрації ізоляту.
const primeLimit = 1500000;

Future<void> main() async {
  final today = DateTime.now();
  final loaded = loadSample(today: today);
  final repository = AsyncRepository<Film>(ioDelay: Duration.zero);
  for (final film in loaded.valid) {
    await repository.save(film);
  }

  stdout.writeln('Каталог: ${loaded.valid.length} фільмів');

  // «Забутий await»: Future стартує, але значення тут ще немає.
  unawaited(repository.load('FM-999'));
  stdout.writeln(
    'Виклик load без await: Future запущено, результат у цьому рядку ще невідомий.',
  );

  final timing = await measureSequentialAndParallel();
  stdout.writeln(
    'Послідовно 3 x 500 мс: ${timing.sequentialMs} мс; '
    'Future.wait: ${timing.parallelMs} мс',
  );

  final waits = await compareWaitErrors();
  stdout
    ..writeln(waits.futureWait)
    ..writeln(waits.listWait);

  // try/catch без await не ловить помилку Future — її бачить лише onError.
  final asyncError = Completer<String>();
  try {
    unawaited(
      Future<void>.delayed(Duration.zero, () {
        throw StateError('асинхронна помилка без await');
      }).catchError((Object error) {
        asyncError.complete('onError/catchError спіймав: $error');
      }),
    );
  } on StateError catch (error) {
    asyncError.complete('синхронний try/catch спіймав: $error');
  }
  stdout.writeln(await asyncError.future.timeout(const Duration(seconds: 1)));
  stdout.writeln(
    'Висновок: try/catch навколо виклику без await помилку не бачить.',
  );

  final buffered = await bufferedStatusEvents();
  stdout.writeln('Буфер до підписки: ${buffered.join(', ')}');

  final secondListen = await secondListenError();
  stdout.writeln('Друга підписка: $secondListen');

  final broadcast = await broadcastListenOk();
  stdout.writeln('Широкомовний потік: $broadcast');

  final streamErrors = await compareStreamErrors();
  stdout
    ..writeln('await for: ${streamErrors.awaitForLog}')
    ..writeln('listen: ${streamErrors.listenLog}');

  final titles = await takeHighlightedTitles(repository);
  stdout.writeln('Конвеєр потоку: ${titles.join(', ')}');

  final lazy = AsyncRepository<Film>(ioDelay: Duration.zero);
  await lazy.save(loaded.valid.first);
  stdout.writeln('До підписки генератор стартував: ${lazy.generatorStarted}');
  await for (final film in lazy.watchAll(step: Duration.zero)) {
    stdout.writeln(
      'Перша подія ${film.code}, генератор стартував: ${lazy.generatorStarted}',
    );
    break;
  }

  final primes = await measurePrimes(primeLimit);
  stdout.writeln(
    'Прості до $primeLimit: локально ${primes.localCount} за ${primes.localMs} мс, '
    'ізолят ${primes.isolateCount} за ${primes.isolateMs} мс',
  );

  final probe = await probeIsolateMemory();
  stdout.writeln(
    'У ізоляті probe = ${probe.inside}, у головному ізоляті probe = ${probe.outside}',
  );
}
