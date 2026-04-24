import 'package:flutter/material.dart' hide Focus;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/i18n/app_strings.dart';
import 'shared/models/app_settings.dart';
import 'shared/models/daily_log.dart';
import 'shared/models/log_enums.dart';
import 'shared/models/signal_state.dart';
import 'shared/services/signal_service.dart';
import 'shared/state/app_providers.dart';
import 'shared/storage/luna_storage.dart';
import 'shared/utils/date_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LunaStorage storage = await LunaStorage.open();
  runApp(
    LunaLogApp(
      storage: storage,
      initialEntries: storage.loadEntries(),
      initialSettings: storage.loadSettings(),
    ),
  );
}

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

  void _switchToLog() {
    setState(() => _tabIndex = 1);
  }

  void _returnHome() {
    setState(() => _tabIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final LunarThemeMode themeMode = ref.watch(themeModeProvider);
    final ThemeData theme = themeMode == LunarThemeMode.dark
        ? _buildDarkTheme()
        : _buildLightTheme();
    final AppStrings strings = ref.watch(appStringsProvider);

    return MaterialApp(
      title: 'LunaLog',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: IndexedStack(
          index: _tabIndex,
          children: <Widget>[
            HomePage(onLogNow: _switchToLog),
            LogPage(onSaveComplete: _returnHome),
            const ArchivePage(),
            const SettingsPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tabIndex,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home_rounded),
              label: strings.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.edit_note_outlined),
              selectedIcon: const Icon(Icons.edit_note_rounded),
              label: strings.log,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              selectedIcon: const Icon(Icons.calendar_month_rounded),
              label: strings.archive,
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune_rounded),
              label: strings.settings,
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() => _tabIndex = index);
          },
        ),
      ),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.onLogNow});

  final VoidCallback onLogNow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStrings strings = ref.watch(appStringsProvider);
    final LunaEntry? entry = ref.watch(latestLogProvider);
    final SignalState signalState = ref.watch(signalStateProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(strings.appTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(strings.appSubtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),
          SceneCard(strings: strings, entry: entry),
          const SizedBox(height: 16),
          _Panel(
            title: strings.todaySignal,
            child: Text(
              signalState.signalText,
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.statusSummary,
            trailing: FilledButton.icon(
              onPressed: onLogNow,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(strings.logNow),
            ),
            child: entry == null
                ? Text(strings.noEntryYet, style: theme.textTheme.bodyMedium)
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _StatusChip(
                        label: strings.mood,
                        value: moodLabel(strings, entry.mood),
                      ),
                      _StatusChip(
                        label: strings.energy,
                        value: energyLabel(strings, entry.energy),
                      ),
                      _StatusChip(
                        label: strings.focus,
                        value: focusLabel(strings, entry.focus),
                      ),
                      _StatusChip(
                        label: strings.sleep,
                        value: sleepLabel(strings, entry.sleep),
                      ),
                    ],
                  ),
          ),
          if (entry != null) ...<Widget>[
            const SizedBox(height: 16),
            _Panel(
              title: strings.stationBrief,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${strings.frequency}: ${frequencyLabel(strings, entry.frequency)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.note.isEmpty ? strings.noNote : entry.note,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LogPage extends ConsumerStatefulWidget {
  const LogPage({super.key, required this.onSaveComplete});

  final VoidCallback onSaveComplete;

  @override
  ConsumerState<LogPage> createState() => _LogPageState();
}

class _LogPageState extends ConsumerState<LogPage> {
  Mood _mood = Mood.calm;
  Energy _energy = Energy.steady;
  Focus _focus = Focus.gentle;
  Sleep _sleep = Sleep.okay;
  FrequencyTag _frequency = FrequencyTag.lofi;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final DateTime now = DateTime.now();
    final LunaEntry previewEntry = LunaEntry(
      id: now.microsecondsSinceEpoch.toString(),
      createdAt: now,
      dateKey: dateKeyFor(now),
      mood: _mood,
      energy: _energy,
      focus: _focus,
      sleep: _sleep,
      note: _noteController.text.trim(),
      frequency: _frequency,
      generatedSignalText: '',
    );
    final AppStrings strings = ref.read(appStringsProvider);
    saveLog(
      ref,
      LunaEntry(
        id: previewEntry.id,
        createdAt: now,
        dateKey: previewEntry.dateKey,
        mood: _mood,
        energy: _energy,
        focus: _focus,
        sleep: _sleep,
        note: _noteController.text.trim(),
        frequency: _frequency,
        generatedSignalText: buildSignal(strings, previewEntry),
      ),
    );
    widget.onSaveComplete();
    _noteController.clear();
    setState(() {
      _mood = Mood.calm;
      _energy = Energy.steady;
      _focus = Focus.gentle;
      _sleep = Sleep.okay;
      _frequency = FrequencyTag.lofi;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(
            strings.logTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            strings.logSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _SegmentBlock<Mood>(
            title: strings.mood,
            value: _mood,
            values: Mood.values,
            labelBuilder: (Mood value) => moodLabel(strings, value),
            onChanged: (Mood value) => setState(() => _mood = value),
          ),
          const SizedBox(height: 16),
          _SegmentBlock<Energy>(
            title: strings.energy,
            value: _energy,
            values: Energy.values,
            labelBuilder: (Energy value) => energyLabel(strings, value),
            onChanged: (Energy value) => setState(() => _energy = value),
          ),
          const SizedBox(height: 16),
          _SegmentBlock<Focus>(
            title: strings.focus,
            value: _focus,
            values: Focus.values,
            labelBuilder: (Focus value) => focusLabel(strings, value),
            onChanged: (Focus value) => setState(() => _focus = value),
          ),
          const SizedBox(height: 16),
          _SegmentBlock<Sleep>(
            title: strings.sleep,
            value: _sleep,
            values: Sleep.values,
            labelBuilder: (Sleep value) => sleepLabel(strings, value),
            onChanged: (Sleep value) => setState(() => _sleep = value),
          ),
          const SizedBox(height: 16),
          _SegmentBlock<FrequencyTag>(
            title: strings.frequency,
            value: _frequency,
            values: FrequencyTag.values,
            labelBuilder: (FrequencyTag value) =>
                frequencyLabel(strings, value),
            onChanged: (FrequencyTag value) =>
                setState(() => _frequency = value),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.note,
            child: TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(hintText: strings.noteHint),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.preview,
            child: Text(
              buildSignal(
                strings,
                LunaEntry(
                  id: 'preview',
                  createdAt: DateTime.now(),
                  dateKey: dateKeyFor(DateTime.now()),
                  mood: _mood,
                  energy: _energy,
                  focus: _focus,
                  sleep: _sleep,
                  note: _noteController.text.trim(),
                  frequency: _frequency,
                  generatedSignalText: '',
                ),
              ),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(strings.saveEntry),
            ),
          ),
        ],
      ),
    );
  }
}

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final List<LunaEntry> entries = ref.watch(archiveLogsProvider);
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final Set<int> loggedDays = entries
        .where(
          (LunaEntry entry) =>
              entry.createdAt.year == now.year &&
              entry.createdAt.month == now.month,
        )
        .map((LunaEntry entry) => entry.createdAt.day)
        .toSet();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(
            strings.archiveTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            strings.archiveSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _Panel(
            title: strings.monthView,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(daysInMonth, (int index) {
                final int day = index + 1;
                final bool active = loggedDays.contains(day);
                return Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$day',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: active
                          ? Theme.of(context).colorScheme.onPrimary
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.timeline,
            child: entries.isEmpty
                ? Text(strings.emptyArchive)
                : Column(
                    children: entries.map((LunaEntry entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ArchiveCard(strings: strings, entry: entry),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final AppLanguage language = ref.watch(appLanguageProvider);
    final LunarThemeMode themeMode = ref.watch(themeModeProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(
            strings.settingsTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            strings.settingsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _Panel(
            title: strings.language,
            child: SegmentedButton<AppLanguage>(
              segments: <ButtonSegment<AppLanguage>>[
                ButtonSegment<AppLanguage>(
                  value: AppLanguage.zh,
                  label: Text(strings.chinese),
                ),
                ButtonSegment<AppLanguage>(
                  value: AppLanguage.en,
                  label: Text(strings.english),
                ),
              ],
              selected: <AppLanguage>{language},
              onSelectionChanged: (Set<AppLanguage> values) {
                updateLanguage(ref, values.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.theme,
            child: SegmentedButton<LunarThemeMode>(
              segments: <ButtonSegment<LunarThemeMode>>[
                ButtonSegment<LunarThemeMode>(
                  value: LunarThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_outlined),
                  label: Text(strings.darkTheme),
                ),
                ButtonSegment<LunarThemeMode>(
                  value: LunarThemeMode.light,
                  icon: const Icon(Icons.light_mode_outlined),
                  label: Text(strings.lightTheme),
                ),
              ],
              selected: <LunarThemeMode>{themeMode},
              onSelectionChanged: (Set<LunarThemeMode> values) {
                updateThemeMode(ref, values.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.about,
            child: Text(
              strings.aboutText,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class SceneCard extends StatelessWidget {
  const SceneCard({super.key, required this.strings, required this.entry});

  final AppStrings strings;
  final LunaEntry? entry;

  @override
  Widget build(BuildContext context) {
    final bool hasEntry = entry != null;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color skyTop = entry == null
        ? scheme.primaryContainer
        : switch (entry!.mood) {
            Mood.calm => const Color(0xFF5561B1),
            Mood.bright => const Color(0xFF6D91E7),
            Mood.low => const Color(0xFF34385B),
            Mood.restless => const Color(0xFF8266B6),
            Mood.tender => const Color(0xFF7F73C8),
          };
    final Color skyBottom = entry == null
        ? scheme.surfaceContainerHighest
        : switch (entry!.sleep) {
            Sleep.poor => const Color(0xFF171A2B),
            Sleep.okay => const Color(0xFF232B46),
            Sleep.good => const Color(0xFF31436D),
          };

    return Container(
      height: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[skyTop, skyBottom],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 16,
            top: 8,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 76,
              decoration: const BoxDecoration(
                color: Color(0xFFD2D7E2),
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 28,
            child: _PixelBuilding(
              lightColor: hasEntry && entry!.energy == Energy.high
                  ? const Color(0xFFFFD36E)
                  : const Color(0xFFA8D6FF),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 26,
            child: _PixelRover(active: hasEntry && entry!.energy != Energy.low),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.sceneTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasEntry ? sceneSummary(strings, entry!) : strings.sceneEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PixelBuilding extends StatelessWidget {
  const _PixelBuilding({required this.lightColor});

  final Color lightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _block(24, 32, const Color(0xFF5B6184)),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _block(12, 10, const Color(0xFF9CC7FF)),
            const SizedBox(height: 3),
            _block(48, 44, const Color(0xFF7078A0), windows: true),
          ],
        ),
      ],
    );
  }

  Widget _block(
    double width,
    double height,
    Color color, {
    bool windows = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFF22263A), width: 1),
      ),
      child: windows
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List<Widget>.generate(
                  6,
                  (_) => Container(width: 6, height: 6, color: lightColor),
                ),
              ),
            )
          : null,
    );
  }
}

class _PixelRover extends StatelessWidget {
  const _PixelRover({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 24,
          height: 12,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF82C3FF) : const Color(0xFF8A8FA7),
            border: Border.all(color: const Color(0xFF212437)),
          ),
        ),
        const SizedBox(height: 2),
        Row(children: <Widget>[_wheel(), const SizedBox(width: 8), _wheel()]),
      ],
    );
  }

  Widget _wheel() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF2F3145),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ArchiveCard extends StatelessWidget {
  const _ArchiveCard({required this.strings, required this.entry});

  final AppStrings strings;
  final LunaEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                formatDate(entry.createdAt, strings.appLanguage),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                moodLabel(strings, entry.mood),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _StatusChip(
                label: strings.energy,
                value: energyLabel(strings, entry.energy),
              ),
              _StatusChip(
                label: strings.focus,
                value: focusLabel(strings, entry.focus),
              ),
              _StatusChip(
                label: strings.sleep,
                value: sleepLabel(strings, entry.sleep),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            entry.generatedSignalText.isEmpty
                ? buildSignal(strings, entry)
                : entry.generatedSignalText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
          if (entry.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              entry.note,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (trailing != null) ...<Widget>[trailing!],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$label 路 $value'),
    );
  }
}

class _SegmentBlock<T> extends StatelessWidget {
  const _SegmentBlock({
    required this.title,
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
  });

  final String title;
  final T value;
  final List<T> values;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: title,
      child: SegmentedButton<T>(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        segments: values
            .map(
              (T item) => ButtonSegment<T>(
                value: item,
                label: Text(labelBuilder(item)),
              ),
            )
            .toList(),
        selected: <T>{value},
        onSelectionChanged: (Set<T> selection) => onChanged(selection.first),
      ),
    );
  }
}

ThemeData _buildDarkTheme() {
  const ColorScheme scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB6B8FF),
    onPrimary: Color(0xFF21254A),
    secondary: Color(0xFF7DE0FF),
    onSecondary: Color(0xFF042531),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    surface: Color(0xFF121625),
    onSurface: Color(0xFFE8ECF8),
    surfaceContainerHighest: Color(0xFF262C43),
    onSurfaceVariant: Color(0xFFC1C6DA),
    outline: Color(0xFF666D88),
    primaryContainer: Color(0xFF2C335A),
    onPrimaryContainer: Color(0xFFE1E0FF),
    secondaryContainer: Color(0xFF1C3945),
    onSecondaryContainer: Color(0xFFD0F4FF),
    tertiary: Color(0xFFFFC1D6),
    onTertiary: Color(0xFF472533),
    tertiaryContainer: Color(0xFF613B49),
    onTertiaryContainer: Color(0xFFFFD9E4),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surfaceDim: Color(0xFF0E1320),
    surfaceBright: Color(0xFF32384F),
    inverseSurface: Color(0xFFE8ECF8),
    onInverseSurface: Color(0xFF1B2031),
    inversePrimary: Color(0xFF535D90),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFB6B8FF),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF0B1020),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF13192B),
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF171C2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

ThemeData _buildLightTheme() {
  const ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6069A3),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1F6C85),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFF7F7FB),
    onSurface: Color(0xFF1B1E2C),
    surfaceContainerHighest: Color(0xFFE5E8F2),
    onSurfaceVariant: Color(0xFF444A61),
    outline: Color(0xFF757B93),
    primaryContainer: Color(0xFFDEE0FF),
    onPrimaryContainer: Color(0xFF1A245A),
    secondaryContainer: Color(0xFFD0EEF7),
    onSecondaryContainer: Color(0xFF001F28),
    tertiary: Color(0xFF8C4D67),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E5),
    onTertiaryContainer: Color(0xFF3A0A20),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surfaceDim: Color(0xFFDADCE5),
    surfaceBright: Color(0xFFF7F7FB),
    inverseSurface: Color(0xFF303443),
    onInverseSurface: Color(0xFFF1F1F7),
    inversePrimary: Color(0xFFBEC2FF),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFF6069A3),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFFF1F4FA),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
