import 'package:flutter/material.dart';
import '../models/match.dart';
import '../state/cat_tinder_state.dart';
import 'chat_room_screen.dart';
import 'matches_chats_screen.dart';
import 'profile_screen.dart';
import 'swipe_deck_screen.dart';

class HomeShell extends StatefulWidget {
  final CatTinderState state;

  const HomeShell({super.key, required this.state});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  void _openChat(CatMatch match) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          state: widget.state,
          match: match,
        ),
      ),
    );
  }

  void _openChatFromDeck(CatMatch match) {
    _openChat(match);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final unreadTotal = widget.state.matches.fold<int>(
          0,
          (sum, m) => sum + m.unreadCount,
        );

        final screens = [
          SwipeDeckScreen(
            state: widget.state,
            onOpenChat: _openChatFromDeck,
          ),
          MatchesChatsScreen(
            state: widget.state,
            onOpenChat: _openChat,
          ),
          ProfileScreen(
            state: widget.state,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: const Color(0xFFFF6F61),
              unselectedItemColor: Colors.grey.shade400,
              backgroundColor: Colors.white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.style_rounded),
                  activeIcon: Icon(Icons.style_rounded),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: unreadTotal > 0,
                    label: Text('$unreadTotal'),
                    backgroundColor: const Color(0xFFFF6F61),
                    child: const Icon(Icons.forum_rounded),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: unreadTotal > 0,
                    label: Text('$unreadTotal'),
                    backgroundColor: const Color(0xFFFF6F61),
                    child: const Icon(Icons.forum_rounded),
                  ),
                  label: 'Matches',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
