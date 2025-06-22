import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:travelbuddy_flutter/shared/theme_notifier.dart';
import 'package:travelbuddy_flutter/main.dart';  // enthält AppWithTheme
// oder: import 'package:travelbuddy_flutter/app_with_theme.dart';

void main() {
  testWidgets('App startet und Counter-Example funktioniert',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const AppWithTheme(),   // <-- nicht mehr MyApp
      ),
    );

    // Beispiel-Assertions (falls du noch den Counter aus starter_app hast):
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
