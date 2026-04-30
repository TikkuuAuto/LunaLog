import 'package:flutter/material.dart';

abstract final class LunaColors {
  static const Color voidBlack = Color(0xFF0B1020);
  static const Color stationDark = Color(0xFF121625);
  static const Color panelDark = Color(0xFF171C2E);
  static const Color panelDarkHigh = Color(0xFF262C43);
  static const Color moonViolet = Color(0xFFB6B8FF);
  static const Color signalCyan = Color(0xFF7DE0FF);
  static const Color pixelGold = Color(0xFFFFD36E);
  static const Color lunarDust = Color(0xFFD2D7E2);
  static const Color ink = Color(0xFF1B1E2C);
  static const Color snow = Color(0xFFF7F7FB);
  static const Color orbitLine = Color(0xFF666D88);
}

abstract final class LunaSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(xl, lg, xl, xxl);
  static const EdgeInsets panelPadding = EdgeInsets.all(lg);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

abstract final class LunaRadii {
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static BorderRadius get panel => BorderRadius.circular(md);
  static BorderRadius get chip => BorderRadius.circular(md);
  static BorderRadius get station => BorderRadius.circular(lg);
}

abstract final class LunaTypography {
  static const FontWeight titleWeight = FontWeight.w700;
  static const FontWeight labelWeight = FontWeight.w600;
  static const double bodyHeight = 1.45;
  static const double signalHeight = 1.5;
}

abstract final class LunaCards {
  static BoxDecoration panelDecoration(ColorScheme scheme) {
    return BoxDecoration(
      color: scheme.surfaceContainer,
      borderRadius: LunaRadii.panel,
      border: Border.all(color: scheme.outline.withValues(alpha: 0.28)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.16),
          blurRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration insetDecoration(ColorScheme scheme) {
    return BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: LunaRadii.panel,
      border: Border.all(color: scheme.outline.withValues(alpha: 0.18)),
    );
  }
}

abstract final class LunaChips {
  static BoxDecoration decoration(ColorScheme scheme) {
    return BoxDecoration(
      color: scheme.surface,
      borderRadius: LunaRadii.chip,
      border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
    );
  }
}

abstract final class LunaButtons {
  static RoundedRectangleBorder get shape {
    return RoundedRectangleBorder(borderRadius: LunaRadii.panel);
  }
}
