import 'package:flutter/material.dart' hide Focus;

import '../i18n/app_strings.dart';
import '../models/daily_log.dart';
import '../models/log_enums.dart';
import '../services/signal_service.dart';
import '../theme/luna_tokens.dart';

class SceneCard extends StatelessWidget {
  const SceneCard({super.key, required this.strings, required this.entry});

  final AppStrings strings;
  final LunaEntry? entry;

  @override
  Widget build(BuildContext context) {
    final bool hasEntry = entry != null;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color skyTop = entry == null
        ? scheme.primaryContainer
        : switch (entry!.mood) {
            Mood.calm => const Color(0xFF5561B1),
            Mood.bright => const Color(0xFF6D91E7),
            Mood.low => const Color(0xFF34385B),
            Mood.restless => const Color(0xFF8266B6),
            Mood.tender => const Color(0xFF7F73C8),
          };
    final Color skyBottom = entry == null
        ? scheme.surfaceContainerHighest
        : switch (entry!.sleep) {
            Sleep.poor => const Color(0xFF171A2B),
            Sleep.okay => const Color(0xFF232B46),
            Sleep.good => const Color(0xFF31436D),
          };
    final Color signalColor = entry == null
        ? scheme.secondary
        : switch (entry!.focus) {
            Focus.scattered => const Color(0xFFA994FF),
            Focus.gentle => const Color(0xFF7DE0FF),
            Focus.sharp => const Color(0xFFFFD36E),
          };
    final bool companionAwake = hasEntry && entry!.sleep != Sleep.poor;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(LunaSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: LunaRadii.station,
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.18)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[skyTop, skyBottom],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 16,
            top: 8,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(right: 76, top: 28, child: _PixelStar(color: signalColor)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 76,
              decoration: const BoxDecoration(
                color: LunaColors.lunarDust,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(LunaRadii.sm),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 28,
            child: _PixelBuilding(
              lightColor: hasEntry && entry!.energy == Energy.high
                  ? LunaColors.pixelGold
                  : const Color(0xFFA8D6FF),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 26,
            child: _PixelRover(active: hasEntry && entry!.energy != Energy.low),
          ),
          Positioned(
            bottom: 82,
            right: 82,
            child: _PixelCompanion(awake: companionAwake, color: signalColor),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.sceneTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: LunaTypography.titleWeight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasEntry ? sceneSummary(strings, entry!) : strings.sceneEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    height: LunaTypography.signalHeight,
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

class _PixelStar extends StatelessWidget {
  const _PixelStar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(width: 4, height: 10, color: color),
        Transform.translate(
          offset: const Offset(0, -7),
          child: Container(width: 10, height: 4, color: color),
        ),
      ],
    );
  }
}

class _PixelCompanion extends StatelessWidget {
  const _PixelCompanion({required this.awake, required this.color});

  final bool awake;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _block(4, 8, color),
            const SizedBox(width: 12),
            _block(4, 8, color),
          ],
        ),
        _block(
          28,
          20,
          awake ? const Color(0xFFB6B8FF) : const Color(0xFF7B819C),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _block(4, 4, const Color(0xFF20243A)),
            const SizedBox(width: 8),
            _block(4, 4, awake ? const Color(0xFF20243A) : color),
          ],
        ),
      ],
    );
  }

  Widget _block(double width, double height, Color blockColor) {
    return Container(width: width, height: height, color: blockColor);
  }
}

class _PixelBuilding extends StatelessWidget {
  const _PixelBuilding({required this.lightColor});

  final Color lightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _block(24, 32, const Color(0xFF5B6184)),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _block(12, 10, const Color(0xFF9CC7FF)),
            const SizedBox(height: 3),
            _block(48, 44, const Color(0xFF7078A0), windows: true),
          ],
        ),
      ],
    );
  }

  Widget _block(
    double width,
    double height,
    Color color, {
    bool windows = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: const Color(0xFF22263A), width: 1),
      ),
      child: windows
          ? Padding(
              padding: const EdgeInsets.all(4),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List<Widget>.generate(
                  6,
                  (_) => Container(width: 6, height: 6, color: lightColor),
                ),
              ),
            )
          : null,
    );
  }
}

class _PixelRover extends StatelessWidget {
  const _PixelRover({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 24,
          height: 12,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF82C3FF) : const Color(0xFF8A8FA7),
            border: Border.all(color: const Color(0xFF212437)),
          ),
        ),
        const SizedBox(height: 2),
        Row(children: <Widget>[_wheel(), const SizedBox(width: 8), _wheel()]),
      ],
    );
  }

  Widget _wheel() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF2F3145),
        shape: BoxShape.circle,
      ),
    );
  }
}
