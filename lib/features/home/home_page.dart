import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/daily_log.dart';
import '../../shared/models/signal_state.dart';
import '../../shared/services/log_insights.dart';
import '../../shared/services/signal_service.dart';
import '../../shared/state/app_providers.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/scene_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppStrings strings = ref.watch(appStringsProvider);
    final LunaEntry? entry = ref.watch(latestLogProvider);
    final SignalState signalState = ref.watch(signalStateProvider);
    final LogInsights insights = ref.watch(logInsightsProvider);

    return SafeArea(
      child: ListView(
        padding: LunaSpacing.pagePadding,
        children: <Widget>[
          PageHeader(
            title: strings.appTitle,
            subtitle: strings.appSubtitle,
            icon: LunaIconKind.brand,
          ),
          const SizedBox(height: LunaSpacing.xl),
          SceneCard(strings: strings, entry: entry),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.todaySignal,
            icon: LunaIconKind.play,
            child: Text(
              signalState.signalText,
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.statusSummary,
            icon: LunaIconKind.check,
            child: entry == null
                ? Text(strings.noEntryYet, style: theme.textTheme.bodyMedium)
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      StatusChip(
                        label: strings.mood,
                        value: moodLabel(strings, entry.mood),
                        icon: LunaIconKind.mood,
                      ),
                      StatusChip(
                        label: strings.energy,
                        value: energyLabel(strings, entry.energy),
                        icon: LunaIconKind.energy,
                      ),
                      StatusChip(
                        label: strings.focus,
                        value: focusLabel(strings, entry.focus),
                        icon: LunaIconKind.focus,
                      ),
                      StatusChip(
                        label: strings.sleep,
                        value: sleepLabel(strings, entry.sleep),
                        icon: LunaIconKind.sleep,
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.companionStatus,
            icon: LunaIconKind.brand,
            child: Text(
              strings.companionLine(insights.currentStreak),
              style: theme.textTheme.bodyLarge?.copyWith(
                height: LunaTypography.signalHeight,
              ),
            ),
          ),
          if (entry != null) ...<Widget>[
            const SizedBox(height: LunaSpacing.lg),
            AppPanel(
              title: strings.stationBrief,
              icon: LunaIconKind.home,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${strings.frequency}: ${frequencyLabel(strings, entry.frequency)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: LunaSpacing.md),
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
