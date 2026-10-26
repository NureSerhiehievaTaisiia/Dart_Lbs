import 'dart:isolate';

/// Значення, яке ізолят змінює у власній копії пам'яті.
int isolateProbe = 0;

/// Рахує прості числа до [limit] включно.
int countPrimes(int limit) {
  var count = 0;
  for (var number = 2; number <= limit; number++) {
    if (_isPrime(number)) {
      count++;
    }
  }
  return count;
}

bool _isPrime(int value) {
  if (value < 2) {
    return false;
  }
  var divisor = 2;
  while (divisor * divisor <= value) {
    if (value % divisor == 0) {
      return false;
    }
    divisor++;
  }
  return true;
}

/// Ставить [isolateProbe] у 42 і повертає це значення.
int mutateProbe() {
  isolateProbe = 42;
  return isolateProbe;
}

/// Порівнює локальний підрахунок і той самий підрахунок в [Isolate.run].
Future<({int localMs, int isolateMs, int localCount, int isolateCount})>
measurePrimes(int limit) async {
  final localWatch = Stopwatch()..start();
  final localCount = countPrimes(limit);
  localWatch.stop();

  final isolateWatch = Stopwatch()..start();
  final isolateCount = await Isolate.run(() => countPrimes(limit));
  isolateWatch.stop();

  return (
    localMs: localWatch.elapsedMilliseconds,
    isolateMs: isolateWatch.elapsedMilliseconds,
    localCount: localCount,
    isolateCount: isolateCount,
  );
}

/// Запускає зміну глобальної змінної в іншому ізоляті.
Future<({int inside, int outside})> probeIsolateMemory() async {
  final inside = await Isolate.run(mutateProbe);
  return (inside: inside, outside: isolateProbe);
}
