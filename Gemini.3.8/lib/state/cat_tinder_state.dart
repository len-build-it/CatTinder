import 'package:flutter/foundation.dart';
import '../models/cat_profile.dart';
import '../models/chat_message.dart';
import '../models/match.dart';
import '../services/cat_chat_bot.dart';
import '../services/cat_repository.dart';

class CatTinderState extends ChangeNotifier {
  final CatRepository _repository;
  final Map<String, bool> _typingStatus = {};

  int _likesGiven = 0;
  int _passesGiven = 0;
  int _messagesSent = 0;

  final CatProfile userProfile = const CatProfile(
    id: 'user_cat',
    name: 'Whiskers',
    age: 3,
    breed: 'Scottish Fold Mix',
    bio: 'Professional yarn untangler, sunbeam connoisseur, and 2 AM vocal warm-up specialist. Seeking someone to chase flies with.',
    imageUrl: 'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7?w=800&q=80',
    tags: ['Yarn Expert', 'Sunbeam Chaser', 'Vocal Talent', 'Gentle Paws'],
    distanceKm: 0,
  );

  CatTinderState({CatRepository? repository})
      : _repository = repository ?? CatRepository();

  CatRepository get repository => _repository;
  List<CatProfile> get deck => _repository.deck;
  List<CatMatch> get matches => _repository.matches;
  bool get hasMoreCards => _repository.hasMoreCards;
  bool get canRewind => _repository.canRewind;
  CatProfile? get currentCard => _repository.currentCard;

  int get likesGiven => _likesGiven;
  int get passesGiven => _passesGiven;
  int get pawsMatched => _repository.matches.length;
  int get messagesSent => _messagesSent;

  bool isTypingForMatch(String matchId) => _typingStatus[matchId] ?? false;

  List<ChatMessage> getMessages(String matchId) => _repository.getMessages(matchId);

  CatMatch? swipeRight() {
    final match = _repository.swipeRight();
    if (match != null) {
      _likesGiven++;
      notifyListeners();
    }
    return match;
  }

  CatProfile? swipeLeft() {
    final profile = _repository.swipeLeft();
    if (profile != null) {
      _passesGiven++;
      notifyListeners();
    }
    return profile;
  }

  CatProfile? rewind() {
    final cat = _repository.rewind();
    if (cat != null) {
      notifyListeners();
    }
    return cat;
  }

  void resetDeck() {
    _repository.resetDeck();
    notifyListeners();
  }

  void markMatchAsRead(String matchId) {
    _repository.markMatchAsRead(matchId);
    notifyListeners();
  }

  Future<ChatMessage?> sendMessage({
    required String matchId,
    required String text,
    bool triggerBotReply = true,
    Duration botDelay = const Duration(milliseconds: 900),
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final userMsg = ChatMessage(
      id: 'msg_user_${DateTime.now().millisecondsSinceEpoch}',
      matchId: matchId,
      senderId: userProfile.id,
      text: trimmed,
      timestamp: DateTime.now(),
      isFromCat: false,
    );

    _repository.addMessage(userMsg);
    _messagesSent++;
    notifyListeners();

    if (triggerBotReply) {
      final matchIndex = _repository.matches.indexWhere((m) => m.id == matchId);
      if (matchIndex >= 0) {
        final matchedCat = _repository.matches[matchIndex].profile;
        _typingStatus[matchId] = true;
        notifyListeners();

        try {
          final botReply = await CatChatBot.generateReplyMessage(
            matchId: matchId,
            profile: matchedCat,
            userText: trimmed,
            delay: botDelay,
          );
          _repository.addMessage(botReply);
        } finally {
          _typingStatus[matchId] = false;
          notifyListeners();
        }
      }
    }

    return userMsg;
  }
}
