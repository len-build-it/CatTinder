import 'package:flutter_test/flutter_test.dart';
import 'package:cattinder/main.dart';

void main() {
  testWidgets('CatTinder baseline smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CatTinderApp());
    expect(find.text('CatTinder 🐾'), findsOneWidget);
  });
}
