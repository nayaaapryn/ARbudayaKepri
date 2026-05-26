import 'package:flutter_test/flutter_test.dart';
import 'package:ar_budaya_kepri/main.dart';

void main() {
  testWidgets('App startup smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ARBudayaKepriApp());

    // Wait for the mock data loading delays to settle
    await tester.pumpAndSettle();

    // Verify that our home dashboard loads and displays the app name
    expect(find.text('AR Budaya Kepri'), findsOneWidget);
  });
}
