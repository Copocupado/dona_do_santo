import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dona_do_santo/main.dart'; // Adjust the import if needed

void main() {
  testWidgets('Main app initializes correctly', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Use MyApp as your main widget

    // Verify that the app starts with a specific widget
    expect(find.text('Home'), findsOneWidget); // Change this to a widget that should be present
    expect(find.byType(NavBarPage), findsOneWidget); // Check for the NavBarPage
  });
}
