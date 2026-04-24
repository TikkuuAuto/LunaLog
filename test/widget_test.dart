import 'package:flutter_test/flutter_test.dart';
import 'package:luna_log/main.dart';

void main() {
  testWidgets('shows Luna Log home shell', (WidgetTester tester) async {
    await tester.pumpWidget(const LunaLogApp());

    expect(find.text('Luna Log / 月面日志'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
  });
}
