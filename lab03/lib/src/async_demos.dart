import 'dart:async';

import 'async_repository.dart';
import 'constants.dart';
import 'film.dart';

/// Тривалість однієї з трьох операцій у порівнянні Stopwatch.
const operationStep = Duration(milliseconds: 500);

/// Результат послідовного й одночасного очікування.
typedef TimingResult = ({int sequentialMs, int parallelMs});

/// Тексти двох способів зібрати помилку групи операцій.
typedef WaitErrorResult = ({String futureWait, String listWait});

/// Поведінка await for і listen, коли в потоці є помилка.
typedef StreamErrorResult = ({String awaitForLog, String listenLog});

Future<void> _pause(Duration step) => Future<void>.delayed(step);

Future<String> _namedPause(
  String name,
  Duration step, {
  bool fail = false,
}) async {
  await _pause(step);
  if (fail) {
    throw StateError('збій $name');
  }
  return name;
}

/// Три паузи по [step]: спершу послідовно, потім через Future.wait.
Future<TimingResult> measureSequentialAndParallel({
  Duration step = operationStep,
}) async {
  final sequential = Stopwatch()..start();
  await _pause(step);
  await _pause(step);
  await _pause(step);
  sequential.stop();

  final parallel = Stopwatch()..start();
  await Future.wait(<Future<void>>[_pause(step), _pause(step), _pause(step)]);
  parallel.stop();

  return (
    sequentialMs: sequential.elapsedMilliseconds,
    parallelMs: parallel.elapsedMilliseconds,
  );
}

/// Одна з трьох операцій завершується помилкою.
Future<WaitErrorResult> compareWaitErrors({
  Duration step = const Duration(milliseconds: 80),
}) async {
  Future<String> futureWait() async {
    try {
      final values = await Future.wait(<Future<String>>[
        _namedPause('альфа', step),
        _namedPause('бета', step),
        _namedPause('гамма', step, fail: true),
      ]);
      return 'успіх: $values';
    } on StateError catch (error) {
      return 'Future.wait: $error. Успішні результати в виняток не входять.';
    }
  }

  Future<String> listWait() async {
    try {
      final values = await <Future<String>>[
        _namedPause('альфа', step),
        _namedPause('бета', step),
        _namedPause('гамма', step, fail: true),
      ].wait;
      return 'успіх: $values';
    } on ParallelWaitError<List<String?>, List<AsyncError?>> catch (error) {
      final successes = error.values.whereType<String>().join(', ');
      final failures = error.errors.whereType<AsyncError>().length;
      return 'list.wait: успішні [$successes], помилок: $failures, '
          'тип ${error.runtimeType}.';
    }
  }

  return (futureWait: await futureWait(), listWait: await listWait());
}

/// Події, додані до підписки, лишаються в буфері одноразового потоку.
Future<List<String>> bufferedStatusEvents() async {
  final controller = StreamController<String>();
  // Події додано до listen — одноразовий контролер тримає їх у буфері.
  controller
    ..add('заплановано')
    ..add('дивляться')
    ..add('переглянуто');
  final received = <String>[];
  final done = Completer<void>();
  final subscription = controller.stream.listen(
    received.add,
    onDone: () {
      if (!done.isCompleted) {
        done.complete();
      }
    },
  );
  await controller.close();
  await done.future;
  await subscription.cancel();
  return received;
}

/// Текст помилки другої підписки на потік одноразової підписки.
Future<String> secondListenError() async {
  final controller = StreamController<int>();
  final first = controller.stream.listen((_) {});
  try {
    controller.stream.listen((_) {});
    return 'друга підписка несподівано вдалася';
  } on StateError catch (error) {
    return error.toString();
  } finally {
    await first.cancel();
    await controller.close();
  }
}

/// Широкомовний потік приймає дві підписки.
Future<String> broadcastListenOk() async {
  final controller = StreamController<int>.broadcast();
  final received = <int>[];
  final first = controller.stream.listen(received.add);
  final second = controller.stream.listen(received.add);
  controller.add(7);
  await Future<void>.delayed(Duration.zero);
  await first.cancel();
  await second.cancel();
  await controller.close();
  return 'подій у двох підписках: ${received.length}';
}

/// Порівнює await for і listen(cancelOnError: false).
Future<StreamErrorResult> compareStreamErrors() async {
  final awaitForLines = <String>[];
  try {
    await for (final value in _throwingGenerator()) {
      awaitForLines.add('подія $value');
    }
    awaitForLines.add('потік завершився');
  } on StateError catch (error) {
    awaitForLines.add('await for спіймав: $error');
  }

  final listenLines = <String>[];
  final done = Completer<void>();
  final controller = StreamController<int>();
  final subscription = controller.stream.listen(
    (value) => listenLines.add('подія $value'),
    onError: (Object error) => listenLines.add('onError: $error'),
    onDone: () {
      if (!done.isCompleted) {
        done.complete();
      }
    },
    cancelOnError: false,
  );
  controller
    ..add(1)
    ..addError(StateError('збій потоку'))
    ..add(2);
  await controller.close();
  await done.future.timeout(const Duration(seconds: 2));
  await subscription.cancel();

  return (
    awaitForLog: awaitForLines.join('; '),
    listenLog: listenLines.join('; '),
  );
}

Stream<int> _throwingGenerator() async* {
  yield 1;
  throw StateError('збій потоку');
}

/// Перші назви з високою оцінкою з потоку сховища.
Future<List<String>> takeHighlightedTitles(
  AsyncRepository<Film> repository,
) async {
  final titles = <String>[];
  final stream = repository
      .watchAll(step: Duration.zero)
      .where((film) => film.rating >= highRatingThreshold)
      .map((film) => film.title)
      .take(3);
  await for (final title in stream) {
    titles.add(title);
  }
  return titles;
}
