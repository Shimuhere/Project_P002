import 'package:flutter_test/flutter_test.dart';
import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

void main() {
  group('GameProvider Unit Tests', () {
    late GameProvider game;

    setUp(() {
      game = GameProvider();
    });

    test('Initial state is clean and ready to play', () {
      expect(game.player1Name, 'Player 1');
      expect(game.player2Name, 'Player 2');
      expect(game.currentSymbol, symbolX);
      expect(game.startingSymbol, symbolX);
      expect(game.isGameOver, false);
      expect(game.winner, isNull);
      expect(game.board.every((cell) => cell.isEmpty), isTrue);
      expect(game.xWins, 0);
      expect(game.oWins, 0);
      expect(game.ties, 0);
    });

    test('makeMove updates board and switches turns', () async {
      await game.makeMove(0);
      expect(game.board[0], symbolX);
      expect(game.currentSymbol, symbolO);

      await game.makeMove(1);
      expect(game.board[1], symbolO);
      expect(game.currentSymbol, symbolX);
    });

    test('resetBoard resets the board and game over state while keeping scores', () async {
      // Simulate moves
      await game.makeMove(0); // X
      await game.makeMove(3); // O
      await game.makeMove(1); // X
      await game.makeMove(4); // O
      await game.makeMove(2); // X wins [0, 1, 2]

      expect(game.isGameOver, isTrue);
      expect(game.winner, symbolX);
      expect(game.xWins, 1);

      // Reset Board
      game.resetBoard();

      expect(game.isGameOver, isFalse);
      expect(game.winner, isNull);
      expect(game.winningLine, isEmpty);
      expect(game.board.every((cell) => cell.isEmpty), isTrue);
      expect(game.currentSymbol, symbolX);
      // Scores should remain intact
      expect(game.xWins, 1);
      expect(game.oWins, 0);
      expect(game.ties, 0);
    });

    test('resetScoreboard clears session scores', () async {
      await game.makeMove(0); // X
      await game.makeMove(3); // O
      await game.makeMove(1); // X
      await game.makeMove(4); // O
      await game.makeMove(2); // X wins

      expect(game.xWins, 1);

      game.resetScoreboard();
      expect(game.xWins, 0);
      expect(game.oWins, 0);
      expect(game.ties, 0);
    });

    test('resetAll performs full reset of board and scores', () async {
      await game.makeMove(0); // X
      await game.makeMove(3); // O
      await game.makeMove(1); // X
      await game.makeMove(4); // O
      await game.makeMove(2); // X wins

      expect(game.xWins, 1);
      expect(game.isGameOver, isTrue);

      game.resetAll();

      expect(game.isGameOver, isFalse);
      expect(game.board.every((cell) => cell.isEmpty), isTrue);
      expect(game.xWins, 0);
      expect(game.oWins, 0);
      expect(game.ties, 0);
    });

    test('resetGame with resetScoreboard=true clears everything', () async {
      await game.makeMove(0); // X
      await game.makeMove(3); // O
      await game.makeMove(1); // X
      await game.makeMove(4); // O
      await game.makeMove(2); // X wins

      game.resetGame(resetScoreboard: true);

      expect(game.isGameOver, isFalse);
      expect(game.board.every((cell) => cell.isEmpty), isTrue);
      expect(game.xWins, 0);
    });
  });
}
