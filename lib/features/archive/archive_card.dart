import 'package:flutter/material.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/daily_log.dart';
import '../../shared/services/signal_service.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/utils/date_utils.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';

class ArchiveCard extends StatelessWidget {
  const ArchiveCard({super.key, required this.strings, required this.entry});

  final AppStrings strings;
  final LunaEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: LunaSpacing.panelPadding,
      decoration: LunaCards.insetDecoration(Theme.of(context).colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              LunaIcon(LunaIconKind.play, size: 20, active: true),
              const SizedBox(width: LunaSpacing.sm),
              Text(
                formatDate(entry.createdAt, strings.appLanguage),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              StatusChip(
                label: strings.mood,
                value: moodLabel(strings, entry.mood),
                icon: LunaIconKind.mood,
              ),
            ],
          ),
          const SizedBox(height: LunaSpacing.md),
          Wrap(
            spacing: LunaSpacing.sm,
            runSpacing: LunaSpacing.sm,
            children: <Widget>[
              StatusChip(
                label: strings.frequency,
                value: frequencyLabel(strings, entry.frequency),
                icon: LunaIconKind.play,
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
          const SizedBox(height: LunaSpacing.md),
          Text(
            strings.preservedSignal,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: LunaTypography.labelWeight,
            ),
          ),
          const SizedBox(height: LunaSpacing.xs),
          Text(
            entry.generatedSignalText.isEmpty
                ? buildSignal(strings, entry)
                : entry.generatedSignalText,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: LunaTypography.bodyHeight),
          ),
          if (entry.note.isNotEmpty) ...<Widget>[
            const SizedBox(height: LunaSpacing.sm),
            Text(
              entry.note,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: LunaTypography.bodyHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
