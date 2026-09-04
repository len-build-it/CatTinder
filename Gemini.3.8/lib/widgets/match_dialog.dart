import 'package:flutter/material.dart';
import '../models/cat_profile.dart';
import '../models/match.dart';

class MatchDialog extends StatelessWidget {
  final CatMatch match;
  final CatProfile userProfile;
  final VoidCallback onKeepSwiping;
  final VoidCallback onStartChat;

  const MatchDialog({
    super.key,
    required this.match,
    required this.userProfile,
    required this.onKeepSwiping,
    required this.onStartChat,
  });

  Widget _buildAvatar(String imageUrl, String name) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6F61).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFFFD1C7),
                child: const Icon(Icons.pets, size: 40, color: Color(0xFFFF6F61)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6F61), Color(0xFFFF8E72)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6F61).withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top paw celebration
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pets, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "It's a Match!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Paws Aligned 🐾',
              style: TextStyle(
                color: Color(0xFFFFF0ED),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Side-by-side Avatars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatar(userProfile.imageUrl, userProfile.name),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Color(0xFFFF6F61),
                      size: 24,
                    ),
                  ),
                ),
                _buildAvatar(match.profile.imageUrl, match.profile.name),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'You and ${match.profile.name} liked each other!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),

            // Send Meow (Chat) button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                key: const Key('match_dialog_chat_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF6F61),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: onStartChat,
                icon: const Icon(Icons.chat_bubble_rounded),
                label: const Text(
                  'Send a Meow',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Keep Swiping button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                key: const Key('match_dialog_keep_swiping_button'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: onKeepSwiping,
                child: const Text(
                  'Keep Swiping',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
