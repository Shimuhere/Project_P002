import 'package:flutter/material.dart';

import 'package:cse464_p002_tictactoe/models/match_model.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class GameProvider with ChangeNotifier {
  String _player1Name = 'Player 1';
  String _player2Name = 'Player 2';

  List<String> _board = List.filled(9, symbolEmpty);
  String _currentSymbol = symbolX;
  String _startingSymbol = symbolX;

  bool _isGameOver = false;
  String? _winner; // 'X', 'O', 'Tie', or null
  List<int> _winningLine = [];

  int _xWins = 0;
  int _oWins = 0;
  int _ties = 0;

  bool _isMatchSaved = false;

  // Getters
  String get player1Name => _player1Name;
  String get player2Name => _player2Name;
  List<String> get board => List.unmodifiable(_board);
  String get currentSymbol => _currentSymbol;
  String get startingSymbol => _startingSymbol;
  bool get isGameOver => _isGameOver;
  String? get winner => _winner;
  List<int> get winningLine => List.unmodifiable(_winningLine);
  int get xWins => _xWins;
  int get oWins => _oWins;
  int get ties => _ties;

  String get currentPlayerName =>
      (_currentSymbol == symbolX) ? _player1Name : _player2Name;

  String get startingPlayerName =>
      (_startingSymbol == symbolX) ? _player1Name : _player2Name;

  String get winnerPlayerName {
    if (_winner == symbolX) return _player1Name;
    if (_winner == symbolO) return _player2Name;
    return 'Tie';
  }

  void updatePlayerNames(String p1, String p2) {
    final trimmed1 = p1.trim();
    final trimmed2 = p2.trim();
    _player1Name = trimmed1.isNotEmpty ? trimmed1 : 'Player 1';
    _player2Name = trimmed2.isNotEmpty ? trimmed2 : 'Player 2';
    notifyListeners();
  }

  Future<void> makeMove(int index, {MatchHistoryProvider? historyProvider}) async {
    if (index < 0 || index >= 9) return;
    if (_board[index].isNotEmpty || _isGameOver) return;

    _board[index] = _currentSymbol;

    // Check for Win
    final winningCombo = _checkWinningCombo();
    if (winningCombo != null) {
      _isGameOver = true;
      _winner = _board[winningCombo[0]];
      _winningLine = winningCombo;

      if (_winner == symbolX) {
        _xWins++;
      } else if (_winner == symbolO) {
        _oWins++;
      }

      notifyListeners();
      await _persistMatchIfFinished(historyProvider);
      return;
    }

    // Check for Tie
    if (_board.every((cell) => cell.isNotEmpty)) {
      _isGameOver = true;
      _winner = resultTie;
      _winningLine = [];
      _ties++;

      notifyListeners();
      await _persistMatchIfFinished(historyProvider);
      return;
    }

    // Next turn
    _currentSymbol = (_currentSymbol == symbolX) ? symbolO : symbolX;
    notifyListeners();
  }

  List<int>? _checkWinningCombo() {
    for (final pattern in winningPatterns) {
      final a = pattern[0];
      final b = pattern[1];
      final c = pattern[2];

      if (_board[a].isNotEmpty &&
          _board[a] == _board[b] &&
          _board[b] == _board[c]) {
        return pattern;
      }
    }
    return null;
  }

  Future<void> _persistMatchIfFinished(
      MatchHistoryProvider? historyProvider) async {
    if (!_isGameOver || _isMatchSaved || historyProvider == null) return;

    _isMatchSaved = true;

    final match = MatchModel(
      id: '',
      player1: _player1Name,
      player2: _player2Name,
      winner: _winner ?? resultTie,
      board: List.from(_board),
      createdAt: DateTime.now(),
    );

    await historyProvider.saveMatch(match);
  }

  void resetBoard() {
    _board = List.filled(9, symbolEmpty);
    _isGameOver = false;
    _winner = null;
    _winningLine = [];
    _currentSymbol = _startingSymbol;
    _isMatchSaved = false;
    notifyListeners();
  }

  void switchStartingPlayer() {
    _startingSymbol = (_startingSymbol == symbolX) ? symbolO : symbolX;
    resetBoard();
  }

  void resetScoreboard() {
    _xWins = 0;
    _oWins = 0;
    _ties = 0;
    notifyListeners();
  }
}
