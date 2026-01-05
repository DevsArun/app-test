import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Calculator widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify that the app builds without errors
    expect(find.byType(CalculatorApp), findsOneWidget);
    expect(find.text('Calculator'), findsOneWidget);
  });
}
