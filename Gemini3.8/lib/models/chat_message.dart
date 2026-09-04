class ChatMessage {
  final String id;
  final String matchId;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isFromCat;

  const ChatMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isFromCat,
  });
}
