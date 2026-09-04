# 🐾 CatTinder — AI Model Test-Drive & Benchmark

A playground and benchmark repository designed to **test-drive, evaluate, and compare AI coding models** by challenging them to build a full-fledged **CatTinder** mobile application (a Tinder clone for cats!) based on a project specification.

---

## 🎯 Purpose

When evaluating new LLMs, code assistants, and agentic systems, synthetic coding puzzles often fail to capture real-world developer workflows. This repository serves as a standardized testbed:

1. **Realistic Scope**: Building a complete Flutter mobile app featuring swipe physics, state management, in-memory repositories, conversational cat bot engines, and polished UI.
2. **Standardized Spec**: Each model is given the same specification and expected to architect, scaffold, implement, test, and verify the application.
3. **Direct Comparison**: Compare how different AI models approach architecture decisions, code simplicity vs. over-engineering, test coverage, and tool utilization.

---

## 📋 The CatTinder Spec Overview

Each model is tasked with implementing the CatTinder MVP with the following core modules:

- **🐾 Swipe Deck & Physics**: Draggable cards supporting gesture swipes (swipe right to like, left to pass), rewind actions, and smooth card deck animations.
- **🎉 Matchmaking & Celebration**: Instant "It's a Match! Paws Aligned 🐾" modal dialogs triggered upon mutual likes.
- **💬 Feline Chat Engine & Room**: 1-on-1 chat rooms featuring simulated feline roleplay bot responses, realistic typing delays, and quick-reaction chips (*"🐾 Meow"*, *"😻 Purr"*, *"😾 Hiss"*, *"🐟 Tuna now"*).
- **🐱 Cat Profiles & Discovery**: Rich profile cards showcasing cat photos, bios, personality tags, distance, and stats.
- **🏗️ Architecture & Tests**: Scalable architecture, comprehensive unit & widget tests, and zero static analysis warnings.

---

## 📂 Repository Structure

Each tested AI model receives its own dedicated directory containing its complete implementation, implementation plans, and agent logs:

```
CatTinder/
├── Gemini3.8/          # Implementation by Gemini 3.8
├── MuseSpark/          # Implementation workspace for MuseSpark
└── README.md           # Benchmark overview and instructions
```

---

## 🚀 How to Test-Drive a New AI Model

To benchmark a new AI model or coding assistant:

1. **Create a Model Directory**:
   ```bash
   mkdir <Model-Name>
   cd <Model-Name>
   ```

2. **Supply the Spec & Constraints**:
   - Provide the model with the CatTinder feature requirements and architectural expectations (or reference an existing plan like `Gemini3.8/plan.md`).
   - Instruct the model to follow atomic phases (scaffolding → data models → deck UI → chat system → polish) with verification gates at each step.

3. **Run & Verify**:
   - Validate static analysis:
     ```bash
     flutter analyze
     ```
   - Run the automated test suite:
     ```bash
     flutter test
     ```
   - Test-drive on an emulator or device:
     ```bash
     flutter run
     ```

---

## 📊 Evaluation Criteria

Models are scored and compared across several dimensions:

| Dimension | What We Look For |
| :--- | :--- |
| **Spec Adherence** | Did the model deliver all required features without hallucinating or skipping modules? |
| **Architecture & Simplicity** | Clean code without premature abstractions or unnecessary boilerplate (YAGNI principle). |
| **Test Quality** | Comprehensive unit and widget tests that actually verify behavior rather than trivial asserts. |
| **UI/UX Polish** | Smooth animations, responsive layouts, intuitive touch gestures, and themed visuals. |
| **Autonomy & Tooling** | How effectively the agent executes build verification, handles edge cases, and self-corrects. |

---

## 🏆 Model Comparison Tracker

| Model | Status | Test Suite | Lint Warnings | Highlights & Notes |
| :--- | :---: | :---: | :---: | :--- |
| **Gemini 3.8** | ✅ Complete | Passing | 0 | Phased plan, full unit & widget tests, feline bot engine |
| **MuseSpark** | ⏳ In Progress | — | — | Work in progress |

