# Implementation Plan: CatTinder (Flutter MVP)

A swipe-and-match mobile app for cats to find feline playdates, designed for Flutter and simulated via Android Studio.

---

## Architecture Overview

```
lib/
├── main.dart                   # Entry point, Theme, App shell
├── models/                     # Core data models
│   ├── cat_profile.dart        # Profile data (name, breed, age, bio, images, badges)
│   ├── match.dart              # Match relationship record
│   └── chat_message.dart       # Message entity (sender, text, timestamp, isCat)
├── services/                   # Business logic & data handling
│   ├── cat_repository.dart     # In-memory mock store (seed profiles, likes, matches)
│   └── cat_chat_bot.dart       # Automated feline roleplay response engine
├── state/                      # Lean reactive state management
│   └── cat_tinder_state.dart   # ChangeNotifier coordinating deck, matches, and chats
├── screens/                    # UI screens
│   ├── home_shell.dart         # Bottom navigation (Deck, Chats, Profile)
│   ├── swipe_deck_screen.dart  # Draggable swipe card stack & action controls
│   ├── matches_chats_screen.dart # Matches carousel + active chats list
│   ├── chat_room_screen.dart   # 1-on-1 chat with quick-cat reaction chips
│   └── profile_screen.dart     # User cat profile viewer
└── widgets/                    # Reusable UI components
    ├── cat_card.dart           # Single cat card with details overlay
    ├── match_dialog.dart       # "It's a Match! Paws Aligned 🐾" modal
    └── chat_bubble.dart        # Message bubble styling
```

---

## Git & Version Control Protocol

1. **Repository**: Main repository initialized in the project directory with standard Flutter `.gitignore`.
2. **Commit Policy**: Every phase ends with a atomic git commit following conventional commits:
   - `chore: ...` for scaffolding and tooling
   - `feat: ...` for functional implementations
   - `test: ...` for test suites
3. **Hard Stop Gate**: No phase begins until the previous phase's automated tests and static analysis pass completely.

---

## Phase-by-Phase Plan

### Phase 1: Project Scaffolding & Tooling Setup
- **Goal**: Establish a clean Flutter project structure configured for Android Studio emulation and Git version control.
- **Tasks**:
  1. Verify local Flutter and Android toolchain (`flutter doctor`).
  2. Scaffold Flutter project with Android platform support.
  3. Configure `.gitignore` (ignoring `.dart_tool`, `build/`, `.idea/`, etc.).
  4. Set up base theme (CatTinder color palette: warm coral, pastel salmon, paw accents).
  5. Initialize Git and make the initial baseline commit.
- **Testing & Verification**:
  - Run `flutter analyze` to ensure zero static analysis warnings.
  - Run `flutter test` on default smoke test.
- **Commit**: `chore: scaffold flutter project structure and git repository`
- **🛑 HARD STOP**: Verify Flutter builds cleanly and tests pass before proceeding to data layer.

---

### Phase 2: Domain Models, Mock Repository & Cat Engine
- **Goal**: Implement all core data models, the in-memory mock repository, and the feline chat personality engine.
- **Tasks**:
  1. Create `CatProfile` (id, name, age, breed, bio, image assets/URLs, personality tags).
  2. Create `Match` and `ChatMessage` models.
  3. Build `CatRepository` seeded with 10+ diverse cat personas (e.g., *"Mochi, 2, Laser Pointer Maestro"*, *"Barnaby, 5, Grumpy Napper"*).
  4. Implement `CatChatBot` personality engine: generates contextual cat responses (e.g., *"Meow! Let's share some catnip"*, *"I knocked a pen off the table thinking of you"*, *"Purrrr"*) with realistic typing delays.
  5. Implement `CatTinderState` (ChangeNotifier) to manage swipe actions, matches, and chat feeds.
- **Testing & Verification**:
  - Create `test/unit/cat_repository_test.dart`:
    - Test profile fetching and swipe dequeuing.
    - Test match triggering upon swipe-right.
    - Test message sending and automated bot response generation.
- **Commit**: `feat: implement cat models, mock repository, and feline chat bot engine`
- **🛑 HARD STOP**: Run `flutter test test/unit/` — all unit tests must pass 100%.

---

### Phase 3: The Swipe Deck UI & Match Celebration Flow
- **Goal**: Implement the core Tinder swipe loop with fluid card interactions and match dialogs.
- **Tasks**:
  1. Build `CatCard` displaying high-quality cat imagery, gradient overlays, name, age, breed, distance tag, and personality pills.
  2. Build `SwipeDeckScreen` supporting:
     - Drag/swipe gesture detection (swipe right = like, swipe left = pass).
     - Tap-based bottom action buttons (❌ Pass, 💚 Like, 🔄 Rewind/Reset).
     - Empty deck state with a "Find More Cats" reload action.
  3. Build `MatchDialog` celebration overlay:
     - Shows matched cats side-by-side with paw celebration graphics.
     - "Send a Meow (Chat)" direct link and "Keep Swiping" dismiss button.
- **Testing & Verification**:
  - Create `test/widget/swipe_deck_test.dart`:
    - Test card rendering with profile information.
    - Test button tap triggers swipe action.
    - Test match dialog opens on mutual like.
- **Commit**: `feat: implement swipe card deck, swipe physics, and match celebration modal`
- **🛑 HARD STOP**: Run `flutter test test/widget/swipe_deck_test.dart` and verify UI stability.

---

### Phase 4: Matches Tray, Chat List & 1-on-1 Cat Chat Room
- **Goal**: Enable full messaging flow between matched cats with interactive bot replies.
- **Tasks**:
  1. Build `MatchesChatsScreen`:
     - Top horizontal carousel of matched cat avatars.
     - Vertical list of active conversations with last message snippet, timestamp, and unread badge.
  2. Build `ChatRoomScreen`:
     - Header with cat photo, name, online status (*"Chasing a laser"*, *"Sleeping"*).
     - Message stream with distinct bubbles for sent vs received messages.
     - Text field with instant send.
     - **Cat Quick-Reaction Bar**: One-tap cat speech chips (*"🐾 Meow"*, *"😻 Purr"*, *"😾 Hiss"*, *"🐟 Tuna now"*).
     - Trigger automated simulated cat response upon user message with realistic delay.
- **Testing & Verification**:
  - Create `test/widget/chat_flow_test.dart`:
    - Test rendering matches tray and conversation list.
    - Test entering chat room, sending message, and verifying message bubble appears.
    - Test quick reaction chip sends message immediately.
- **Commit**: `feat: implement matches list, conversation list, and interactive cat chat room`
- **🛑 HARD STOP**: Run `flutter test test/widget/chat_flow_test.dart` — ensure chat interactions and streams behave correctly.

---

### Phase 5: App Shell, Cat Profile Screen & Android Studio Polish
- **Goal**: Assemble navigation shell, user profile screen, and ensure ready-to-simulate Android build.
- **Tasks**:
  1. Build `HomeShell` with BottomNavigationBar connecting Deck, Chats, and Profile.
  2. Build `ProfileScreen` showing current user cat profile (photo, bio, stats like "Likes received", "Paws matched").
  3. Verify Android configuration:
     - `android/app/build.gradle` (SDK versions, namespace `com.cattinder.app`).
     - App icon, launcher label ("CatTinder").
  4. Final polish: smooth transitions, responsive padding for different emulator aspect ratios.
- **Testing & Verification**:
  - Full automated test suite run: `flutter test`.
  - Static code analysis: `flutter analyze` (must be 0 issues).
  - Android build check: `flutter build apk --debug` (or bundle check).
- **Commit**: `feat: finalize app shell, user profile view, and android emulator configuration`
- **🛑 HARD STOP**: Complete test suite green, zero lint warnings, verified Android APK build.
