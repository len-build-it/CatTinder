import 'cat_profile.dart';
import 'chat_message.dart';

class CatMatch {
  final String id;
  final CatProfile profile;
  final DateTime matchedAt;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const CatMatch({
    required this.id,
    required this.profile,
    required this.matchedAt,
    this.lastMessage,
    this.unreadCount = 0,
  });

  CatMatch copyWith({
    String? id,
    CatProfile? profile,
    DateTime? matchedAt,
    ChatMessage? lastMessage,
    int? unreadCount,
  }) {
    return CatMatch(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      matchedAt: matchedAt ?? this.matchedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
