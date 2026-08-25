# 🎮 Tic Tac Toe – Single Device Edition (Project P002)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Provider](https://img.shields.io/badge/State_Management-Provider-4CAF50?style=for-the-badge)](https://pub.dev/packages/provider)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS-blue?style=for-the-badge)](https://flutter.dev)

> **Course:** CSE 464 / CSC 464 – Mobile Application Development (Summer 2026 Final Project)  
> **Project ID:** P002  
> **Author:** Sumaiya Islam ([@Shimuhere](https://github.com/Shimuhere))

---

## 📖 Overview & Project Story

**Tic Tac Toe (Single Device Edition)** is a modern, responsive cross-platform mobile application developed with **Flutter**, **Provider**, and **Google Cloud Firestore**. Two players can play rounds of Tic Tac Toe on a single device with customized player names, live session scoreboard tracking, interactive game animations, and real-time cloud match history persistence.

---

## ✨ Key Features

### 🎮 Core Gameplay & Interactive Board
- **3×3 Interactive Grid:** Smooth, scale-animated moves with responsive cell tap handling.
- **Occupied Cell Protection:** Input gating prevents overwriting occupied cells or making moves after game-over.
- **Winning Line Highlight:** Instant emerald-glow highlighting across the 3 winning cells upon victory.
- **Dynamic Turn Tracking:** Live badges and turn indicators displaying whose active turn it is (Player 1 / Player 2).

### 🏆 Win & Tie Detection Algorithm
- **8-Way Win Detection:** Checks rows, columns, and diagonals in constant time ($O(1)$) using coordinate pattern matching.
- **Automatic Tie Detection:** Accurately detects draws when all 9 cells are filled without a winner.
- **Celebration Banner:** Game-over gradient banner displaying winner details and a "Next Round" quick action.

### 📊 Scoreboard & Game Controls
- **Live Scoreboard:** Real-time counters for **Player 1 (X) Wins**, **Ties / Draws**, and **Player 2 (O) Wins**.
- **Reset Board:** Start a fresh round instantly while keeping session scores intact.
- **Reset Scores:** One-tap session score reset with a confirmation modal.
- **Switch Starting Player:** Toggle whether X or O plays first next round.
- **Custom Player Names:** Edit names for Player 1 and Player 2 anytime via an in-app dialog.

### ☁️ Cloud Firestore Match History (`/matches`)
- **Real-Time Stream Sync:** Subscribes to Firestore collection snapshots ordered by `createdAt DESC`.
- **Mini 3×3 Board Snapshots:** Every match history entry features a miniature visual board representing the final state of the game.
- **Swipe-to-Delete:** Dismissible swipe gesture to delete individual match documents from Firestore.
- **Trash Button Action:** One-tap delete icon with a safety dialog.
- **Clear All History:** Wipe all saved records with a single action.

---

## 🏗️ Architecture & Tech Stack

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern:

- **Model:** `MatchModel` with Firestore JSON serialization and date converters.
- **View:** Declarative Flutter UI widgets (`GameBoardWidget`, `PlayerHeaderWidget`, `ScoreboardWidget`, `GameControlsWidget`, `MiniBoardWidget`).
- **ViewModel / State Management:**
  - `GameProvider`: Encapsulates board state, turn switching, win/tie evaluation, player names, and scoreboard lifecycle.
  - `MatchHistoryProvider`: Manages Firestore streams, real-time sync, additions, and deletions.

### Tech Stack:
| Technology | Version | Purpose |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.12.2+` | Cross-platform UI toolkit |
| **Provider** | `^6.1.5+1` | Reactive state management & dependency injection |
| **Cloud Firestore** | `^6.9.0` | NoSQL Cloud database for match persistence |
| **Firebase Core** | `^4.14.0` | Firebase initialization & cross-platform configs |
| **Intl** | `^0.20.3` | Date formatting for match history timestamps |

---

## 📐 Architecture & Data Flow Diagram

```mermaid
flowchart TD
    subgraph UI_Layer["UI Layer (View)"]
        GS["GameScreen"]
        MHS["MatchHistoryScreen"]
        GBW["GameBoardWidget (3x3 Grid)"]
        PHW["PlayerHeaderWidget (Turn Badges)"]
        SBW["ScoreboardWidget (Scores)"]
        GCW["GameControlsWidget (Buttons & Banner)"]
        MBW["MiniBoardWidget (History Snapshot)"]
    end

    subgraph State_Layer["State Management (Provider)"]
        GP["GameProvider (ChangeNotifier)"]
        MHP["MatchHistoryProvider (ChangeNotifier)"]
    end

    subgraph Backend_Layer["Cloud Database"]
        FS[("Cloud Firestore (/matches)")]
    end

    GS --> PHW
    GS --> SBW
    GS --> GBW
    GS --> GCW
    MHS --> MBW

    GBW -->|Tap cell -> makeMove()| GP
    GCW -->|resetBoard() / switchStarter()| GP
    GP -->|Auto-save match on game over| MHP
    MHP <-->|Real-time snapshot streams| FS
    MHS -->|Observes history list| MHP
```

---

## 🗄️ Firestore Database Schema

Collection Path: `/matches/{matchId}`

```json
{
  "player1": "Sumaiya",
  "player2": "Guest",
  "winner": "X",
  "board": [
    "X", "O", "X",
    "O", "X", "O",
    "X", "",  ""
  ],
  "createdAt": "2026-08-26T01:00:00.000Z"
}
```

---

## 📁 Project Structure

```text
Project P002/
├── android/                           # Android native configuration & Gradle scripts
├── ios/                               # iOS native configuration & Runner project
├── lib/
│   ├── firebase_options.dart          # Firebase configuration across all platforms
│   ├── main.dart                      # App entry point & MultiProvider initialization
│   ├── models/
│   │   └── match_model.dart           # Match data model with Firestore serialization
│   ├── screens/
│   │   ├── game_screen.dart           # Primary game dashboard
│   │   └── match_history_screen.dart  # Match history list with swipe-to-delete
│   ├── state_management/
│   │   ├── game_provider.dart         # Core game mechanics & turn state
│   │   └── match_history_provider.dart# Firestore real-time CRUD provider
│   ├── utility/
│   │   ├── app_theme.dart             # Material 3 typography & theme system
│   │   └── constant.dart              # Symbols ('X', 'O'), colors & winning patterns
│   └── widgets/
│       ├── game_board_widget.dart     # 3x3 interactive game grid
│       ├── game_controls_widget.dart  # Reset board, reset score & history actions
│       ├── mini_board_widget.dart     # 3x3 mini snapshot preview in history
│       ├── player_header_widget.dart  # Active player turn indicators
│       ├── player_names_dialog.dart   # Modal dialog for player name customization
│       └── scoreboard_widget.dart     # Live session scoreboard card
├── firestore.rules                    # Security rules deployed to Firestore
├── firestore.indexes.json             # Single-field index configuration
├── pubspec.yaml                       # Dependencies & package metadata
└── VIVA_PREPARATION_GUIDE.md          # Comprehensive Viva Defense Guide & 25 Q&A
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.12.2 or higher)
- [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
- Firebase project configured with Cloud Firestore

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Shimuhere/Project_P002.git
   cd Project_P002
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run Static Analysis:**
   ```bash
   flutter analyze
   ```

4. **Launch the application:**
   ```bash
   # In Chrome Browser:
   flutter run -d chrome

   # On Android Emulator / Device:
   flutter run -d android

   # On iOS Simulator (macOS only):
   flutter run -d ios
   ```

---

## 🎓 Academic Viva Highlights

1. **8-Pattern Win Checking Algorithm:**
   Predefined coordinate tuples represent all 8 possible winning lines:
   ```dart
   const List<List<int>> winningPatterns = [
     [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
     [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
     [0, 4, 8], [2, 4, 6],             // Diagonals
   ];
   ```
2. **Deterministic State Lifecycle:**
   Input mutations are validated, applied to state, evaluated for victory/draw, score-tallied, and automatically persisted to Firestore asynchronously without freezing the UI.
3. **Reactive Firestore Synchronization:**
   Uses `snapshots()` streams for immediate UI updates whenever match records are inserted or deleted.

---

## 📄 License
This project is open-source and created for educational purposes under the **CSE 464 Summer 2026** curriculum.
