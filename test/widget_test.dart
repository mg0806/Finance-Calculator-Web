import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_calculator/main.dart';

void main() {
  testWidgets('shows home landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceCalculatorApp());

    await tester.pumpAndSettle();

    expect(find.text('Smart Financial Decisions Start Here'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -420));
    await tester.pumpAndSettle();

    expect(find.text('SIP Calculator'), findsOneWidget);
    expect(find.text('EMI Calculator'), findsOneWidget);
  });

  testWidgets('opens SIP calculator from home', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceCalculatorApp());

    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -420));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SIP Calculator'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SIP Calculator'));
    await tester.pumpAndSettle();

    expect(find.text('Monthly SIP'), findsOneWidget);
    expect(find.text('Maturity value'), findsOneWidget);
  });
}
