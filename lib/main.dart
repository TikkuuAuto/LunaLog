import 'package:flutter/material.dart';

void main() {
  runApp(const LunaLogApp());
}

enum AppLanguage { zh, en }

enum LunarThemeMode { dark, light }

enum Mood { calm, bright, low, restless, tender }

enum Energy { low, steady, high }

enum Focus { scattered, gentle, sharp }

enum Sleep { poor, okay, good }

enum FrequencyTag { lofi, lunarRadio, deepSpace }

class LunaEntry {
  const LunaEntry({
    required this.createdAt,
    required this.mood,
    required this.energy,
    required this.focus,
    required this.sleep,
    required this.note,
    required this.frequency,
  });

  final DateTime createdAt;
  final Mood mood;
  final Energy energy;
  final Focus focus;
  final Sleep sleep;
  final String note;
  final FrequencyTag frequency;
}

class LunaLogApp extends StatefulWidget {
  const LunaLogApp({super.key});

  @override
  State<LunaLogApp> createState() => _LunaLogAppState();
}

class _LunaLogAppState extends State<LunaLogApp> {
  AppLanguage _language = AppLanguage.zh;
  LunarThemeMode _themeMode = LunarThemeMode.dark;
  int _tabIndex = 0;
  final List<LunaEntry> _entries = <LunaEntry>[
    LunaEntry(
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      mood: Mood.calm,
      energy: Energy.steady,
      focus: Focus.gentle,
      sleep: Sleep.good,
      note: '想把今天记下来，像给月面基地留一条值班日志。',
      frequency: FrequencyTag.lofi,
    ),
  ];

  void _saveEntry(LunaEntry entry) {
    setState(() {
      _entries.insert(0, entry);
      _tabIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = _themeMode == LunarThemeMode.dark
        ? _buildDarkTheme()
        : _buildLightTheme();
    final AppStrings strings = AppStrings(_language);

    return MaterialApp(
      title: 'LunaLog',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        body: IndexedStack(
          index: _tabIndex,
          children: <Widget>[
            HomePage(
              strings: strings,
              latestEntry: _entries.isEmpty ? null : _entries.first,
              onLogNow: () => setState(() => _tabIndex = 1),
            ),
            LogPage(
              strings: strings,
              onSave: _saveEntry,
            ),
            ArchivePage(
              strings: strings,
              entries: _entries,
            ),
            SettingsPage(
              strings: strings,
              language: _language,
              themeMode: _themeMode,
              onLanguageChanged: (AppLanguage value) {
                setState(() => _language = value);
              },
              onThemeChanged: (LunarThemeMode value) {
                setState(() => _themeMode = value);
              },
            ),
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

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.strings,
    required this.latestEntry,
    required this.onLogNow,
  });

  final AppStrings strings;
  final LunaEntry? latestEntry;
  final VoidCallback onLogNow;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final LunaEntry? entry = latestEntry;
    final String signal = entry == null
        ? strings.emptySignal
        : buildSignal(strings, entry);

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
              signal,
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

class LogPage extends StatefulWidget {
  const LogPage({
    super.key,
    required this.strings,
    required this.onSave,
  });

  final AppStrings strings;
  final ValueChanged<LunaEntry> onSave;

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
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
    widget.onSave(
      LunaEntry(
        createdAt: DateTime.now(),
        mood: _mood,
        energy: _energy,
        focus: _focus,
        sleep: _sleep,
        note: _noteController.text.trim(),
        frequency: _frequency,
      ),
    );
    _noteController.clear();
    setState(() {
      _mood = Mood.calm;
      _energy = Energy.steady;
      _focus = Focus.gentle;
      _sleep = Sleep.okay;
      _frequency = FrequencyTag.lofi;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.strings.saved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = widget.strings;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(strings.logTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(strings.logSubtitle, style: Theme.of(context).textTheme.bodyMedium),
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
            labelBuilder: (FrequencyTag value) => frequencyLabel(strings, value),
            onChanged: (FrequencyTag value) => setState(() => _frequency = value),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.note,
            child: TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: strings.noteHint,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.preview,
            child: Text(
              buildSignal(
                strings,
                LunaEntry(
                  createdAt: DateTime.now(),
                  mood: _mood,
                  energy: _energy,
                  focus: _focus,
                  sleep: _sleep,
                  note: _noteController.text.trim(),
                  frequency: _frequency,
                ),
              ),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5),
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

class ArchivePage extends StatelessWidget {
  const ArchivePage({
    super.key,
    required this.strings,
    required this.entries,
  });

  final AppStrings strings;
  final List<LunaEntry> entries;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final Set<int> loggedDays = entries
        .where((LunaEntry entry) =>
            entry.createdAt.year == now.year && entry.createdAt.month == now.month)
        .map((LunaEntry entry) => entry.createdAt.day)
        .toSet();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(strings.archiveTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(strings.archiveSubtitle, style: Theme.of(context).textTheme.bodyMedium),
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.strings,
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  final AppStrings strings;
  final AppLanguage language;
  final LunarThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final ValueChanged<LunarThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: <Widget>[
          Text(strings.settingsTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          Text(strings.settingsSubtitle, style: Theme.of(context).textTheme.bodyMedium),
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
                onLanguageChanged(values.first);
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
                onThemeChanged(values.first);
              },
            ),
          ),
          const SizedBox(height: 16),
          _Panel(
            title: strings.about,
            child: Text(
              strings.aboutText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    required this.strings,
    required this.entry,
  });

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
            child: _PixelRover(
              active: hasEntry && entry!.energy != Energy.low,
            ),
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

  Widget _block(double width, double height, Color color, {bool windows = false}) {
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
                  (_) => Container(
                    width: 6,
                    height: 6,
                    color: lightColor,
                  ),
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
        Row(
          children: <Widget>[
            _wheel(),
            const SizedBox(width: 8),
            _wheel(),
          ],
        ),
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
  const _ArchiveCard({
    required this.strings,
    required this.entry,
  });

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
              _StatusChip(label: strings.energy, value: energyLabel(strings, entry.energy)),
              _StatusChip(label: strings.focus, value: focusLabel(strings, entry.focus)),
              _StatusChip(label: strings.sleep, value: sleepLabel(strings, entry.sleep)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            buildSignal(strings, entry),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
          if (entry.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              entry.note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.child,
    this.trailing,
  });

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
  const _StatusChip({
    required this.label,
    required this.value,
  });

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
      child: Text('$label · $value'),
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

class AppStrings {
  const AppStrings(this.appLanguage);

  final AppLanguage appLanguage;

  String get appTitle => appLanguage == AppLanguage.zh ? 'Luna Log / 月面日志' : 'Luna Log';
  String get appSubtitle => appLanguage == AppLanguage.zh
      ? '把今天的状态写进一座安静运转的月面基地。'
      : 'Turn today into a quiet lunar-base log.';
  String get home => appLanguage == AppLanguage.zh ? '首页' : 'Home';
  String get log => appLanguage == AppLanguage.zh ? '记录' : 'Log';
  String get archive => appLanguage == AppLanguage.zh ? '归档' : 'Archive';
  String get settings => appLanguage == AppLanguage.zh ? '设置' : 'Settings';
  String get todaySignal => appLanguage == AppLanguage.zh ? '今日信号' : 'Today\'s Signal';
  String get statusSummary => appLanguage == AppLanguage.zh ? '状态摘要' : 'Status Summary';
  String get logNow => appLanguage == AppLanguage.zh ? '记录今天' : 'Log Today';
  String get noEntryYet => appLanguage == AppLanguage.zh ? '今天还没有新的记录。' : 'No entry has been logged today.';
  String get stationBrief => appLanguage == AppLanguage.zh ? '基地简报' : 'Station Brief';
  String get frequency => appLanguage == AppLanguage.zh ? '频段' : 'Frequency';
  String get noNote => appLanguage == AppLanguage.zh ? '没有补充备注。' : 'No extra note today.';
  String get emptySignal => appLanguage == AppLanguage.zh
      ? '基地尚未收到今日回传。先记录一次状态，月面会亮起第一盏灯。'
      : 'The base has not received today\'s return signal yet. Log once to light the first window.';
  String get sceneTitle => appLanguage == AppLanguage.zh ? '月面场景' : 'Lunar Scene';
  String get sceneEmpty => appLanguage == AppLanguage.zh
      ? '基地处于待机状态，跑道安静，通信塔维持低功耗守望。'
      : 'The base is idle, the runway is quiet, and the relay tower stays on low power watch.';
  String get mood => appLanguage == AppLanguage.zh ? '情绪' : 'Mood';
  String get energy => appLanguage == AppLanguage.zh ? '能量' : 'Energy';
  String get focus => appLanguage == AppLanguage.zh ? '专注' : 'Focus';
  String get sleep => appLanguage == AppLanguage.zh ? '睡眠' : 'Sleep';
  String get logTitle => appLanguage == AppLanguage.zh ? '今日记录' : 'Daily Log';
  String get logSubtitle => appLanguage == AppLanguage.zh
      ? '快速写下今天的状态，生成一条月面信号。'
      : 'Capture today quickly and generate a lunar signal.';
  String get note => appLanguage == AppLanguage.zh ? '备注' : 'Note';
  String get noteHint => appLanguage == AppLanguage.zh
      ? '写一点今天的感受、碎片想法或想留给自己的话。'
      : 'Leave a short note, feeling, or small thought for today.';
  String get preview => appLanguage == AppLanguage.zh ? '信号预览' : 'Signal Preview';
  String get saveEntry => appLanguage == AppLanguage.zh ? '保存记录' : 'Save Entry';
  String get saved => appLanguage == AppLanguage.zh ? '已写入月面日志。' : 'Saved to lunar log.';
  String get archiveTitle => appLanguage == AppLanguage.zh ? '归档' : 'Archive';
  String get archiveSubtitle => appLanguage == AppLanguage.zh
      ? '以时间线和月视图回看这座基地的变化。'
      : 'Review the base through a timeline and a month grid.';
  String get monthView => appLanguage == AppLanguage.zh ? '月视图' : 'Month View';
  String get timeline => appLanguage == AppLanguage.zh ? '时间线' : 'Timeline';
  String get emptyArchive => appLanguage == AppLanguage.zh ? '还没有历史记录。' : 'No archive entries yet.';
  String get settingsTitle => appLanguage == AppLanguage.zh ? '设置' : 'Settings';
  String get settingsSubtitle => appLanguage == AppLanguage.zh
      ? '切换语言与主题，让基地更贴近你的节奏。'
      : 'Tune language and theme for your own orbit.';
  String get language => appLanguage == AppLanguage.zh ? '语言' : 'Language';
  String get chinese => appLanguage == AppLanguage.zh ? '中文' : 'Chinese';
  String get english => appLanguage == AppLanguage.zh ? '英文' : 'English';
  String get theme => appLanguage == AppLanguage.zh ? '主题' : 'Theme';
  String get darkTheme => appLanguage == AppLanguage.zh ? '深色' : 'Dark';
  String get lightTheme => appLanguage == AppLanguage.zh ? '浅色' : 'Light';
  String get about => appLanguage == AppLanguage.zh ? '关于' : 'About';
  String get aboutText => appLanguage == AppLanguage.zh
      ? 'Luna Log 是一个像素风月面基地情绪日志 MVP：首页展示场景与信号，记录页写入状态，归档页查看历史，设置页切换语言与主题。'
      : 'Luna Log is a pixel-art lunar-base mood journal MVP with a scene-driven home, a compact log flow, an archive view, and bilingual theme settings.';
}

String moodLabel(AppStrings strings, Mood value) {
  switch (value) {
    case Mood.calm:
      return strings.appLanguage == AppLanguage.zh ? '平静' : 'Calm';
    case Mood.bright:
      return strings.appLanguage == AppLanguage.zh ? '明亮' : 'Bright';
    case Mood.low:
      return strings.appLanguage == AppLanguage.zh ? '低落' : 'Low';
    case Mood.restless:
      return strings.appLanguage == AppLanguage.zh ? '躁动' : 'Restless';
    case Mood.tender:
      return strings.appLanguage == AppLanguage.zh ? '柔软' : 'Tender';
  }
}

String energyLabel(AppStrings strings, Energy value) {
  switch (value) {
    case Energy.low:
      return strings.appLanguage == AppLanguage.zh ? '偏低' : 'Low';
    case Energy.steady:
      return strings.appLanguage == AppLanguage.zh ? '稳定' : 'Steady';
    case Energy.high:
      return strings.appLanguage == AppLanguage.zh ? '高' : 'High';
  }
}

String focusLabel(AppStrings strings, Focus value) {
  switch (value) {
    case Focus.scattered:
      return strings.appLanguage == AppLanguage.zh ? '分散' : 'Scattered';
    case Focus.gentle:
      return strings.appLanguage == AppLanguage.zh ? '柔和' : 'Gentle';
    case Focus.sharp:
      return strings.appLanguage == AppLanguage.zh ? '清晰' : 'Sharp';
  }
}

String sleepLabel(AppStrings strings, Sleep value) {
  switch (value) {
    case Sleep.poor:
      return strings.appLanguage == AppLanguage.zh ? '不足' : 'Poor';
    case Sleep.okay:
      return strings.appLanguage == AppLanguage.zh ? '一般' : 'Okay';
    case Sleep.good:
      return strings.appLanguage == AppLanguage.zh ? '良好' : 'Good';
  }
}

String frequencyLabel(AppStrings strings, FrequencyTag value) {
  switch (value) {
    case FrequencyTag.lofi:
      return strings.appLanguage == AppLanguage.zh ? 'Lo-fi' : 'Lo-fi';
    case FrequencyTag.lunarRadio:
      return strings.appLanguage == AppLanguage.zh ? '月面电台' : 'Lunar Radio';
    case FrequencyTag.deepSpace:
      return strings.appLanguage == AppLanguage.zh ? '深空' : 'Deep Space';
  }
}

String sceneSummary(AppStrings strings, LunaEntry entry) {
  final String sky = switch (entry.mood) {
    Mood.calm => strings.appLanguage == AppLanguage.zh ? '夜空平稳' : 'steady sky',
    Mood.bright => strings.appLanguage == AppLanguage.zh ? '天幕偏亮' : 'bright horizon',
    Mood.low => strings.appLanguage == AppLanguage.zh ? '云层偏低' : 'dim horizon',
    Mood.restless => strings.appLanguage == AppLanguage.zh ? '电流浮动' : 'drifting current',
    Mood.tender => strings.appLanguage == AppLanguage.zh ? '月雾柔和' : 'soft moon mist',
  };
  final String station = switch (entry.energy) {
    Energy.low => strings.appLanguage == AppLanguage.zh ? '基地低功耗运转' : 'low-power base',
    Energy.steady => strings.appLanguage == AppLanguage.zh ? '系统稳定值守' : 'steady systems',
    Energy.high => strings.appLanguage == AppLanguage.zh ? '舱段灯光更活跃' : 'lively modules',
  };
  return strings.appLanguage == AppLanguage.zh
      ? '$sky，$station。'
      : '$sky, with $station.';
}

String buildSignal(AppStrings strings, LunaEntry entry) {
  final String moodTone = switch (entry.mood) {
    Mood.calm => strings.appLanguage == AppLanguage.zh ? '主站通信平稳' : 'Main relay is calm',
    Mood.bright => strings.appLanguage == AppLanguage.zh ? '采样舱亮度上升' : 'The sample bay is brighter',
    Mood.low => strings.appLanguage == AppLanguage.zh ? '基地把灯调暗了一格' : 'The base dims its lights slightly',
    Mood.restless => strings.appLanguage == AppLanguage.zh ? '信号边缘带着一点漂移' : 'The signal edge drifts a little',
    Mood.tender => strings.appLanguage == AppLanguage.zh ? '今晚的月雾很轻' : 'Tonight\'s moon mist feels soft',
  };
  final String energyTone = switch (entry.energy) {
    Energy.low => strings.appLanguage == AppLanguage.zh ? '值班系统维持最低但稳定的输出' : 'keeping only the minimum steady output',
    Energy.steady => strings.appLanguage == AppLanguage.zh ? '主系统保持着均匀供能' : 'with balanced station power',
    Energy.high => strings.appLanguage == AppLanguage.zh ? '几个舱段都亮起了回应灯' : 'and more modules answer with light',
  };
  final String focusTone = switch (entry.focus) {
    Focus.scattered => strings.appLanguage == AppLanguage.zh ? '频道有些分叉，但仍能听清自己' : 'The channel branches a little, but your voice still comes through',
    Focus.gentle => strings.appLanguage == AppLanguage.zh ? '回波很柔和，像慢慢对齐轨道' : 'The echo stays gentle, like easing into orbit',
    Focus.sharp => strings.appLanguage == AppLanguage.zh ? '航迹线清楚，回传坐标很干净' : 'The course line is sharp and the coordinates come back clean',
  };
  final String sleepTone = switch (entry.sleep) {
    Sleep.poor => strings.appLanguage == AppLanguage.zh ? '基地提醒你今晚尽量提前回舱休整。' : 'The base suggests an earlier return to rest tonight.',
    Sleep.okay => strings.appLanguage == AppLanguage.zh ? '补给足够，今晚可以慢一点收尾。' : 'Supplies look fine; you can close the day gently.',
    Sleep.good => strings.appLanguage == AppLanguage.zh ? '你的休整记录让整座站更安定。' : 'Your recovery record steadies the whole station.',
  };
  return strings.appLanguage == AppLanguage.zh
      ? '$moodTone，$energyTone。$focusTone。$sleepTone'
      : '$moodTone, $energyTone. $focusTone. $sleepTone';
}

String formatDate(DateTime value, AppLanguage language) {
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  if (language == AppLanguage.zh) {
    return '${value.year}年$month月$day日';
  }
  return '${value.year}-$month-$day';
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
