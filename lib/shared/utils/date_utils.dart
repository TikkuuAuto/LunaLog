import '../models/log_enums.dart';

T enumByName<T extends Enum>(List<T> values, String? name, T fallback) {
  for (final T value in values) {
    if (value.name == name) {
      return value;
    }
  }
  return fallback;
}

String dateKeyFor(DateTime value) {
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

DateTime? dateFromKey(String key) {
  final List<String> parts = key.split('-');
  if (parts.length != 3) {
    return null;
  }
  final int? year = int.tryParse(parts[0]);
  final int? month = int.tryParse(parts[1]);
  final int? day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) {
    return null;
  }
  final DateTime parsed = DateTime(year, month, day);
  if (parsed.year != year || parsed.month != month || parsed.day != day) {
    return null;
  }
  return parsed;
}

String formatDate(DateTime value, AppLanguage language) {
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  if (language == AppLanguage.zh) {
    return '${value.year}年$month月$day日';
  }
  return '${value.year}-$month-$day';
}
