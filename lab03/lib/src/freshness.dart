import 'constants.dart';

/// Сутність, у якої є дата події.
abstract class DatedEntry {
  /// Дата, від якої рахується вік запису.
  DateTime get eventDate;
}

/// Спільний підрахунок віку для класів, які не утворюють одну гілку успадкування.
mixin Freshness on DatedEntry {
  /// Вік події в днях відносно [today].
  int ageOn(DateTime today) {
    final current = DateTime(today.year, today.month, today.day);
    final event = DateTime(eventDate.year, eventDate.month, eventDate.day);
    return current.difference(event).inDays;
  }

  /// Чи подія ще в межах [freshLimitDays].
  bool isFreshOn(DateTime today) => ageOn(today) <= freshLimitDays;
}
