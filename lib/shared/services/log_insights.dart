import '../models/daily_log.dart';
import '../models/log_enums.dart';
import '../utils/date_utils.dart';

class LogInsights {
  const LogInsights({
    required this.entries,
    required this.loggedDays,
    required this.loggedDaysThisMonth,
    required this.currentStreak,
    required this.longestStreak,
    required this.commonMood,
    required this.commonFrequency,
  });

  final List<LunaEntry> entries;
  final List<DateTime> loggedDays;
  final int loggedDaysThisMonth;
  final int currentStreak;
  final int longestStreak;
  final Mood? commonMood;
  final FrequencyTag? commonFrequency;

  bool get hasEntries => entries.isNotEmpty;
}

LogInsights buildLogInsights(List<LunaEntry> entries, DateTime now) {
  final List<LunaEntry> dailyEntries = sortDailyEntries(entries);
  final List<DateTime> loggedDays = _uniqueLoggedDays(dailyEntries);
  return LogInsights(
    entries: dailyEntries,
    loggedDays: loggedDays,
    loggedDaysThisMonth: loggedDays
        .where((DateTime day) => day.year == now.year && day.month == now.month)
        .length,
    currentStreak: _currentStreak(loggedDays, now),
    longestStreak: _longestStreak(loggedDays),
    commonMood: _mostCommon<Mood>(
      dailyEntries.map((LunaEntry entry) => entry.mood),
    ),
    commonFrequency: _mostCommon<FrequencyTag>(
      dailyEntries.map((LunaEntry entry) => entry.frequency),
    ),
  );
}

List<DateTime> _uniqueLoggedDays(List<LunaEntry> entries) {
  final Set<String> seenKeys = <String>{};
  final List<DateTime> days = <DateTime>[];
  for (final LunaEntry entry in entries) {
    final DateTime day =
        dateFromKey(entry.dateKey) ??
        DateTime(
          entry.createdAt.year,
          entry.createdAt.month,
          entry.createdAt.day,
        );
    final String key = '${day.year}-${day.month}-${day.day}';
    if (seenKeys.add(key)) {
      days.add(day);
    }
  }
  days.sort((DateTime first, DateTime second) => second.compareTo(first));
  return days;
}

int _currentStreak(List<DateTime> days, DateTime now) {
  if (days.isEmpty) {
    return 0;
  }
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime newestDay = days.first;
  final int gapFromToday = today.difference(newestDay).inDays;
  if (gapFromToday > 1) {
    return 0;
  }
  int streak = 1;
  DateTime expected = newestDay.subtract(const Duration(days: 1));
  for (final DateTime day in days.skip(1)) {
    if (day == expected) {
      streak += 1;
      expected = expected.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
}

int _longestStreak(List<DateTime> days) {
  if (days.isEmpty) {
    return 0;
  }
  int longest = 1;
  int current = 1;
  for (int index = 1; index < days.length; index += 1) {
    final DateTime previous = days[index - 1];
    final DateTime day = days[index];
    if (previous.difference(day).inDays == 1) {
      current += 1;
    } else {
      current = 1;
    }
    if (current > longest) {
      longest = current;
    }
  }
  return longest;
}

T? _mostCommon<T>(Iterable<T> values) {
  final Map<T, int> counts = <T, int>{};
  for (final T value in values) {
    counts[value] = (counts[value] ?? 0) + 1;
  }
  T? winner;
  int winningCount = 0;
  for (final MapEntry<T, int> entry in counts.entries) {
    if (entry.value > winningCount) {
      winner = entry.key;
      winningCount = entry.value;
    }
  }
  return winner;
}
