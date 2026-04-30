import '../utils/date_utils.dart';
import 'log_enums.dart';

class DailyLog {
  const DailyLog({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
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
  final DateTime updatedAt;
  final String dateKey;
  final Mood mood;
  final Energy energy;
  final Focus focus;
  final Sleep sleep;
  final String note;
  final FrequencyTag frequency;
  final String generatedSignalText;

  DailyLog copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dateKey,
    Mood? mood,
    Energy? energy,
    Focus? focus,
    Sleep? sleep,
    String? note,
    FrequencyTag? frequency,
    String? generatedSignalText,
  }) {
    return DailyLog(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dateKey: dateKey ?? this.dateKey,
      mood: mood ?? this.mood,
      energy: energy ?? this.energy,
      focus: focus ?? this.focus,
      sleep: sleep ?? this.sleep,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      generatedSignalText: generatedSignalText ?? this.generatedSignalText,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dateKey': dateKey,
      'mood': mood.name,
      'energy': energy.name,
      'focus': focus.name,
      'sleep': sleep.name,
      'frequency': frequency.name,
      'soundtrack': frequency.name,
      'note': note,
      'generatedSignalText': generatedSignalText,
    };
  }

  static DailyLog fromMap(Map<dynamic, dynamic> map) {
    final DateTime createdAt =
        _dateTimeFromMap(map, 'createdAt') ?? DateTime.now();
    final DateTime updatedAt = _dateTimeFromMap(map, 'updatedAt') ?? createdAt;
    final String? frequencyName =
        _stringFromMap(map, 'frequency') ?? _stringFromMap(map, 'soundtrack');
    return DailyLog(
      id:
          _stringFromMap(map, 'id') ??
          createdAt.microsecondsSinceEpoch.toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      dateKey: _stringFromMap(map, 'dateKey') ?? dateKeyFor(createdAt),
      mood: enumByName(Mood.values, _stringFromMap(map, 'mood'), Mood.calm),
      energy: enumByName(
        Energy.values,
        _stringFromMap(map, 'energy'),
        Energy.steady,
      ),
      focus: enumByName(
        Focus.values,
        _stringFromMap(map, 'focus'),
        Focus.gentle,
      ),
      sleep: enumByName(Sleep.values, _stringFromMap(map, 'sleep'), Sleep.okay),
      note: _stringFromMap(map, 'note') ?? '',
      frequency: enumByName(
        FrequencyTag.values,
        frequencyName,
        FrequencyTag.lofi,
      ),
      generatedSignalText: _stringFromMap(map, 'generatedSignalText') ?? '',
    );
  }

  static DateTime? _dateTimeFromMap(Map<dynamic, dynamic> map, String key) {
    final Object? value = map[key];
    return value is String ? DateTime.tryParse(value) : null;
  }

  static String? _stringFromMap(Map<dynamic, dynamic> map, String key) {
    final Object? value = map[key];
    return value is String ? value : null;
  }
}

typedef LunaEntry = DailyLog;

List<LunaEntry> sortDailyEntries(Iterable<LunaEntry> entries) {
  final Map<String, LunaEntry> byDate = <String, LunaEntry>{};
  for (final LunaEntry entry in entries) {
    final LunaEntry? current = byDate[entry.dateKey];
    if (current == null || entry.updatedAt.isAfter(current.updatedAt)) {
      byDate[entry.dateKey] = entry;
    }
  }
  final List<LunaEntry> sorted = byDate.values.toList();
  sorted.sort((LunaEntry first, LunaEntry second) {
    final int dateCompare = second.dateKey.compareTo(first.dateKey);
    if (dateCompare != 0) {
      return dateCompare;
    }
    return second.updatedAt.compareTo(first.updatedAt);
  });
  return sorted;
}
