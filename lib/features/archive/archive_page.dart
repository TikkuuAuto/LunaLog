import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/daily_log.dart';
import '../../shared/services/log_insights.dart';
import '../../shared/state/app_providers.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';
import 'archive_card.dart';

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final List<LunaEntry> entries = ref.watch(archiveLogsProvider);
    final LogInsights insights = ref.watch(logInsightsProvider);
    final DateTime now = DateTime.now();
    final int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final Set<int> loggedDays = insights.loggedDays
        .where((DateTime day) => day.year == now.year && day.month == now.month)
        .map((DateTime day) => day.day)
        .toSet();

    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: LunaSpacing.pagePadding,
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PageHeader(
                    title: strings.archiveTitle,
                    subtitle: strings.archiveSubtitle,
                    icon: LunaIconKind.archive,
                  ),
                  const SizedBox(height: LunaSpacing.xl),
                  AppPanel(
                    title: strings.memorySummary,
                    icon: LunaIconKind.brand,
                    child: Wrap(
                      spacing: LunaSpacing.sm,
                      runSpacing: LunaSpacing.sm,
                      children: <Widget>[
                        StatusChip(
                          label: strings.monthLoggedDays,
                          value: '${insights.loggedDaysThisMonth}',
                          icon: LunaIconKind.calendar,
                        ),
                        StatusChip(
                          label: strings.currentStreak,
                          value:
                              '${insights.currentStreak} ${strings.daysUnit}',
                          icon: LunaIconKind.check,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LunaSpacing.lg),
                  AppPanel(
                    title: strings.monthView,
                    icon: LunaIconKind.calendar,
                    child: Wrap(
                      spacing: LunaSpacing.sm,
                      runSpacing: LunaSpacing.sm,
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
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: LunaRadii.chip,
                            border: Border.all(
                              color: active
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            '$day',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: active
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null,
                                ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: LunaSpacing.lg),
                  _TimelineHeader(strings: strings),
                  const SizedBox(height: LunaSpacing.md),
                  if (entries.isEmpty) _TimelineEmpty(strings: strings),
                ],
              ),
            ),
          ),
          if (entries.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                LunaSpacing.xl,
                0,
                LunaSpacing.xl,
                LunaSpacing.xxl,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == entries.length - 1 ? 0 : LunaSpacing.md,
                    ),
                    child: ArchiveCard(strings: strings, entry: entries[index]),
                  );
                }, childCount: entries.length),
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineHeader extends StatelessWidget {
  const _TimelineHeader({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: LunaSpacing.panelPadding,
      decoration: LunaCards.panelDecoration(theme.colorScheme),
      child: Row(
        children: <Widget>[
          const LunaIcon(LunaIconKind.play, size: 20, active: true),
          const SizedBox(width: LunaSpacing.sm),
          Text(
            strings.timeline,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: LunaTypography.titleWeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEmpty extends StatelessWidget {
  const _TimelineEmpty({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: LunaSpacing.panelPadding,
      decoration: LunaCards.insetDecoration(Theme.of(context).colorScheme),
      child: Text(strings.emptyArchive),
    );
  }
}
