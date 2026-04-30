import 'package:flutter/material.dart' hide Focus;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/daily_log.dart';
import '../../shared/models/log_enums.dart';
import '../../shared/services/signal_service.dart';
import '../../shared/state/app_providers.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';

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
  String? _loadedDateKey;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _loadTodayEntry();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadTodayEntry() {
    final LunaEntry? todayEntry = ref.read(todayLogProvider);
    if (todayEntry == null || _loadedDateKey == todayEntry.dateKey) {
      return;
    }
    _loadedDateKey = todayEntry.dateKey;
    _mood = todayEntry.mood;
    _energy = todayEntry.energy;
    _focus = todayEntry.focus;
    _sleep = todayEntry.sleep;
    _frequency = todayEntry.frequency;
    _noteController.text = todayEntry.note;
  }

  void _save() {
    final DateTime now = DateTime.now();
    final String todayKey = dateKeyFor(now);
    final LunaEntry? existingEntry = ref.read(todayLogProvider);
    final String note = _noteController.text.trim();
    final LunaEntry entry = LunaEntry(
      id: existingEntry?.id ?? now.microsecondsSinceEpoch.toString(),
      createdAt: existingEntry?.createdAt ?? now,
      updatedAt: now,
      dateKey: todayKey,
      mood: _mood,
      energy: _energy,
      focus: _focus,
      sleep: _sleep,
      note: note,
      frequency: _frequency,
      generatedSignalText: '',
    );
    final AppStrings strings = ref.read(appStringsProvider);
    saveLog(
      ref,
      entry.copyWith(generatedSignalText: buildSignal(strings, entry)),
    );
    widget.onSaveComplete();
    _loadedDateKey = todayKey;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final DateTime previewNow = DateTime.now();
    return SafeArea(
      child: ListView(
        padding: LunaSpacing.pagePadding,
        children: <Widget>[
          PageHeader(
            title: strings.logTitle,
            subtitle: strings.logSubtitle,
            icon: LunaIconKind.log,
          ),
          const SizedBox(height: LunaSpacing.xl),
          SegmentBlock<Mood>(
            title: strings.mood,
            icon: LunaIconKind.mood,
            value: _mood,
            values: Mood.values,
            labelBuilder: (Mood value) => moodLabel(strings, value),
            onChanged: (Mood value) => setState(() => _mood = value),
          ),
          const SizedBox(height: LunaSpacing.lg),
          SegmentBlock<Energy>(
            title: strings.energy,
            icon: LunaIconKind.energy,
            value: _energy,
            values: Energy.values,
            labelBuilder: (Energy value) => energyLabel(strings, value),
            onChanged: (Energy value) => setState(() => _energy = value),
          ),
          const SizedBox(height: LunaSpacing.lg),
          SegmentBlock<Focus>(
            title: strings.focus,
            icon: LunaIconKind.focus,
            value: _focus,
            values: Focus.values,
            labelBuilder: (Focus value) => focusLabel(strings, value),
            onChanged: (Focus value) => setState(() => _focus = value),
          ),
          const SizedBox(height: LunaSpacing.lg),
          SegmentBlock<Sleep>(
            title: strings.sleep,
            icon: LunaIconKind.sleep,
            value: _sleep,
            values: Sleep.values,
            labelBuilder: (Sleep value) => sleepLabel(strings, value),
            onChanged: (Sleep value) => setState(() => _sleep = value),
          ),
          const SizedBox(height: LunaSpacing.lg),
          SegmentBlock<FrequencyTag>(
            title: strings.frequency,
            icon: LunaIconKind.play,
            value: _frequency,
            values: FrequencyTag.values,
            labelBuilder: (FrequencyTag value) =>
                frequencyLabel(strings, value),
            onChanged: (FrequencyTag value) =>
                setState(() => _frequency = value),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.note,
            icon: LunaIconKind.log,
            child: TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(hintText: strings.noteHint),
            ),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.preview,
            icon: LunaIconKind.play,
            child: Text(
              buildSignal(
                strings,
                LunaEntry(
                  id: 'preview',
                  createdAt: previewNow,
                  updatedAt: previewNow,
                  dateKey: dateKeyFor(previewNow),
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
          const SizedBox(height: LunaSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const LunaIcon(LunaIconKind.check, size: 18, active: true),
              label: Text(strings.saveEntry),
            ),
          ),
        ],
      ),
    );
  }
}
