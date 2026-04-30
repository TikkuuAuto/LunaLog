import 'package:flutter/material.dart' hide Focus;
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_log/app/luna_log_app.dart';
import 'package:luna_log/shared/models/app_settings.dart';
import 'package:luna_log/shared/models/daily_log.dart';
import 'package:luna_log/shared/models/log_enums.dart';
import 'package:luna_log/shared/services/log_insights.dart';

void main() {
  test('persists entry fields through map serialization', () {
    final LunaEntry entry = LunaEntry(
      id: 'entry-1',
      createdAt: DateTime(2026, 4, 24, 21, 30),
      updatedAt: DateTime(2026, 4, 24, 22, 10),
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
    expect(restored.updatedAt, entry.updatedAt);
    expect(restored.mood, entry.mood);
    expect(restored.energy, entry.energy);
    expect(restored.focus, entry.focus);
    expect(restored.sleep, entry.sleep);
    expect(restored.note, entry.note);
    expect(restored.frequency, entry.frequency);
    expect(restored.generatedSignalText, entry.generatedSignalText);
  });

  test('reads frequency from current and legacy storage keys', () {
    final Map<String, Object?> map = LunaEntry(
      id: 'entry-2',
      createdAt: DateTime(2026, 4, 25, 7, 20),
      updatedAt: DateTime(2026, 4, 25, 7, 30),
      dateKey: '2026-04-25',
      mood: Mood.calm,
      energy: Energy.low,
      focus: Focus.scattered,
      sleep: Sleep.poor,
      note: '',
      frequency: FrequencyTag.lunarRadio,
      generatedSignalText: '',
    ).toMap();

    expect(LunaEntry.fromMap(map).frequency, FrequencyTag.lunarRadio);

    map.remove('frequency');
    map['soundtrack'] = FrequencyTag.deepSpace.name;

    expect(LunaEntry.fromMap(map).frequency, FrequencyTag.deepSpace);
  });

  test('falls back safely when log storage contains invalid values', () {
    final LunaEntry restored = LunaEntry.fromMap(<String, Object?>{
      'id': 42,
      'createdAt': 7,
      'updatedAt': false,
      'dateKey': null,
      'mood': 'unknown',
      'energy': <String>[],
      'focus': 3,
      'sleep': 'missing',
      'note': 11,
      'frequency': 'static',
      'generatedSignalText': null,
    });

    expect(restored.id, isNotEmpty);
    expect(restored.dateKey, isNotEmpty);
    expect(restored.mood, Mood.calm);
    expect(restored.energy, Energy.steady);
    expect(restored.focus, Focus.gentle);
    expect(restored.sleep, Sleep.okay);
    expect(restored.note, isEmpty);
    expect(restored.frequency, FrequencyTag.lofi);
    expect(restored.generatedSignalText, isEmpty);
  });

  test('sorts logs by one primary entry per day', () {
    final LunaEntry first = LunaEntry(
      id: 'first',
      createdAt: DateTime(2026, 4, 24, 9),
      updatedAt: DateTime(2026, 4, 24, 10),
      dateKey: '2026-04-24',
      mood: Mood.calm,
      energy: Energy.steady,
      focus: Focus.gentle,
      sleep: Sleep.okay,
      note: 'first',
      frequency: FrequencyTag.lofi,
      generatedSignalText: 'first signal',
    );
    final LunaEntry updated = LunaEntry(
      id: 'first',
      createdAt: DateTime(2026, 4, 24, 9),
      updatedAt: DateTime(2026, 4, 24, 20),
      dateKey: '2026-04-24',
      mood: Mood.bright,
      energy: Energy.high,
      focus: Focus.sharp,
      sleep: Sleep.good,
      note: 'updated',
      frequency: FrequencyTag.lunarRadio,
      generatedSignalText: 'updated signal',
    );

    final List<LunaEntry> entries = sortDailyEntries(<LunaEntry>[
      first,
      updated,
    ]);

    expect(entries, hasLength(1));
    expect(entries.single.note, 'updated');
  });

  test('uses date keys as the source of truth for log insights', () {
    final LogInsights insights = buildLogInsights(<LunaEntry>[
      LunaEntry(
        id: 'late-sync',
        createdAt: DateTime(2026, 3, 31, 23, 55),
        updatedAt: DateTime(2026, 4, 1, 0, 5),
        dateKey: '2026-04-01',
        mood: Mood.calm,
        energy: Energy.steady,
        focus: Focus.gentle,
        sleep: Sleep.okay,
        note: '',
        frequency: FrequencyTag.lofi,
        generatedSignalText: '',
      ),
    ], DateTime(2026, 4, 1, 12));

    expect(insights.loggedDaysThisMonth, 1);
    expect(insights.currentStreak, 1);
    expect(insights.loggedDays.single, DateTime(2026, 4, 1));
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

  test('ignores invalid companion ids while restoring settings', () {
    final AppSettings restored = AppSettings.fromMap(<String, Object?>{
      'unlockedCompanions': <Object?>['moon-cat', 7, null, 'signal-bot'],
    });

    expect(restored.unlockedCompanions, <String>['moon-cat', 'signal-bot']);
  });

  test('falls back safely when settings storage contains invalid values', () {
    final AppSettings restored = AppSettings.fromMap(<String, Object?>{
      'language': 1,
      'themeMode': 'unknown',
      'firstLaunchCompleted': 'yes',
      'baseProgressLevel': '3',
      'streakCountCached': false,
    });

    expect(restored.language, AppLanguage.zh);
    expect(restored.themeMode, LunarThemeMode.dark);
    expect(restored.firstLaunchCompleted, isTrue);
    expect(restored.baseProgressLevel, 1);
    expect(restored.streakCountCached, 0);
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
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);
  });

  testWidgets('saving a log updates home, log history, and stats', (
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

    await _tapNavigationItem(tester, 'Add');
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

    await _tapNavigationItem(tester, 'Log');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Timeline'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Timeline'), findsOneWidget);
    expect(find.textContaining('Main relay is calm'), findsOneWidget);

    await _tapNavigationItem(tester, 'Stats');
    await tester.pumpAndSettle();

    expect(find.text('Station Stats'), findsOneWidget);
    expect(find.text('Streak Beacon'), findsOneWidget);
    expect(find.text('Companion Signal'), findsOneWidget);
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

    await _tapNavigationItem(tester, '个人设置');
    await tester.pumpAndSettle();
    await tester.tap(find.text('英文'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Contact & Support'), findsOneWidget);
    expect(find.text('How to Use'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.theme?.scaffoldBackgroundColor, const Color(0xFFF1F4FA));
  });
}

Future<void> _tapNavigationItem(WidgetTester tester, String label) async {
  await tester.tap(find.text(label).last);
}
