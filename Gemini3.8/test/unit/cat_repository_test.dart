import 'package:flutter_test/flutter_test.dart';
import 'package:cattinder/models/cat_profile.dart';
import 'package:cattinder/services/cat_chat_bot.dart';
import 'package:cattinder/services/cat_repository.dart';
import 'package:cattinder/state/cat_tinder_state.dart';

void main() {
  group('CatProfile and Models Test', () {
    test('CatProfile copyWith works correctly', () {
      const cat = CatProfile(
        id: '1',
        name: 'Milo',
        age: 2,
        breed: 'Tuxedo',
        bio: 'Gentleman cat',
        imageUrl: 'http://example.com/cat.jpg',
        tags: ['Cute'],
      );

      final updated = cat.copyWith(name: 'Sir Milo', age: 3);
      expect(updated.name, 'Sir Milo');
      expect(updated.age, 3);
      expect(updated.breed, 'Tuxedo');
    });
  });

  group('CatRepository Tests', () {
    late CatRepository repo;

    setUp(() {
      repo = CatRepository();
    });

    test('Initializes with seed profiles', () {
      expect(repo.deck.length, greaterThanOrEqualTo(10));
      expect(repo.matches.isEmpty, isTrue);
      expect(repo.hasMoreCards, isTrue);
      expect(repo.canRewind, isFalse);
    });

    test('Swipe left dequeues top card and allows rewind', () {
      final initialCount = repo.deck.length;
      final topCat = repo.currentCard;
      expect(topCat, isNotNull);

      final passed = repo.swipeLeft();
      expect(passed?.id, topCat?.id);
      expect(repo.deck.length, initialCount - 1);
      expect(repo.canRewind, isTrue);

      final rewound = repo.rewind();
      expect(rewound?.id, topCat?.id);
      expect(repo.deck.length, initialCount);
      expect(repo.currentCard?.id, topCat?.id);
    });

    test('Swipe right creates a match with welcome greeting', () {
      final topCat = repo.currentCard!;
      final match = repo.swipeRight();

      expect(match, isNotNull);
      expect(match?.profile.id, topCat.id);
      expect(repo.matches.length, 1);
      expect(match?.unreadCount, 1);
      expect(match?.lastMessage?.text, contains('Paws aligned'));

      final messages = repo.getMessages(match!.id);
      expect(messages.length, 1);
      expect(messages.first.isFromCat, isTrue);
    });

    test('Deck reset restores all seed profiles', () {
      repo.swipeLeft();
      repo.swipeRight();
      expect(repo.deck.length, CatRepository.initialSeedProfiles.length - 2);

      repo.resetDeck();
      expect(repo.deck.length, CatRepository.initialSeedProfiles.length);
    });
  });

  group('CatChatBot Tests', () {
    const profile = CatProfile(
      id: 'bot_cat',
      name: 'Felix',
      age: 4,
      breed: 'Tabby',
      bio: 'Loves treats',
      imageUrl: 'http://example.com/cat.jpg',
      tags: ['Tuna'],
    );

    test('Generates contextual replies for keywords', () {
      final tunaReply = CatChatBot.generateReply(profile, 'Do you want some tuna fish?');
      expect(tunaReply.toLowerCase(), contains('fish'));

      final laserReply = CatChatBot.generateReply(profile, 'Watch the red dot laser pointer!');
      expect(laserReply.toLowerCase(), contains('dot'));

      final napReply = CatChatBot.generateReply(profile, 'Time for a sunbeam nap');
      expect(napReply.toLowerCase(), contains('sunbeam'));
    });

    test('Generates delayed reply message', () async {
      final msg = await CatChatBot.generateReplyMessage(
        matchId: 'match_1',
        profile: profile,
        userText: 'Hello kitten',
        delay: Duration.zero,
      );
      expect(msg.matchId, 'match_1');
      expect(msg.senderId, profile.id);
      expect(msg.isFromCat, isTrue);
      expect(msg.text.isNotEmpty, isTrue);
    });
  });

  group('CatTinderState Tests', () {
    late CatTinderState state;

    setUp(() {
      state = CatTinderState();
    });

    test('Tracks swipe likes, passes, and paw matches', () {
      expect(state.likesGiven, 0);
      expect(state.passesGiven, 0);
      expect(state.pawsMatched, 0);

      state.swipeLeft();
      expect(state.passesGiven, 1);

      final match = state.swipeRight();
      expect(state.likesGiven, 1);
      expect(state.pawsMatched, 1);
      expect(match, isNotNull);
    });

    test('Sends user message and triggers bot reply', () async {
      final match = state.swipeRight()!;
      expect(state.getMessages(match.id).length, 1); // intro message

      final userMsg = await state.sendMessage(
        matchId: match.id,
        text: 'Where are the tuna treats?',
        triggerBotReply: true,
        botDelay: Duration.zero,
      );

      expect(userMsg, isNotNull);
      expect(userMsg?.text, 'Where are the tuna treats?');
      expect(state.messagesSent, 1);

      final allMsgs = state.getMessages(match.id);
      expect(allMsgs.length, 3); // intro + user msg + bot reply
      expect(allMsgs[1].isFromCat, isFalse);
      expect(allMsgs[2].isFromCat, isTrue);
      expect(allMsgs[2].text.toLowerCase(), contains('fish'));
    });

    test('Marks match as read', () {
      final match = state.swipeRight()!;
      expect(state.matches.first.unreadCount, 1);

      state.markMatchAsRead(match.id);
      expect(state.matches.first.unreadCount, 0);
    });
  });
}
