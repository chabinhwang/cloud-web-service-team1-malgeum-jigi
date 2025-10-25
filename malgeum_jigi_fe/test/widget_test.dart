// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:malgeum_jigi_fe/main.dart';
import 'package:malgeum_jigi_fe/utils/theme_provider.dart';

void main() {
  testWidgets('MainScreen loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final themeProvider = ThemeProvider();
    await themeProvider.init();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: const MyApp(),
      ),
    );

    // Verify that the app title is displayed
    expect(find.text('맑음지기'), findsOneWidget);
  });
}
