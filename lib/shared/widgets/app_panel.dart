import 'package:flutter/material.dart';

import '../theme/luna_tokens.dart';
import 'luna_icon.dart';

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
  });

  final String title;
  final Widget child;
  final LunaIconKind? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: LunaSpacing.panelPadding,
      decoration: LunaCards.panelDecoration(theme.colorScheme),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                LunaIcon(icon!, size: 20, active: true),
                const SizedBox(width: LunaSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: LunaTypography.titleWeight,
                  ),
                ),
              ),
              if (trailing != null) ...<Widget>[trailing!],
            ],
          ),
          const SizedBox(height: LunaSpacing.md),
          child,
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final LunaIconKind? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: LunaSpacing.chipPadding,
      decoration: LunaChips.decoration(theme.colorScheme),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            LunaIcon(icon!, size: 16, active: true),
            const SizedBox(width: LunaSpacing.xs),
          ],
          Text(
            '$label · $value',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: LunaTypography.labelWeight,
            ),
          ),
        ],
      ),
    );
  }
}

class SegmentBlock<T> extends StatelessWidget {
  const SegmentBlock({
    super.key,
    required this.title,
    required this.value,
    required this.values,
    required this.labelBuilder,
    required this.onChanged,
    this.icon,
  });

  final String title;
  final T value;
  final List<T> values;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;
  final LunaIconKind? icon;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: title,
      icon: icon,
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
