import 'package:flutter/material.dart';
import '../models/match.dart';
import '../state/cat_tinder_state.dart';

class MatchesChatsScreen extends StatelessWidget {
  final CatTinderState state;
  final ValueChanged<CatMatch> onOpenChat;

  const MatchesChatsScreen({
    super.key,
    required this.state,
    required this.onOpenChat,
  });

  String _formatSnippetTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final matches = state.matches;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Icon(Icons.forum_rounded,
                    color: Color(0xFFFF6F61), size: 26),
                const SizedBox(width: 8),
                const Text(
                  'Matches & Chats',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${matches.length}',
                    style: const TextStyle(
                      color: Color(0xFFFF6F61),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: matches.isEmpty
              ? _buildEmptyState()
              : CustomScrollView(
                  slivers: [
                    // Matches Tray Header
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: Text(
                          'New Matches 🐾',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                    ),

                    // Horizontal Matches Avatar Carousel
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 104,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: matches.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final match = matches[index];
                            return GestureDetector(
                              key: Key('match_avatar_${match.profile.id}'),
                              onTap: () => onOpenChat(match),
                              child: Column(
                                children: [
                                  Container(
                                    width: 66,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6F61),
                                          Color(0xFFFFB2A6),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF6F61)
                                              .withValues(alpha: 0.25),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(2.5),
                                    child: ClipOval(
                                      child: Image.network(
                                        match.profile.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          color: const Color(0xFFFFD1C7),
                                          child: const Icon(Icons.pets,
                                              size: 30,
                                              color: Color(0xFFFF6F61)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 68,
                                    child: Text(
                                      match.profile.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 24,
                        thickness: 0.8,
                        color: Color(0xFFEEEEEE),
                      ),
                    ),

                    // Conversations Header
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                        child: Text(
                          'Conversations',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ),
                    ),

                    // Vertical Chat List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final match = matches[index];
                          final lastMsg = match.lastMessage;

                          return ListTile(
                            key: Key('chat_tile_${match.profile.id}'),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            onTap: () => onOpenChat(match),
                            leading: Stack(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      match.profile.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Container(
                                        color: const Color(0xFFFFD1C7),
                                        child: const Icon(Icons.pets,
                                            size: 26,
                                            color: Color(0xFFFF6F61)),
                                      ),
                                    ),
                                  ),
                                ),
                                if (match.unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6F61),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Text(
                              match.profile.name,
                              style: TextStyle(
                                fontWeight: match.unreadCount > 0
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 16,
                                color: const Color(0xFF2E2E2E),
                              ),
                            ),
                            subtitle: Text(
                              lastMsg != null
                                  ? lastMsg.text
                                  : 'Matched with ${match.profile.name}! Say hi.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: match.unreadCount > 0
                                    ? const Color(0xFF2E2E2E)
                                    : Colors.grey.shade600,
                                fontWeight: match.unreadCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: lastMsg != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatSnippetTime(lastMsg.timestamp),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: match.unreadCount > 0
                                              ? const Color(0xFFFF6F61)
                                              : Colors.grey.shade500,
                                          fontWeight: match.unreadCount > 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (match.unreadCount > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6F61),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${match.unreadCount}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : null,
                          );
                        },
                        childCount: matches.length,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE3E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_border_rounded,
                  size: 64, color: Color(0xFFFF6F61)),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Matches Yet!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Swipe right on cats in your neighborhood to fill your pawsome inbox with playdates!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
