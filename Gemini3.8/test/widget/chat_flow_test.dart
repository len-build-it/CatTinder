import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cattinder/models/match.dart';
import 'package:cattinder/screens/chat_room_screen.dart';
import 'package:cattinder/screens/matches_chats_screen.dart';
import 'package:cattinder/state/cat_tinder_state.dart';
import 'package:cattinder/widgets/chat_bubble.dart';

void main() {
  testWidgets('MatchesChatsScreen renders empty state when no matches', (tester) async {
    final state = CatTinderState();

    await tester.pumpWidget(
      MaterialApp(
        home: MatchesChatsScreen(
          state: state,
          onOpenChat: (_) {},
        ),
      ),
    );

    expect(find.text('Matches & Chats'), findsOneWidget);
    expect(find.text('No Matches Yet!'), findsOneWidget);
  });

  testWidgets('MatchesChatsScreen renders match tray and chat list when matches exist', (tester) async {
    final state = CatTinderState();
    final match = state.swipeRight()!; // Match with Mochi

    CatMatch? openedMatch;

    await tester.pumpWidget(
      MaterialApp(
        home: MatchesChatsScreen(
          state: state,
          onOpenChat: (m) => openedMatch = m,
        ),
      ),
    );

    expect(find.text('New Matches 🐾'), findsOneWidget);
    expect(find.text('Conversations'), findsOneWidget);
    expect(find.text(match.profile.name), findsWidgets);
    expect(find.textContaining('Paws aligned'), findsOneWidget);

    // Tap the conversation item
    await tester.tap(find.byKey(Key('chat_tile_${match.profile.id}')));
    await tester.pumpAndSettle();

    expect(openedMatch?.id, match.id);
  });

  testWidgets('ChatRoomScreen allows sending messages and displays bubbles', (tester) async {
    final state = CatTinderState();
    final match = state.swipeRight()!;

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomScreen(
          state: state,
          match: match,
          botDelay: Duration.zero,
        ),
      ),
    );

    // Verify initial message from cat exists
    expect(find.textContaining('Paws aligned'), findsOneWidget);

    // Enter text in TextField and send
    await tester.enterText(find.byType(TextField), 'Hello sweet kitty!');
    await tester.tap(find.byKey(const Key('chat_send_button')));
    await tester.pumpAndSettle();

    // Verify user message bubble is displayed
    expect(find.text('Hello sweet kitty!'), findsOneWidget);
    // Verify automated bot response is generated
    expect(state.getMessages(match.id).length, 3);
  });

  testWidgets('ChatRoomScreen quick reaction chip sends immediately', (tester) async {
    final state = CatTinderState();
    final match = state.swipeRight()!;

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomScreen(
          state: state,
          match: match,
          botDelay: Duration.zero,
        ),
      ),
    );

    // Tap quick reaction chip '🐟 Tuna now'
    final tunaChip = find.byKey(const Key('quick_chip_🐟 Tuna now'));
    expect(tunaChip, findsOneWidget);

    await tester.tap(tunaChip);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(ChatBubble),
        matching: find.text('🐟 Tuna now'),
      ),
      findsOneWidget,
    );
    // Cat bot should have responded to tuna with fish keyword
    final msgs = state.getMessages(match.id);
    expect(msgs.last.text.toLowerCase(), contains('fish'));
  });
}
