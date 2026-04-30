import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/log_enums.dart';
import '../../shared/services/log_insights.dart';
import '../../shared/services/signal_service.dart';
import '../../shared/state/app_providers.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final LogInsights insights = ref.watch(logInsightsProvider);
    final Mood? commonMood = insights.commonMood;
    final FrequencyTag? commonFrequency = insights.commonFrequency;

    return SafeArea(
      child: ListView(
        padding: LunaSpacing.pagePadding,
        children: <Widget>[
          PageHeader(
            title: strings.statsTitle,
            subtitle: strings.statsSubtitle,
            icon: LunaIconKind.stats,
          ),
          const SizedBox(height: LunaSpacing.xl),
          _BeaconPanel(strings: strings, insights: insights),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.companionStatus,
            icon: LunaIconKind.brand,
            child: Text(
              strings.companionLine(insights.currentStreak),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                height: LunaTypography.signalHeight,
              ),
            ),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.stationRhythm,
            icon: LunaIconKind.stats,
            child: Wrap(
              spacing: LunaSpacing.md,
              runSpacing: LunaSpacing.md,
              children: <Widget>[
                _MetricTile(
                  label: strings.monthLoggedDays,
                  value: '${insights.loggedDaysThisMonth}',
                  icon: LunaIconKind.calendar,
                ),
                _MetricTile(
                  label: strings.longestStreak,
                  value: '${insights.longestStreak} ${strings.daysUnit}',
                  icon: LunaIconKind.check,
                ),
                _MetricTile(
                  label: strings.commonMood,
                  value: commonMood == null
                      ? strings.noneYet
                      : moodLabel(strings, commonMood),
                  icon: LunaIconKind.mood,
                ),
                _MetricTile(
                  label: strings.commonSoundtrack,
                  value: commonFrequency == null
                      ? strings.noneYet
                      : frequencyLabel(strings, commonFrequency),
                  icon: LunaIconKind.play,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BeaconPanel extends StatelessWidget {
  const _BeaconPanel({required this.strings, required this.insights});

  final AppStrings strings;
  final LogInsights insights;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: LunaSpacing.panelPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.58),
        borderRadius: LunaRadii.station,
        border: Border.all(color: theme.colorScheme.secondary),
      ),
      child: Row(
        children: <Widget>[
          _BeaconGraphic(active: insights.currentStreak > 0),
          const SizedBox(width: LunaSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.streakRelay,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: LunaTypography.titleWeight,
                  ),
                ),
                const SizedBox(height: LunaSpacing.sm),
                Text(
                  '${insights.currentStreak} ${strings.daysUnit}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: LunaTypography.titleWeight,
                  ),
                ),
                const SizedBox(height: LunaSpacing.sm),
                Text(
                  strings.streakLine(insights.currentStreak),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: LunaTypography.bodyHeight,
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

class _BeaconGraphic extends StatelessWidget {
  const _BeaconGraphic({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 76,
      height: 92,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: active ? 48 : 36,
              height: active ? 48 : 36,
              decoration: BoxDecoration(
                color: scheme.secondary.withValues(alpha: active ? 0.32 : 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 18,
            child: LunaIcon(LunaIconKind.play, size: 34, active: active),
          ),
          Container(
            width: 48,
            height: 20,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: LunaRadii.chip,
              border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final LunaIconKind icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 150,
      child: Container(
        padding: LunaSpacing.panelPadding,
        decoration: LunaCards.insetDecoration(theme.colorScheme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LunaIcon(icon, active: true),
            const SizedBox(height: LunaSpacing.md),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: LunaTypography.labelWeight,
              ),
            ),
            const SizedBox(height: LunaSpacing.xs),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: LunaTypography.titleWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
