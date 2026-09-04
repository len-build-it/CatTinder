import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cattinder/models/cat_profile.dart';
import 'package:cattinder/screens/swipe_deck_screen.dart';
import 'package:cattinder/state/cat_tinder_state.dart';
import 'package:cattinder/widgets/cat_card.dart';
import 'package:cattinder/widgets/match_dialog.dart';

void main() {
  const testProfile = CatProfile(
    id: 'test_cat',
    name: 'Mochi',
    age: 2,
    breed: 'Scottish Fold',
    bio: 'Laser Pointer Maestro. Professional napper.',
    imageUrl: 'http://example.com/mochi.jpg',
    tags: ['Laser Chase', 'Tuna Fan'],
    distanceKm: 2,
  );

  testWidgets('CatCard renders profile details correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CatCard(profile: testProfile),
        ),
      ),
    );

    expect(find.text('Mochi'), findsWidgets);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Scottish Fold'), findsOneWidget);
    expect(find.text('2 km away'), findsOneWidget);
    expect(find.text('Laser Chase'), findsOneWidget);
    expect(find.text('Tuna Fan'), findsOneWidget);
  });

  testWidgets('SwipeDeckScreen renders top card and action buttons', (tester) async {
    final state = CatTinderState();

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDeckScreen(state: state),
      ),
    );

    expect(find.text('CatTinder'), findsOneWidget);
    expect(find.text('Mochi'), findsWidgets);
    expect(find.byKey(const Key('swipe_deck_pass_button')), findsOneWidget);
    expect(find.byKey(const Key('swipe_deck_like_button')), findsOneWidget);
    expect(find.byKey(const Key('swipe_deck_rewind_button')), findsOneWidget);
  });

  testWidgets('Tapping Like button triggers swipe and shows MatchDialog', (tester) async {
    final state = CatTinderState();

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDeckScreen(state: state),
      ),
    );

    // Tap Like button
    await tester.tap(find.byKey(const Key('swipe_deck_like_button')));
    await tester.pumpAndSettle();

    // MatchDialog should be displayed
    expect(find.byType(MatchDialog), findsOneWidget);
    expect(find.text("It's a Match!"), findsOneWidget);
    expect(find.text('Paws Aligned 🐾'), findsOneWidget);
    expect(find.byKey(const Key('match_dialog_chat_button')), findsOneWidget);
    expect(find.byKey(const Key('match_dialog_keep_swiping_button')), findsOneWidget);

    // Tap Keep Swiping to dismiss
    await tester.tap(find.byKey(const Key('match_dialog_keep_swiping_button')));
    await tester.pumpAndSettle();

    expect(find.byType(MatchDialog), findsNothing);
  });

  testWidgets('Tapping Pass button dequeues card and enables Rewind', (tester) async {
    final state = CatTinderState();

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDeckScreen(state: state),
      ),
    );

    final initialCount = state.deck.length;

    // Tap Pass
    await tester.tap(find.byKey(const Key('swipe_deck_pass_button')));
    await tester.pumpAndSettle();

    expect(state.deck.length, initialCount - 1);
    expect(state.canRewind, isTrue);

    // Tap Rewind
    await tester.tap(find.byKey(const Key('swipe_deck_rewind_button')));
    await tester.pumpAndSettle();

    expect(state.deck.length, initialCount);
  });

  testWidgets('Empty deck renders empty state and Find More Cats reloads', (tester) async {
    final state = CatTinderState();
    // Empty the deck
    while (state.hasMoreCards) {
      state.swipeLeft();
    }

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDeckScreen(state: state),
      ),
    );

    expect(find.text('No More Cats Around!'), findsOneWidget);
    expect(find.byKey(const Key('swipe_deck_reload_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('swipe_deck_reload_button')));
    await tester.pumpAndSettle();

    expect(find.text('Mochi'), findsWidgets);
    expect(state.hasMoreCards, isTrue);
  });
}
