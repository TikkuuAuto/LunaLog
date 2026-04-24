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

String formatDate(DateTime value, AppLanguage language) {
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  if (language == AppLanguage.zh) {
    return '${value.year}年$month月$day日';
  }
  return '${value.year}-$month-$day';
}
