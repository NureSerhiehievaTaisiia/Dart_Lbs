import 'freshness.dart';

/// Коротка нотатка критика. Це не фільм і не наслідує [Film].
class CriticNote(
  final String author,
  final String text,
  final DateTime writtenOn,
) extends DatedEntry with Freshness {
  @override
  DateTime get eventDate => writtenOn;

  @override
  String toString() => '$author: $text';
}
