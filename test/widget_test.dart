import 'package:flutter/material.dart' hide Focus;
import 'package:flutter_test/flutter_test.dart' hide Focus;
import 'package:luna_log/main.dart';
import 'package:luna_log/shared/models/app_settings.dart';
import 'package:luna_log/shared/models/daily_log.dart';
import 'package:luna_log/shared/models/log_enums.dart';

void main() {
  test('persists entry fields through map serialization', () {
    final LunaEntry entry = LunaEntry(
      id: 'entry-1',
      createdAt: DateTime(2026, 4, 24, 21, 30),
      dateKey: '2026-04-24',
      mood: Mood.tender,
      energy: Energy.steady,
      focus: Focus.gentle,
      sleep: Sleep.good,
      note: 'Tonight feels softer.',
      frequency: FrequencyTag.deepSpace,
      generatedSignalText: 'A quiet signal from the moon.',
    );

    final LunaEntry restored = LunaEntry.fromMap(entry.toMap());

    expect(restored.id, entry.id);
    expect(restored.dateKey, entry.dateKey);
    expect(restored.mood, entry.mood);
    expect(restored.energy, entry.energy);
    expect(restored.focus, entry.focus);
    expect(restored.sleep, entry.sleep);
    expect(restored.note, entry.note);
    expect(restored.frequency, entry.frequency);
    expect(restored.generatedSignalText, entry.generatedSignalText);
  });

  test('persists settings through map serialization', () {
    const AppSettings settings = AppSettings(
      language: AppLanguage.en,
      themeMode: LunarThemeMode.light,
      firstLaunchCompleted: false,
      baseProgressLevel: 3,
      unlockedCompanions: <String>['moon-cat'],
      streakCountCached: 7,
    );

    final AppSettings restored = AppSettings.fromMap(settings.toMap());

    expect(restored.language, settings.language);
    expect(restored.themeMode, settings.themeMode);
    expect(restored.firstLaunchCompleted, settings.firstLaunchCompleted);
    expect(restored.baseProgressLevel, settings.baseProgressLevel);
    expect(restored.unlockedCompanions, settings.unlockedCompanions);
    expect(restored.streakCountCached, settings.streakCountCached);
  });

  testWidgets('shows Luna Log home shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      LunaLogApp(
        storage: null,
        initialEntries: const <LunaEntry>[],
        initialSettings: AppSettings.defaults().copyWith(
          language: AppLanguage.en,
        ),
      ),
    );

    expect(find.text('Luna Log'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('saving a log updates home and archive from shared state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      LunaLogApp(
        storage: null,
        initialEntries: const <LunaEntry>[],
        initialSettings: AppSettings.defaults().copyWith(
          language: AppLanguage.en,
        ),
      ),
    );

    await _tapNavigationDestination(tester, 1);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Save Entry'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Entry'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Main relay is calm'), findsOneWidget);

    await _tapNavigationDestination(tester, 2);
    await tester.pumpAndSettle();

    expect(find.text('Timeline'), findsOneWidget);
    expect(find.textContaining('Main relay is calm'), findsOneWidget);
  });

  testWidgets('language and theme changes propagate through providers', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      LunaLogApp(
        storage: null,
        initialEntries: const <LunaEntry>[],
        initialSettings: AppSettings.defaults(),
      ),
    );

    expect(find.text('首页'), findsOneWidget);

    await _tapNavigationDestination(tester, 3);
    await tester.pumpAndSettle();
    await tester.tap(find.text('英文'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.theme?.scaffoldBackgroundColor, const Color(0xFFF1F4FA));
  });
}

Future<void> _tapNavigationDestination(WidgetTester tester, int index) async {
  final Rect navigationBarRect = tester.getRect(find.byType(NavigationBar));
  final double destinationWidth = navigationBarRect.width / 4;
  await tester.tapAt(
    Offset(
      navigationBarRect.left + destinationWidth * (index + 0.5),
      navigationBarRect.center.dy,
    ),
  );
}
