import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/main.dart';

void main() {
  testWidgets('App boots to Hangar tab', (tester) async {
    await tester.pumpWidget(const GalacticArchivesApp());
    await tester.pumpAndSettle();

    expect(find.text('HANGAR'), findsOneWidget);
    expect(find.text('Hangar'), findsOneWidget);
  });
}
