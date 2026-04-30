import 'package:flutter/material.dart';

import '../assets/app_assets.dart';
import '../theme/luna_tokens.dart';

enum LunaIconKind {
  brand,
  home,
  log,
  add,
  archive,
  stats,
  me,
  settings,
  calendar,
  play,
  check,
  mood,
  energy,
  focus,
  sleep,
}

class LunaIcon extends StatelessWidget {
  const LunaIcon(this.kind, {super.key, this.size = 24, this.active = false});

  final LunaIconKind kind;
  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final String? assetPath = _assetPathFor(kind, active);

    if (assetPath != null) {
      return SizedBox.square(
        dimension: size,
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
        ),
      );
    }

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _LunaIconPainter(
          kind: kind,
          color: active ? scheme.primary : scheme.onSurfaceVariant,
          accent: active ? scheme.secondary : scheme.primary,
        ),
      ),
    );
  }

  String? _assetPathFor(LunaIconKind kind, bool active) {
    switch (kind) {
      case LunaIconKind.brand:
        return AppAssets.moonLogoSmall;
      case LunaIconKind.home:
        return active ? AppAssets.navHomeActive : AppAssets.navHomeDefault;
      case LunaIconKind.log:
        return active ? AppAssets.navLogActive : AppAssets.navLogDefault;
      case LunaIconKind.add:
        return active ? AppAssets.navAddActive : AppAssets.navAddDefault;
      case LunaIconKind.stats:
        return active ? AppAssets.navStatsActive : AppAssets.navStatsDefault;
      case LunaIconKind.me:
        return active ? AppAssets.navMeActive : AppAssets.navMeDefault;
      case LunaIconKind.archive:
      case LunaIconKind.settings:
      case LunaIconKind.calendar:
      case LunaIconKind.play:
      case LunaIconKind.check:
      case LunaIconKind.mood:
      case LunaIconKind.energy:
      case LunaIconKind.focus:
      case LunaIconKind.sleep:
        return null;
    }
  }
}

class _LunaIconPainter extends CustomPainter {
  const _LunaIconPainter({
    required this.kind,
    required this.color,
    required this.accent,
  });

  final LunaIconKind kind;
  final Color color;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final double unit = size.width / 12;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Paint accentPaint = Paint()
      ..color = accent
      ..style = PaintingStyle.fill;

    void block(num x, num y, num w, num h, [Paint? customPaint]) {
      canvas.drawRect(
        Rect.fromLTWH(x * unit, y * unit, w * unit, h * unit),
        customPaint ?? paint,
      );
    }

    switch (kind) {
      case LunaIconKind.brand:
        block(2, 2, 7, 7, accentPaint);
        block(5, 1, 5, 8, Paint()..color = LunaColors.voidBlack);
        block(3, 9, 6, 1);
        block(4, 10, 4, 1);
      case LunaIconKind.home:
        block(2, 5, 8, 5);
        block(3, 4, 6, 1);
        block(4, 3, 4, 1);
        block(5, 7, 2, 3, accentPaint);
      case LunaIconKind.log:
        block(3, 2, 6, 8);
        block(4, 4, 4, 1, accentPaint);
        block(4, 6, 3, 1, accentPaint);
        block(8, 8, 2, 2, accentPaint);
      case LunaIconKind.add:
        block(3, 3, 6, 6);
        block(5, 4, 2, 4, accentPaint);
        block(4, 5, 4, 2, accentPaint);
      case LunaIconKind.archive:
      case LunaIconKind.calendar:
        block(2, 3, 8, 7);
        block(3, 2, 1, 2, accentPaint);
        block(8, 2, 1, 2, accentPaint);
        block(3, 5, 6, 1, Paint()..color = LunaColors.voidBlack);
        block(4, 7, 1, 1, accentPaint);
        block(7, 7, 1, 1, accentPaint);
      case LunaIconKind.stats:
        block(2, 8, 2, 2);
        block(5, 5, 2, 5, accentPaint);
        block(8, 3, 2, 7);
      case LunaIconKind.me:
        block(3, 3, 6, 4);
        block(2, 8, 8, 2, accentPaint);
      case LunaIconKind.settings:
        block(5, 1, 2, 3);
        block(5, 8, 2, 3);
        block(1, 5, 3, 2);
        block(8, 5, 3, 2);
        block(4, 4, 4, 4, accentPaint);
        block(5, 5, 2, 2, Paint()..color = LunaColors.voidBlack);
      case LunaIconKind.play:
        block(3, 2, 2, 8);
        block(5, 3, 2, 6);
        block(7, 4, 2, 4, accentPaint);
        block(9, 5, 1, 2, accentPaint);
      case LunaIconKind.check:
        block(2, 6, 2, 2);
        block(4, 8, 2, 2);
        block(6, 6, 2, 2, accentPaint);
        block(8, 4, 2, 2, accentPaint);
      case LunaIconKind.mood:
        block(3, 3, 6, 6);
        block(4, 5, 1, 1, accentPaint);
        block(7, 5, 1, 1, accentPaint);
        block(5, 7, 2, 1, accentPaint);
      case LunaIconKind.energy:
        block(6, 1, 3, 4, accentPaint);
        block(4, 5, 3, 2);
        block(3, 7, 3, 4);
      case LunaIconKind.focus:
        block(2, 5, 8, 2);
        block(5, 2, 2, 8, accentPaint);
        block(4, 4, 4, 4, Paint()..color = color.withValues(alpha: 0.45));
      case LunaIconKind.sleep:
        block(2, 7, 8, 2);
        block(3, 5, 3, 2, accentPaint);
        block(7, 3, 2, 2);
    }
  }

  @override
  bool shouldRepaint(_LunaIconPainter oldDelegate) {
    return oldDelegate.kind != kind ||
        oldDelegate.color != color ||
        oldDelegate.accent != accent;
  }
}
