import '../utils/date_utils.dart';
import 'log_enums.dart';

class DailyLog {
  const DailyLog({
    required this.id,
    required this.createdAt,
    required this.dateKey,
    required this.mood,
    required this.energy,
    required this.focus,
    required this.sleep,
    required this.note,
    required this.frequency,
    required this.generatedSignalText,
  });

  final String id;
  final DateTime createdAt;
  final String dateKey;
  final Mood mood;
  final Energy energy;
  final Focus focus;
  final Sleep sleep;
  final String note;
  final FrequencyTag frequency;
  final String generatedSignalText;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'dateKey': dateKey,
      'mood': mood.name,
      'energy': energy.name,
      'focus': focus.name,
      'sleep': sleep.name,
      'soundtrack': frequency.name,
      'note': note,
      'generatedSignalText': generatedSignalText,
    };
  }

  static DailyLog fromMap(Map<dynamic, dynamic> map) {
    final DateTime createdAt =
        DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now();
    return DailyLog(
      id: map['id'] as String? ?? createdAt.microsecondsSinceEpoch.toString(),
      createdAt: createdAt,
      dateKey: map['dateKey'] as String? ?? dateKeyFor(createdAt),
      mood: enumByName(Mood.values, map['mood'] as String?, Mood.calm),
      energy: enumByName(
        Energy.values,
        map['energy'] as String?,
        Energy.steady,
      ),
      focus: enumByName(Focus.values, map['focus'] as String?, Focus.gentle),
      sleep: enumByName(Sleep.values, map['sleep'] as String?, Sleep.okay),
      note: map['note'] as String? ?? '',
      frequency: enumByName(
        FrequencyTag.values,
        map['soundtrack'] as String?,
        FrequencyTag.lofi,
      ),
      generatedSignalText: map['generatedSignalText'] as String? ?? '',
    );
  }
}

typedef LunaEntry = DailyLog;
