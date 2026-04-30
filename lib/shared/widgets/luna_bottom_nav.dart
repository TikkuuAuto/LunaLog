import 'package:flutter/material.dart';

import '../i18n/app_strings.dart';
import '../theme/luna_tokens.dart';
import 'luna_icon.dart';

class LunaBottomNav extends StatelessWidget {
  const LunaBottomNav({
    super.key,
    required this.selectedTabIndex,
    required this.strings,
    required this.onSelected,
  });

  final int selectedTabIndex;
  final AppStrings strings;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        height: 108,
        margin: const EdgeInsets.fromLTRB(
          LunaSpacing.xl,
          LunaSpacing.sm,
          LunaSpacing.xl,
          LunaSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: LunaSpacing.sm,
          vertical: LunaSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(22),
            bottom: Radius.circular(LunaRadii.lg),
          ),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.28)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            _NavItem(
              label: strings.navHome,
              icon: LunaIconKind.home,
              active: selectedTabIndex == 0,
              onTap: () => onSelected(0),
            ),
            _NavItem(
              label: strings.navLog,
              icon: LunaIconKind.log,
              active: selectedTabIndex == 1,
              onTap: () => onSelected(1),
            ),
            _AddItem(
              label: strings.navAdd,
              active: selectedTabIndex == 2,
              onTap: () => onSelected(2),
            ),
            _NavItem(
              label: strings.navData,
              icon: LunaIconKind.stats,
              active: selectedTabIndex == 3,
              onTap: () => onSelected(3),
            ),
            _NavItem(
              label: strings.navMe,
              icon: LunaIconKind.me,
              active: selectedTabIndex == 4,
              onTap: () => onSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final LunaIconKind icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = active
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        borderRadius: LunaRadii.panel,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: LunaSpacing.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LunaIcon(icon, size: 24, active: active),
              const SizedBox(height: LunaSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: LunaTypography.labelWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddItem extends StatelessWidget {
  const _AddItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = active
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Transform.translate(
        offset: const Offset(0, -14),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 62,
                height: 62,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: active ? 0.88 : 0.42,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: active
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.primary.withValues(alpha: 0.34),
                    width: active ? 3 : 2,
                  ),
                ),
                child: LunaIcon(LunaIconKind.add, size: 20, active: active),
              ),
              const SizedBox(height: LunaSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: LunaTypography.labelWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
