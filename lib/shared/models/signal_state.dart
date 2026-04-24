import 'daily_log.dart';

class SignalState {
  const SignalState({
    required this.entry,
    required this.signalText,
    required this.hasEntry,
  });

  final LunaEntry? entry;
  final String signalText;
  final bool hasEntry;

  factory SignalState.fromEntry({
    required LunaEntry? entry,
    required String emptySignal,
    required String Function(LunaEntry entry) fallbackSignalBuilder,
  }) {
    if (entry == null) {
      return SignalState(entry: null, signalText: emptySignal, hasEntry: false);
    }
    return SignalState(
      entry: entry,
      signalText: entry.generatedSignalText.isEmpty
          ? fallbackSignalBuilder(entry)
          : entry.generatedSignalText,
      hasEntry: true,
    );
  }
}
