import 'dart:math';
import '../models/cat_profile.dart';
import '../models/chat_message.dart';

class CatChatBot {
  static final Random _random = Random();

  static const List<String> _generalFelineReplies = [
    'Meow! Let’s share some premium catnip sometime 🌿',
    'I just knocked a pen off the desk thinking of you.',
    'Purrrrrr... 😻',
    'Are you a laser pointer? Because I can’t take my eyes off you.',
    'Slow blink from across the room 🐾',
    'Sitting on your keyboard now: asdfkjl;meow!',
    'Staring intensely at the completely blank wall behind you...',
    '3 AM zoomies invitation: are you in?',
    'I brought you a leaf. Consider yourself honored.',
    'Headbutts your screen affectionately 😽',
  ];

  static String generateReply(CatProfile profile, String incomingText) {
    final lower = incomingText.toLowerCase();

    if (lower.contains('tuna') || lower.contains('fish') || lower.contains('salmon')) {
      return 'Did someone say FISH?! Crack the can open right meow! 🐟';
    }
    if (lower.contains('laser') || lower.contains('red dot')) {
      return 'I WILL CATCH THE RED DOT TODAY. Watch me pounce! 🔴💨';
    }
    if (lower.contains('nip') || lower.contains('catnip')) {
      return 'The nip is loud today! Rolling all over the rug rn 🌿✨';
    }
    if (lower.contains('sleep') || lower.contains('nap') || lower.contains('sunbeam')) {
      return 'Found the warmest sunbeam on the carpet. Nap with me? ☀️💤';
    }
    if (lower.contains('purr') || lower.contains('love') || lower.contains('cute')) {
      return 'Motor running at maximum RPM! Purrrrrr ❤️';
    }
    if (lower.contains('hiss') || lower.contains('grump') || lower.contains('bite')) {
      return 'Gentle love nibble! You only get 2.5 belly rubs, don’t push it 😾';
    }
    if (lower.contains('meow')) {
      return 'Mrrroowww! High paw! 🐾';
    }

    final index = _random.nextInt(_generalFelineReplies.length);
    return _generalFelineReplies[index];
  }

  static Future<ChatMessage> generateReplyMessage({
    required String matchId,
    required CatProfile profile,
    required String userText,
    Duration delay = const Duration(milliseconds: 1000),
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final replyText = generateReply(profile, userText);
    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}_${_random.nextInt(9999)}',
      matchId: matchId,
      senderId: profile.id,
      text: replyText,
      timestamp: DateTime.now(),
      isFromCat: true,
    );
  }
}
