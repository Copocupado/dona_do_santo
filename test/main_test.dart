import 'package:dona_do_santo/backend/firebase/firebase_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dona_do_santo/main.dart'; // Adjust the import if needed

void main() {
  testWidgets('Splash screen displays and navigates correctly', (WidgetTester tester) async {

    await FirebaseApi.initFirebase();
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // Ensure MyApp is your main widget

    // Check if the splash screen is displayed initially
    expect(find.text('Splash Screen'), findsOneWidget); // Replace with your actual splash screen text

    // Wait for the splash screen duration (adjust this as per your actual duration)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify that after the splash screen, the home screen is displayed
    expect(find.text('Home'), findsOneWidget); // Replace with your actual home screen text
  });
}
