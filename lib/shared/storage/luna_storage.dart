import 'package:hive_flutter/hive_flutter.dart';

import '../models/app_settings.dart';
import '../models/daily_log.dart';

class LunaStorage {
  const LunaStorage._({
    required Box<dynamic> logsBox,
    required Box<dynamic> settingsBox,
  }) : _logsBox = logsBox,
       _settingsBox = settingsBox;

  static const String _logsBoxName = 'daily_logs';
  static const String _settingsBoxName = 'app_settings';
  static const String _settingsKey = 'settings';

  final Box<dynamic> _logsBox;
  final Box<dynamic> _settingsBox;

  static Future<LunaStorage> open() async {
    await Hive.initFlutter();
    final Box<dynamic> logsBox = await Hive.openBox<dynamic>(_logsBoxName);
    final Box<dynamic> settingsBox = await Hive.openBox<dynamic>(
      _settingsBoxName,
    );
    return LunaStorage._(logsBox: logsBox, settingsBox: settingsBox);
  }

  List<LunaEntry> loadEntries() {
    final List<LunaEntry> entries = _logsBox.values
        .whereType<Map<dynamic, dynamic>>()
        .map(LunaEntry.fromMap)
        .toList();
    return sortDailyEntries(entries);
  }

  Future<void> saveEntry(LunaEntry entry) {
    return _logsBox.put(entry.dateKey, entry.toMap());
  }

  AppSettings loadSettings() {
    final Object? value = _settingsBox.get(_settingsKey);
    return AppSettings.fromMap(value is Map<dynamic, dynamic> ? value : null);
  }

  Future<void> saveSettings(AppSettings settings) {
    return _settingsBox.put(_settingsKey, settings.toMap());
  }
}
