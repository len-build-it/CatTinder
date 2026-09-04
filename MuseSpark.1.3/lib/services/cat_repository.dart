import '../models/cat_profile.dart';
import '../models/chat_message.dart';
import '../models/match.dart';

class CatRepository {
  static final List<CatProfile> initialSeedProfiles = [
    const CatProfile(
      id: 'cat_1',
      name: 'Mochi',
      age: 2,
      breed: 'Scottish Fold',
      bio: 'Laser Pointer Maestro. Professional napper, amateur parkourist. Will knock your glass down with zero regret.',
      imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800&q=80',
      tags: ['Laser Chase', 'Tuna Fan', 'Cuddler'],
      distanceKm: 2,
    ),
    const CatProfile(
      id: 'cat_2',
      name: 'Barnaby',
      age: 5,
      breed: 'British Shorthair',
      bio: 'Grumpy Napper. I demand silent admiration and freeze-dried salmon treats. Keep distance during nap intervals.',
      imageUrl: 'https://images.unsplash.com/photo-1573865526739-10659fec78a5?w=800&q=80',
      tags: ['Quiet Hours', 'Salmon Treats', 'Sunbeam Judge'],
      distanceKm: 4,
    ),
    const CatProfile(
      id: 'cat_3',
      name: 'Luna',
      age: 1,
      breed: 'Siamese',
      bio: 'Cardboard Box Connoisseur. If it fits, I sits. Operatic soprano vocal soloist promptly at 3:15 AM.',
      imageUrl: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?w=800&q=80',
      tags: ['Vocal Soloist', 'Box Inspector', 'High Jumper'],
      distanceKm: 3,
    ),
    const CatProfile(
      id: 'cat_4',
      name: 'Oliver',
      age: 3,
      breed: 'Orange Tabby',
      bio: '3 AM Zoomies Champion. Possesses exactly one orange brain cell, but uses it with unmatched enthusiasm.',
      imageUrl: 'https://images.unsplash.com/photo-1543852786-1cf6624b9987?w=800&q=80',
      tags: ['Orange Energy', 'Sprint Star', 'Curious Paws'],
      distanceKm: 1,
    ),
    const CatProfile(
      id: 'cat_5',
      name: 'Bella',
      age: 4,
      breed: 'Ragdoll',
      bio: 'Window Bird Watcher. Fluffy cloud seeking gentle feline company. 100% limp noodles when picked up.',
      imageUrl: 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=800&q=80',
      tags: ['Fluff Ball', 'Bird Watcher', 'Gentle Soul'],
      distanceKm: 5,
    ),
    const CatProfile(
      id: 'cat_6',
      name: 'Simba',
      age: 2,
      breed: 'Maine Coon',
      bio: 'Sunbeam Sleeper & Gentle Giant. Tail bigger than most small dogs. Extremely friendly to everyone.',
      imageUrl: 'https://images.unsplash.com/photo-1513360309081-38f0762daed1?w=800&q=80',
      tags: ['Giant Paws', 'Fluffy Tail', 'Friendly'],
      distanceKm: 6,
    ),
    const CatProfile(
      id: 'cat_7',
      name: 'Chloe',
      age: 6,
      breed: 'Persian',
      bio: 'Master Baker. Over 500,000 warm biscuits kneaded to date on fluffy fleece blankets.',
      imageUrl: 'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?w=800&q=80',
      tags: ['Biscuit Maker', 'Royal Nap', 'Purr Machine'],
      distanceKm: 2,
    ),
    const CatProfile(
      id: 'cat_8',
      name: 'Leo',
      age: 3,
      breed: 'Bengal',
      bio: 'Treat Dispenser Critic. Wild jungle markings, soft heart for crunchy salmon puffs and tall cat trees.',
      imageUrl: 'https://images.unsplash.com/photo-1518288774672-b94e808873ff?w=800&q=80',
      tags: ['Wild Spots', 'Agility King', 'Treat Hunter'],
      distanceKm: 7,
    ),
    const CatProfile(
      id: 'cat_9',
      name: 'Mia',
      age: 1,
      breed: 'Calico',
      bio: 'Feather Wand Hunter. Spunky tri-color spirit. Undefeated champion against string toys and stray socks.',
      imageUrl: 'https://images.unsplash.com/photo-1561948955-570b270e7c36?w=800&q=80',
      tags: ['String Hunter', 'Playful', 'Quick Paws'],
      distanceKm: 3,
    ),
    const CatProfile(
      id: 'cat_10',
      name: 'Ziggy',
      age: 4,
      breed: 'Sphynx',
      bio: 'Belly Rub Skeptic & Knit Sweater Enthusiast. Heated blankets and sunny radiators are my love language.',
      imageUrl: 'https://images.unsplash.com/photo-1508921912186-1d1a45ebb3c1?w=800&q=80',
      tags: ['Sweater Model', 'Warmth Seeker', 'Direct Stares'],
      distanceKm: 5,
    ),
    const CatProfile(
      id: 'cat_11',
      name: 'Milo',
      age: 3,
      breed: 'Tuxedo',
      bio: 'Dressed in black-tie formality 24/7. Polite head bumps and polite requests for midnight treats.',
      imageUrl: 'https://images.unsplash.com/photo-1507984211203-76701d7bb120?w=800&q=80',
      tags: ['Fancy Dressed', 'Pawsome', 'Gentleman'],
      distanceKm: 1,
    ),
  ];

  final List<CatProfile> _deck = [];
  final List<CatProfile> _history = [];
  final List<CatMatch> _matches = [];
  final Map<String, List<ChatMessage>> _messagesByMatch = {};

  CatRepository() {
    resetDeck();
  }

  List<CatProfile> get deck => List.unmodifiable(_deck);
  List<CatMatch> get matches => List.unmodifiable(_matches);
  bool get hasMoreCards => _deck.isNotEmpty;
  bool get canRewind => _history.isNotEmpty;

  void resetDeck() {
    _deck.clear();
    _deck.addAll(initialSeedProfiles);
    _history.clear();
  }

  CatProfile? get currentCard => _deck.isNotEmpty ? _deck.first : null;

  CatMatch? swipeRight() {
    if (_deck.isEmpty) return null;
    final likedCat = _deck.removeAt(0);
    _history.add(likedCat);

    // Mutual match triggered!
    final matchId = 'match_${likedCat.id}';
    final existingIndex = _matches.indexWhere((m) => m.id == matchId);
    
    final newMatch = CatMatch(
      id: matchId,
      profile: likedCat,
      matchedAt: DateTime.now(),
    );

    if (existingIndex >= 0) {
      _matches[existingIndex] = newMatch;
    } else {
      _matches.insert(0, newMatch);
      // Seed a welcome greeting message from the cat
      final introMessage = ChatMessage(
        id: 'msg_intro_${likedCat.id}',
        matchId: matchId,
        senderId: likedCat.id,
        text: 'Paws aligned! Nice to meet you 🐾 Meow!',
        timestamp: DateTime.now(),
        isFromCat: true,
      );
      _messagesByMatch[matchId] = [introMessage];
      _matches[0] = newMatch.copyWith(lastMessage: introMessage, unreadCount: 1);
    }
    return _matches.firstWhere((m) => m.id == matchId);
  }

  CatProfile? swipeLeft() {
    if (_deck.isEmpty) return null;
    final passedCat = _deck.removeAt(0);
    _history.add(passedCat);
    return passedCat;
  }

  CatProfile? rewind() {
    if (_history.isEmpty) return null;
    final restoredCat = _history.removeLast();
    _deck.insert(0, restoredCat);
    return restoredCat;
  }

  List<ChatMessage> getMessages(String matchId) {
    return List.unmodifiable(_messagesByMatch[matchId] ?? []);
  }

  void addMessage(ChatMessage message) {
    final list = _messagesByMatch.putIfAbsent(message.matchId, () => []);
    list.add(message);

    final matchIndex = _matches.indexWhere((m) => m.id == message.matchId);
    if (matchIndex >= 0) {
      final match = _matches[matchIndex];
      _matches[matchIndex] = match.copyWith(
        lastMessage: message,
        unreadCount: message.isFromCat ? match.unreadCount + 1 : 0,
      );
    }
  }

  void markMatchAsRead(String matchId) {
    final matchIndex = _matches.indexWhere((m) => m.id == matchId);
    if (matchIndex >= 0) {
      _matches[matchIndex] = _matches[matchIndex].copyWith(unreadCount: 0);
    }
  }
}
