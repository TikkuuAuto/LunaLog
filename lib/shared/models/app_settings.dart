import '../utils/date_utils.dart';
import 'log_enums.dart';

class AppSettings {
  const AppSettings({
    required this.language,
    required this.themeMode,
    required this.firstLaunchCompleted,
    required this.baseProgressLevel,
    required this.unlockedCompanions,
    required this.streakCountCached,
  });

  factory AppSettings.defaults() {
    return const AppSettings(
      language: AppLanguage.zh,
      themeMode: LunarThemeMode.dark,
      firstLaunchCompleted: true,
      baseProgressLevel: 1,
      unlockedCompanions: <String>[],
      streakCountCached: 0,
    );
  }

  final AppLanguage language;
  final LunarThemeMode themeMode;
  final bool firstLaunchCompleted;
  final int baseProgressLevel;
  final List<String> unlockedCompanions;
  final int streakCountCached;

  AppSettings copyWith({
    AppLanguage? language,
    LunarThemeMode? themeMode,
    bool? firstLaunchCompleted,
    int? baseProgressLevel,
    List<String>? unlockedCompanions,
    int? streakCountCached,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      firstLaunchCompleted: firstLaunchCompleted ?? this.firstLaunchCompleted,
      baseProgressLevel: baseProgressLevel ?? this.baseProgressLevel,
      unlockedCompanions: unlockedCompanions ?? this.unlockedCompanions,
      streakCountCached: streakCountCached ?? this.streakCountCached,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'language': language.name,
      'themeMode': themeMode.name,
      'firstLaunchCompleted': firstLaunchCompleted,
      'baseProgressLevel': baseProgressLevel,
      'unlockedCompanions': unlockedCompanions,
      'streakCountCached': streakCountCached,
    };
  }

  static AppSettings fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return AppSettings.defaults();
    }
    return AppSettings(
      language: enumByName(
        AppLanguage.values,
        map['language'] as String?,
        AppLanguage.zh,
      ),
      themeMode: enumByName(
        LunarThemeMode.values,
        map['themeMode'] as String?,
        LunarThemeMode.dark,
      ),
      firstLaunchCompleted: map['firstLaunchCompleted'] as bool? ?? true,
      baseProgressLevel: map['baseProgressLevel'] as int? ?? 1,
      unlockedCompanions:
          (map['unlockedCompanions'] as List?)?.cast<String>() ?? <String>[],
      streakCountCached: map['streakCountCached'] as int? ?? 0,
    );
  }
}
