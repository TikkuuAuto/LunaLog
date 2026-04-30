import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/archive/archive_page.dart';
import '../features/home/home_page.dart';
import '../features/log/log_page.dart';
import '../features/settings/settings_page.dart';
import '../features/stats/stats_page.dart';
import '../shared/i18n/app_strings.dart';
import '../shared/models/app_settings.dart';
import '../shared/models/daily_log.dart';
import '../shared/models/log_enums.dart';
import '../shared/state/app_providers.dart';
import '../shared/storage/luna_storage.dart';
import '../shared/theme/luna_theme.dart';
import '../shared/widgets/luna_bottom_nav.dart';

class LunaLogApp extends StatefulWidget {
  const LunaLogApp({
    super.key,
    required this.storage,
    required this.initialEntries,
    required this.initialSettings,
  });

  final LunaStorage? storage;
  final List<LunaEntry> initialEntries;
  final AppSettings initialSettings;

  @override
  State<LunaLogApp> createState() => _LunaLogAppState();
}

class _LunaLogAppState extends State<LunaLogApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        logsRepositoryProvider.overrideWithValue(widget.storage),
        initialAppSettingsProvider.overrideWithValue(widget.initialSettings),
        initialLogsProvider.overrideWithValue(widget.initialEntries),
      ],
      child: const _LunaLogShell(),
    );
  }
}

class _LunaLogShell extends ConsumerStatefulWidget {
  const _LunaLogShell();

  @override
  ConsumerState<_LunaLogShell> createState() => _LunaLogShellState();
}

class _LunaLogShellState extends ConsumerState<_LunaLogShell> {
  int _tabIndex = 0;

  void _returnHome() {
    setState(() => _tabIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final LunarThemeMode themeMode = ref.watch(themeModeProvider);
    final ThemeData theme = themeMode == LunarThemeMode.dark
        ? buildDarkTheme()
        : buildLightTheme();
    final AppStrings strings = ref.watch(appStringsProvider);

    return MaterialApp(
      title: 'Luna Log',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: IndexedStack(
          index: _tabIndex,
          children: <Widget>[
            const HomePage(),
            const ArchivePage(),
            LogPage(onSaveComplete: _returnHome),
            const StatsPage(),
            const SettingsPage(),
          ],
        ),
        bottomNavigationBar: LunaBottomNav(
          selectedTabIndex: _tabIndex,
          strings: strings,
          onSelected: (int index) {
            setState(() => _tabIndex = index);
          },
        ),
      ),
    );
  }
}
