# 🎓 Comprehensive Viva Preparation & Code Explanation Guide
## Course: CSE 464 / CSC 464 – Summer 2026 Final Project
### Project: **P002 — Tic Tac Toe (Single Device Edition)**
### Student / Author: **Sumaiya Islam**

---

## 📌 Table of Contents
1. [Project Overview & Core Requirements](#1-project-overview--core-requirements)
2. [High-Level Architecture & Tech Stack](#2-high-level-architecture--tech-stack)
3. [Architecture & Data Flow Diagram](#3-architecture--data-flow-diagram)
4. [Firestore Database Schema](#4-firestore-database-schema)
5. [Complete File-by-File Deep Dive](#5-complete-file-by-file-deep-dive)
6. [Key Technical Algorithms & Viva Explanations](#6-key-technical-algorithms--viva-explanations)
7. [Top 25 Viva Questions & Bulletproof Answers](#7-top-25-viva-questions--bulletproof-answers)
8. [Live Demonstration Script (Step-by-Step)](#8-live-demonstration-script-step-by-step)

---

## 1. Project Overview & Core Requirements

The **Tic Tac Toe (Single Device Edition)** is a cross-platform Flutter application that enables two players to compete in local matches on a single device. Match results, end-game board snapshots, and timestamps are automatically synchronized in real-time with Google Cloud Firestore.

### Core Requirements Met:
1. **Player Customization**:
   - Custom player names for Player 1 (X) and Player 2 (O) with real-time in-game updates.
2. **Interactive 3×3 Grid Board**:
   - Responsive grid cells with animated entry transitions.
   - Intelligent input gating (prevents overwriting occupied cells or playing after game over).
   - Real-time winning line highlight with emerald glow.
3. **Turn Tracking & Game Logic**:
   - Active turn indicators highlighting the current player.
   - 8-combination win detection (3 horizontal, 3 vertical, 2 diagonal).
   - Draw/Tie detection when all 9 cells are filled.
4. **Session Scoreboard**:
   - Live tracking of X Wins, O Wins, and Ties during the active session.
   - Quick reset control with confirmation.
5. **Game Controls**:
   - New Round / Reset Board.
   - Switch Starting Player (toggle whether X or O goes first).
   - Name Editor modal dialog.
6. **Real-Time Match History Persistence**:
   - Cloud Firestore integration (`/matches` collection).
   - Visual mini 3×3 end-game board preview in the match history list.
   - Deletion of individual records and clear-all functionality.

---

## 2. High-Level Architecture & Tech Stack

The application strictly adheres to the **MVVM (Model-View-ViewModel)** architectural pattern implemented via Flutter's **Provider** package:

- **Model**: `MatchModel` representing match documents with JSON serialization.
- **View**: Presentation layer consisting of declarative Flutter Widgets (`screens/` and `widgets/`) that observe state changes.
- **ViewModel / State Management**:
  - `GameProvider`: Encapsulates turn switching, board mutation, winning checks, and scoreboard state.
  - `MatchHistoryProvider`: Manages Firestore streams, document insertions, and deletions.

### Tech Stack & Dependencies:
| Package | Version | Purpose |
| :--- | :--- | :--- |
| `flutter` | SDK | Cross-platform UI toolkit |
| `provider` | `^6.1.5+1` | Reactive state management & dependency injection |
| `firebase_core` | `^4.14.0` | Firebase app initialization |
| `cloud_firestore` | `^6.9.0` | NoSQL Cloud Database with real-time stream sync |
| `intl` | `^0.20.3` | Date/time parsing and human-readable formatting |
| `cupertino_icons` | `^1.0.8` | iOS style iconography |

---

## 3. Architecture & Data Flow Diagram

```mermaid
flowchart TD
    subgraph UI_Layer["UI Layer (View)"]
        GS[GameScreen]
        MHS[MatchHistoryScreen]
        GBW[GameBoardWidget]
        PHW[PlayerHeaderWidget]
        SBW[ScoreboardWidget]
        GCW[GameControlsWidget]
        MBW[MiniBoardWidget]
    end

    subgraph State_Layer["State Management Layer (ViewModel)"]
        GP["GameProvider (ChangeNotifier)"]
        MHP["MatchHistoryProvider (ChangeNotifier)"]
    end

    subgraph Backend_Layer["Backend Service (Model)"]
        FS[("Cloud Firestore (/matches)")]
    end

    GS --> PHW
    GS --> SBW
    GS --> GBW
    GS --> GCW
    MHS --> MBW

    GBW -->|Taps cell -> makeMove()| GP
    GCW -->|resetBoard() / switchStartingPlayer()| GP
    GP -->|Auto-persists on Game Over| MHP
    MHP <-->|Stream snapshots & writes| FS
    MHS -->|Observes history list| MHP
```

---

## 4. Firestore Database Schema

Collection Path: `/matches/{matchId}`

```json
{
  "player1": "Sumaiya",
  "player2": "Guest",
  "winner": "X",
  "board": ["X", "O", "X", "O", "X", "O", "X", "", ""],
  "createdAt": "2026-08-26T00:45:00.000Z"
}
```

- **`player1`**: String — Name of Player 1 (plays with 'X').
- **`player2`**: String — Name of Player 2 (plays with 'O').
- **`winner`**: String — `'X'`, `'O'`, or `'Tie'`.
- **`board`**: Array of String (length 9) — Final cell state snapshot (`'X'`, `'O'`, or `''`).
- **`createdAt`**: Timestamp — Precise timestamp of match completion.

---

## 5. Complete File-by-File Deep Dive

### 5.1 App Entry & Bootstrap (`lib/main.dart`)
Initializes Firebase services and injects `GameProvider` and `MatchHistoryProvider` into the widget tree using `MultiProvider`.

### 5.2 Data Models (`lib/models/match_model.dart`)
Encapsulates match data. Provides `toJson()` and `fromJson()` with resilient board length checks and `Timestamp` converters.

### 5.3 State Management (`lib/state_management/`)
- `game_provider.dart`: Contains the board state (length 9 array), active turn tracking, score counters, win detection algorithm, and player name state.
- `match_history_provider.dart`: Subscribes to Firestore real-time snapshots ordered by `createdAt DESC` and provides CRUD helper methods (`saveMatch`, `deleteMatch`, `clearAllMatches`).

### 5.4 Screens & Presentation (`lib/screens/`)
- `game_screen.dart`: Main dashboard holding the player headers, scoreboard, interactive board, and game controls.
- `match_history_screen.dart`: Shows all past matches loaded live from Firestore with mini board snapshots and deletion controls.

### 5.5 Custom Widgets (`lib/widgets/`)
- `game_board_widget.dart`: 3×3 interactive grid with scale animations and winning cell highlighting.
- `player_header_widget.dart`: Displays Player 1 vs Player 2 cards with active turn indicators.
- `scoreboard_widget.dart`: 3-card scoreboard for X Wins, Ties, and O Wins.
- `game_controls_widget.dart`: Next round button, starter toggle, name change button, and winner celebration banner.
- `mini_board_widget.dart`: Renders a 54×54px mini visual preview of finished boards in history cards.
- `player_names_dialog.dart`: Input form dialog to update player names.

### 5.6 Utility & Constants (`lib/utility/`)
- `constant.dart`: Symbols (`'X'`, `'O'`, `''`), color palette, and the 8 winning coordinate tuples.
- `app_theme.dart`: Material 3 theme configuration.

---

## 6. Key Technical Algorithms & Viva Explanations

### 6.1 8-Pattern Win & Tie Detection Algorithm
Winning is determined by comparing cell triplets against predefined 2D coordinate lists:
```dart
const List<List<int>> winningPatterns = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
  [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
  [0, 4, 8], [2, 4, 6],             // Diagonals
];

List<int>? checkWinningCombo() {
  for (final pattern in winningPatterns) {
    final a = pattern[0], b = pattern[1], c = pattern[2];
    if (board[a].isNotEmpty && board[a] == board[b] && board[b] == board[c]) {
      return pattern; // Returns winning cell indices
    }
  }
  return null;
}
```

---

## 7. Top 25 Viva Questions & Bulletproof Answers

1. **Q: What is the main objective of Project P002?**
   *A:* To provide a responsive, single-device 2-player Tic Tac Toe game in Flutter with local scoreboard tracking and cloud persistence using Firebase Firestore.

2. **Q: How does the app detect a winning state?**
   *A:* It checks 8 predefined 3-cell coordinate patterns (3 rows, 3 columns, 2 diagonals). If all 3 cells share the same non-empty symbol, that player is declared the winner.

3. **Q: How is a tie/draw detected?**
   *A:* When no winning combination is found and every cell in the 9-element list is non-empty (`board.every((cell) => cell.isNotEmpty)`).

4. **Q: Why use Provider for state management?**
   *A:* Provider separates business logic and UI cleanly using `ChangeNotifier` and `Consumer`/`context.watch()`, avoiding unnecessary widget rebuilds.

5. **Q: How is match history saved to Firebase?**
   *A:* When `isGameOver` becomes true, `GameProvider` constructs a `MatchModel` containing player names, winner, board snapshot, and timestamp, then calls `MatchHistoryProvider.saveMatch()`.

6. **Q: How is match history displayed in real time?**
   *A:* `MatchHistoryProvider` listens to `_matchesCollection.orderBy('createdAt', descending: true).snapshots()`, automatically updating the UI whenever records change.

7. **Q: How does switching the starting player work?**
   *A:* The `switchStartingPlayer()` method toggles `startingSymbol` between 'X' and 'O', resets the board, and sets `currentSymbol` to the new starter.

8. **Q: How are cells prevented from being overridden?**
   *A:* In `makeMove(int index)`, the method checks `if (_board[index].isNotEmpty || _isGameOver) return;` before making any mutations.

---

## 8. Live Demonstration Script (Step-by-Step)

1. **Step 1: Launch the App**
   - Run `flutter run` in `Project P002`.
   - Point out the clean UI, active turn indicator on Player 1, and 0-0-0 scoreboard.

2. **Step 2: Edit Player Names**
   - Tap **Names**, enter custom names (e.g. "Sumaiya" and "Alex"), tap **Save Names**.
   - Show how player cards and scoreboard titles instantly update.

3. **Step 3: Play a Winning Game**
   - Play moves to achieve 3-in-a-row for X.
   - Point out:
     - Winning cells highlight in green.
     - Winner banner appears at the bottom.
     - Scoreboard X Wins increments to 1.

4. **Step 4: Demonstrate Match History & Cloud Sync**
   - Tap the **History icon** in the app bar.
   - Point out the newly saved match card displaying:
     - Winner status badge
     - Player names
     - Date & time
     - **Mini 3×3 visual board snapshot** mirroring the game board.

5. **Step 5: Test Game Controls**
   - Tap **Starter: X** to toggle to **Starter: O**.
   - Show that Player 2 (O) now has the active first turn.
   - Play a match to a Draw/Tie and show the updated tie counter and tie history record.
