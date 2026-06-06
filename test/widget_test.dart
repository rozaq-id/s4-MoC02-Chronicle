// Chronicle widget test

import 'package:flutter_test/flutter_test.dart';
import 'package:chronicle/main.dart';

void main() {
  testWidgets('App renders login page', (WidgetTester tester) async {
    await tester.pumpWidget(const ChronicleApp());
    expect(find.text('Sign In'), findsOneWidget);
  });
}
