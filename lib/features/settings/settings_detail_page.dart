import 'package:flutter/material.dart';

import '../../shared/theme/luna_tokens.dart';
import '../../shared/widgets/app_panel.dart';
import '../../shared/widgets/luna_icon.dart';
import '../../shared/widgets/page_header.dart';

class SettingsDetailPage extends StatelessWidget {
  const SettingsDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String body;
  final LunaIconKind icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: LunaSpacing.pagePadding,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            const SizedBox(height: LunaSpacing.sm),
            PageHeader(title: title, subtitle: subtitle, icon: icon),
            const SizedBox(height: LunaSpacing.xl),
            AppPanel(
              title: title,
              icon: icon,
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: LunaTypography.signalHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
