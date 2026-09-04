import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/match.dart';
import '../state/cat_tinder_state.dart';
import '../widgets/cat_card.dart';
import '../widgets/match_dialog.dart';

class SwipeDeckScreen extends StatefulWidget {
  final CatTinderState state;
  final ValueChanged<CatMatch>? onOpenChat;

  const SwipeDeckScreen({
    super.key,
    required this.state,
    this.onOpenChat,
  });

  @override
  State<SwipeDeckScreen> createState() => _SwipeDeckScreenState();
}

class _SwipeDeckScreenState extends State<SwipeDeckScreen>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _animController.addListener(() {
      if (_slideAnimation != null) {
        setState(() {
          _dragOffset = _slideAnimation!.value;
        });
      }
    });
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragOffset.dx > 150) {
          _handleSwipeRight();
        } else if (_dragOffset.dx < -150) {
          _handleSwipeLeft();
        }
        _dragOffset = Offset.zero;
        _slideAnimation = null;
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleSwipeRight() {
    final match = widget.state.swipeRight();
    if (match != null && mounted) {
      _showMatchDialog(match);
    }
  }

  void _handleSwipeLeft() {
    widget.state.swipeLeft();
  }

  void _showMatchDialog(CatMatch match) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => MatchDialog(
        match: match,
        userProfile: widget.state.userProfile,
        onKeepSwiping: () {
          Navigator.of(dialogCtx).pop();
        },
        onStartChat: () {
          Navigator.of(dialogCtx).pop();
          widget.onOpenChat?.call(match);
        },
      ),
    );
  }

  void _programmaticSwipe(bool isRight) {
    if (!widget.state.hasMoreCards || _animController.isAnimating) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isRight ? screenWidth * 1.3 : -screenWidth * 1.3;

    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(targetX, 0),
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top App Header
                _buildHeader(),

                // Card Stack Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: widget.state.hasMoreCards
                        ? _buildCardStack()
                        : _buildEmptyState(),
                  ),
                ),

                // Bottom Action Buttons
                _buildActionButtons(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F61).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets,
                  color: Color(0xFFFF6F61),
                  size: 26,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'CatTinder',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF6F61),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 16, color: Color(0xFFFF6F61)),
                const SizedBox(width: 6),
                Text(
                  '${widget.state.pawsMatched} matches',
                  style: const TextStyle(
                    color: Color(0xFFFF6F61),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    final deck = widget.state.deck;
    final topProfile = deck.first;
    final nextProfile = deck.length > 1 ? deck[1] : null;

    final screenWidth = MediaQuery.of(context).size.width;
    final dragFraction = (_dragOffset.dx / (screenWidth * 0.5)).clamp(-1.0, 1.0);
    final rotation = (_dragOffset.dx / screenWidth) * 0.35;

    return Stack(
      children: [
        // Background card peek
        if (nextProfile != null)
          Positioned.fill(
            child: Transform.scale(
              scale: 0.95 + (dragFraction.abs() * 0.05),
              child: CatCard(profile: nextProfile),
            ),
          ),

        // Foreground active draggable card
        Positioned.fill(
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _dragOffset += details.delta;
              });
            },
            onPanEnd: (details) {
              if (_dragOffset.dx > 110) {
                _slideAnimation = Tween<Offset>(
                  begin: _dragOffset,
                  end: Offset(screenWidth * 1.3, _dragOffset.dy),
                ).animate(
                    CurvedAnimation(parent: _animController, curve: Curves.easeOut));
                _animController.forward(from: 0);
              } else if (_dragOffset.dx < -110) {
                _slideAnimation = Tween<Offset>(
                  begin: _dragOffset,
                  end: Offset(-screenWidth * 1.3, _dragOffset.dy),
                ).animate(
                    CurvedAnimation(parent: _animController, curve: Curves.easeOut));
                _animController.forward(from: 0);
              } else {
                _slideAnimation = Tween<Offset>(
                  begin: _dragOffset,
                  end: Offset.zero,
                ).animate(
                    CurvedAnimation(parent: _animController, curve: Curves.easeOut));
                _animController.forward(from: 0);
              }
            },
            child: Transform.translate(
              offset: _dragOffset,
              child: Transform.rotate(
                angle: rotation,
                child: Stack(
                  children: [
                    CatCard(profile: topProfile),

                    // LIKE stamp overlay
                    if (_dragOffset.dx > 20)
                      Positioned(
                        top: 40,
                        left: 24,
                        child: Transform.rotate(
                          angle: -math.pi / 12,
                          child: Opacity(
                            opacity: (dragFraction).clamp(0.0, 1.0),
                            child: _buildStamp(
                              label: 'LIKE 🐾',
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ),

                    // NOPE stamp overlay
                    if (_dragOffset.dx < -20)
                      Positioned(
                        top: 40,
                        right: 24,
                        child: Transform.rotate(
                          angle: math.pi / 12,
                          child: Opacity(
                            opacity: (-dragFraction).clamp(0.0, 1.0),
                            child: _buildStamp(
                              label: 'NOPE 😿',
                              color: const Color(0xFFE53935),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStamp({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 3.5),
        color: color.withValues(alpha: 0.15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
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
              child: const Icon(Icons.pets, size: 64, color: Color(0xFFFF6F61)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No More Cats Around!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You have seen all nearby felines in your territory. Shake the treat jar or reload the deck to keep matching!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              key: const Key('swipe_deck_reload_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6F61),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                widget.state.resetDeck();
              },
              icon: const Icon(Icons.refresh),
              label: const Text(
                'Find More Cats',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final hasCards = widget.state.hasMoreCards;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Rewind / Undo
          _buildCircleButton(
            key: const Key('swipe_deck_rewind_button'),
            icon: Icons.replay,
            iconColor: const Color(0xFFFFA000),
            size: 48,
            enabled: widget.state.canRewind,
            onPressed: () {
              widget.state.rewind();
            },
          ),

          // Pass / Dislike
          _buildCircleButton(
            key: const Key('swipe_deck_pass_button'),
            icon: Icons.close_rounded,
            iconColor: const Color(0xFFE53935),
            size: 60,
            enabled: hasCards,
            onPressed: () => _programmaticSwipe(false),
          ),

          // Superlike
          _buildCircleButton(
            key: const Key('swipe_deck_superlike_button'),
            icon: Icons.star_rounded,
            iconColor: const Color(0xFF00B0FF),
            size: 48,
            enabled: hasCards,
            onPressed: () => _programmaticSwipe(true),
          ),

          // Like / Paw
          _buildCircleButton(
            key: const Key('swipe_deck_like_button'),
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFF4CAF50),
            size: 60,
            enabled: hasCards,
            onPressed: () => _programmaticSwipe(true),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    Key? key,
    required IconData icon,
    required Color iconColor,
    required double size,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Material(
      key: key,
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: enabled ? 4 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onPressed : null,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.52,
            color: enabled ? iconColor : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
