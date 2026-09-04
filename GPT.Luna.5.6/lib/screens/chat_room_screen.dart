import 'package:flutter/material.dart';
import '../models/match.dart';
import '../state/cat_tinder_state.dart';
import '../widgets/chat_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  final CatTinderState state;
  final CatMatch match;
  final Duration botDelay;

  const ChatRoomScreen({
    super.key,
    required this.state,
    required this.match,
    this.botDelay = const Duration(milliseconds: 900),
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const List<String> _quickReactions = [
    '🐾 Meow',
    '😻 Purr',
    '😾 Hiss',
    '🐟 Tuna now',
    '🌿 Got catnip?',
    '🧶 Chase yarn',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.markMatchAsRead(widget.match.id);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    widget.state.sendMessage(
      matchId: widget.match.id,
      text: text,
      triggerBotReply: true,
      botDelay: widget.botDelay,
    );
    _scrollToBottom();
  }

  String _getCatStatus() {
    final name = widget.match.profile.name;
    final statuses = [
      'Chasing a red dot 🔴',
      'Sleeping in a sunbeam ☀️',
      'Thinking about tuna 🐟',
      'Sitting on the laptop 💻',
      'Baking biscuits 🐾',
    ];
    final index = name.hashCode.abs() % statuses.length;
    return statuses[index];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final messages = widget.state.getMessages(widget.match.id);
        final isTyping = widget.state.isTypingForMatch(widget.match.id);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF424242)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(
                      widget.match.profile.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: const Color(0xFFFFD1C7),
                        child: const Icon(Icons.pets,
                            size: 20, color: Color(0xFFFF6F61)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.match.profile.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    Text(
                      _getCatStatus(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Messages stream list
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text(
                            'Say meow to break the ice! 🐾',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            return ChatBubble(
                              message: msg,
                              catAvatarUrl: widget.match.profile.imageUrl,
                            );
                          },
                        ),
                ),

                // Typing indicator banner
                if (isTyping)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3E0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.pets,
                                size: 14, color: Color(0xFFFF6F61)),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.match.profile.name} is typing...',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF6F61),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Cat Quick-Reaction Bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickReactions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final reaction = _quickReactions[index];
                      return ActionChip(
                        key: Key('quick_chip_$reaction'),
                        backgroundColor: const Color(0xFFFFF0ED),
                        side: const BorderSide(
                          color: Color(0xFFFFD1C7),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        label: Text(
                          reaction,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF6F61),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => _sendMessage(reaction),
                      );
                    },
                  ),
                ),

                // Bottom text input bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _textController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Meow something sweet...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: _sendMessage,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: const Color(0xFFFF6F61),
                        shape: const CircleBorder(),
                        child: InkWell(
                          key: const Key('chat_send_button'),
                          customBorder: const CircleBorder(),
                          onTap: () => _sendMessage(_textController.text),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
