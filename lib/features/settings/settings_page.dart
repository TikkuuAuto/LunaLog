import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/i18n/app_strings.dart';
import '../../shared/models/log_enums.dart';
import '../../shared/state/app_providers.dart';
import '../../shared/theme/luna_tokens.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';
import 'settings_detail_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings strings = ref.watch(appStringsProvider);
    final AppLanguage language = ref.watch(appLanguageProvider);
    final LunarThemeMode themeMode = ref.watch(themeModeProvider);
    return SafeArea(
      child: ListView(
        padding: LunaSpacing.pagePadding,
        children: <Widget>[
          PageHeader(
            title: strings.settingsTitle,
            subtitle: strings.settingsSubtitle,
            icon: LunaIconKind.settings,
          ),
          const SizedBox(height: LunaSpacing.xl),
          AppPanel(
            title: strings.language,
            icon: LunaIconKind.settings,
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
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.theme,
            icon: LunaIconKind.mood,
            child: SegmentedButton<LunarThemeMode>(
              segments: <ButtonSegment<LunarThemeMode>>[
                ButtonSegment<LunarThemeMode>(
                  value: LunarThemeMode.dark,
                  icon: const LunaIcon(LunaIconKind.brand, size: 18),
                  label: Text(strings.darkTheme),
                ),
                ButtonSegment<LunarThemeMode>(
                  value: LunarThemeMode.light,
                  icon: const LunaIcon(LunaIconKind.energy, size: 18),
                  label: Text(strings.lightTheme),
                ),
              ],
              selected: <LunarThemeMode>{themeMode},
              onSelectionChanged: (Set<LunarThemeMode> values) {
                updateThemeMode(ref, values.first);
              },
            ),
          ),
          const SizedBox(height: LunaSpacing.lg),
          AppPanel(
            title: strings.helpAndInfo,
            icon: LunaIconKind.brand,
            child: Column(
              children: <Widget>[
                _SettingsLinkTile(
                  title: strings.contactSupport,
                  subtitle: strings.openDetail,
                  icon: LunaIconKind.settings,
                  onTap: () => _openDetail(
                    context,
                    title: strings.contactSupport,
                    subtitle: strings.helpAndInfo,
                    body: strings.contactSupportText,
                    icon: LunaIconKind.settings,
                  ),
                ),
                const SizedBox(height: LunaSpacing.sm),
                _SettingsLinkTile(
                  title: strings.usageGuide,
                  subtitle: strings.openDetail,
                  icon: LunaIconKind.play,
                  onTap: () => _openDetail(
                    context,
                    title: strings.usageGuide,
                    subtitle: strings.helpAndInfo,
                    body: strings.usageGuideText,
                    icon: LunaIconKind.play,
                  ),
                ),
                const SizedBox(height: LunaSpacing.sm),
                _SettingsLinkTile(
                  title: strings.privacyPolicy,
                  subtitle: strings.openDetail,
                  icon: LunaIconKind.check,
                  onTap: () => _openDetail(
                    context,
                    title: strings.privacyPolicy,
                    subtitle: strings.helpAndInfo,
                    body: strings.privacyPolicyText,
                    icon: LunaIconKind.check,
                  ),
                ),
                const SizedBox(height: LunaSpacing.sm),
                _SettingsLinkTile(
                  title: strings.about,
                  subtitle: strings.openDetail,
                  icon: LunaIconKind.brand,
                  onTap: () => _openDetail(
                    context,
                    title: strings.about,
                    subtitle: strings.appTitle,
                    body: strings.aboutText,
                    icon: LunaIconKind.brand,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String body,
    required LunaIconKind icon,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SettingsDetailPage(
            title: title,
            subtitle: subtitle,
            body: body,
            icon: icon,
          );
        },
      ),
    );
  }
}

class _SettingsLinkTile extends StatelessWidget {
  const _SettingsLinkTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final LunaIconKind icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: LunaRadii.panel,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(LunaSpacing.md),
        decoration: LunaCards.insetDecoration(theme.colorScheme),
        child: Row(
          children: <Widget>[
            LunaIcon(icon, active: true),
            const SizedBox(width: LunaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: LunaTypography.titleWeight,
                    ),
                  ),
                  const SizedBox(height: LunaSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
