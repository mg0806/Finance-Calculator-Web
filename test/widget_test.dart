import 'package:flutter_test/flutter_test.dart';

import 'package:finance_calculator/main.dart';

void main() {
  testWidgets('shows finance dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceCalculatorApp());

    expect(find.text('Calculate smarter.\nMove faster.'), findsOneWidget);
    expect(find.text('SIP calculator'), findsOneWidget);
    expect(find.text('EMI calculator'), findsOneWidget);
  });

  testWidgets('opens SIP calculator from dashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceCalculatorApp());

    await tester.tap(find.text('SIP calculator'));
    await tester.pumpAndSettle();

    expect(find.text('Monthly SIP'), findsOneWidget);
    expect(find.text('Maturity value'), findsOneWidget);
  });
}
