import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../i18n/app_strings.dart';
import '../models/app_settings.dart';
import '../models/daily_log.dart';
import '../models/log_enums.dart';
import '../models/signal_state.dart';
import '../services/log_insights.dart';
import '../services/signal_service.dart';
import '../storage/luna_storage.dart';
import '../utils/date_utils.dart';

final Provider<LunaStorage?> logsRepositoryProvider = Provider<LunaStorage?>(
  (Ref ref) => null,
);

final Provider<AppSettings> initialAppSettingsProvider = Provider<AppSettings>(
  (Ref ref) => AppSettings.defaults(),
);

final Provider<List<LunaEntry>> initialLogsProvider = Provider<List<LunaEntry>>(
  (Ref ref) => <LunaEntry>[],
);

final NotifierProvider<AppSettingsNotifier, AppSettings> appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettings>(AppSettingsNotifier.new);

final NotifierProvider<LogsNotifier, List<LunaEntry>> logsStateProvider =
    NotifierProvider<LogsNotifier, List<LunaEntry>>(LogsNotifier.new);

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.watch(initialAppSettingsProvider);
  }

  void update(AppSettings Function(AppSettings settings) update) {
    final AppSettings nextSettings = update(state);
    state = nextSettings;
    ref.read(logsRepositoryProvider)?.saveSettings(nextSettings);
  }
}

class LogsNotifier extends Notifier<List<LunaEntry>> {
  @override
  List<LunaEntry> build() {
    return sortDailyEntries(ref.watch(initialLogsProvider));
  }

  void add(LunaEntry entry) {
    state = sortDailyEntries(<LunaEntry>[
      entry,
      ...state.where((LunaEntry saved) => saved.dateKey != entry.dateKey),
    ]);
    ref.read(logsRepositoryProvider)?.saveEntry(entry);
  }
}

final Provider<AppLanguage> appLanguageProvider = Provider<AppLanguage>(
  (Ref ref) => ref.watch(appSettingsProvider).language,
);

final Provider<LunarThemeMode> themeModeProvider = Provider<LunarThemeMode>(
  (Ref ref) => ref.watch(appSettingsProvider).themeMode,
);

final Provider<AppStrings> appStringsProvider = Provider<AppStrings>(
  (Ref ref) => AppStrings(ref.watch(appLanguageProvider)),
);

final Provider<List<LunaEntry>> archiveLogsProvider = Provider<List<LunaEntry>>(
  (Ref ref) => ref.watch(logsStateProvider),
);

final Provider<LogInsights> logInsightsProvider = Provider<LogInsights>((
  Ref ref,
) {
  return buildLogInsights(ref.watch(archiveLogsProvider), DateTime.now());
});

final Provider<LunaEntry?> latestLogProvider = Provider<LunaEntry?>((Ref ref) {
  final List<LunaEntry> entries = ref.watch(archiveLogsProvider);
  final String todayKey = dateKeyFor(DateTime.now());
  for (final LunaEntry entry in entries) {
    if (entry.dateKey == todayKey) {
      return entry;
    }
  }
  return entries.isEmpty ? null : entries.first;
});

final Provider<LunaEntry?> todayLogProvider = Provider<LunaEntry?>((Ref ref) {
  final String todayKey = dateKeyFor(DateTime.now());
  for (final LunaEntry entry in ref.watch(archiveLogsProvider)) {
    if (entry.dateKey == todayKey) {
      return entry;
    }
  }
  return null;
});

final Provider<SignalState> signalStateProvider = Provider<SignalState>((
  Ref ref,
) {
  final AppStrings strings = ref.watch(appStringsProvider);
  return SignalState.fromEntry(
    entry: ref.watch(latestLogProvider),
    emptySignal: strings.emptySignal,
    fallbackSignalBuilder: (LunaEntry entry) => buildSignal(strings, entry),
  );
});

void saveLog(WidgetRef ref, LunaEntry entry) {
  ref.read(logsStateProvider.notifier).add(entry);
}

void updateLanguage(WidgetRef ref, AppLanguage language) {
  _updateSettings(ref, (AppSettings settings) {
    return settings.copyWith(language: language);
  });
}

void updateThemeMode(WidgetRef ref, LunarThemeMode themeMode) {
  _updateSettings(ref, (AppSettings settings) {
    return settings.copyWith(themeMode: themeMode);
  });
}

void _updateSettings(
  WidgetRef ref,
  AppSettings Function(AppSettings settings) update,
) {
  ref.read(appSettingsProvider.notifier).update(update);
}
