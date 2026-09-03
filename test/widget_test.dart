import 'package:flutter_test/flutter_test.dart';
import 'package:cattinder/main.dart';
import 'package:cattinder/state/cat_tinder_state.dart';

void main() {
  testWidgets('CatTinderApp navigates across tabs successfully', (tester) async {
    final state = CatTinderState();

    await tester.pumpWidget(CatTinderApp(state: state));
    await tester.pumpAndSettle();

    // In Explore tab
    expect(find.text('CatTinder'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Switch to Matches tab
    await tester.tap(find.text('Matches'));
    await tester.pumpAndSettle();

    expect(find.text('Matches & Chats'), findsOneWidget);

    // Switch to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Feline Profile'), findsOneWidget);
    expect(find.textContaining('Whiskers'), findsWidgets);
    expect(find.text('Likes Given'), findsOneWidget);
    expect(find.text('Paws Matched'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
  });
}
