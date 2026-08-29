import 'package:flutter_test/flutter_test.dart';

import 'package:martigo/app/app.dart';

void main() {
  testWidgets('App builds without throwing', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    // A basic smoke test: the app should render its first screen
    // (the Splash screen) without throwing any errors.
    expect(find.byType(App), findsOneWidget);
  });
}
