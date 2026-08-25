import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String player1;
  final String player2;
  final String winner; // 'X', 'O', or 'Tie'
  final List<String> board; // length 9
  final DateTime createdAt;

  MatchModel({
    required this.id,
    required this.player1,
    required this.player2,
    required this.winner,
    required this.board,
    required this.createdAt,
  });

  factory MatchModel.fromJson(String id, Map<String, dynamic> json) {
    final rawBoard = json['board'];
    List<String> parsedBoard;
    if (rawBoard is List) {
      parsedBoard = rawBoard.map((e) => e?.toString() ?? '').toList();
    } else {
      parsedBoard = List.filled(9, '');
    }

    // Ensure board always has 9 elements
    while (parsedBoard.length < 9) {
      parsedBoard.add('');
    }
    if (parsedBoard.length > 9) {
      parsedBoard = parsedBoard.sublist(0, 9);
    }

    return MatchModel(
      id: id,
      player1: json['player1'] ?? 'Player 1',
      player2: json['player2'] ?? 'Player 2',
      winner: json['winner'] ?? 'Tie',
      board: parsedBoard,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player1': player1,
      'player2': player2,
      'winner': winner,
      'board': board,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  String get winnerDisplayName {
    if (winner == 'X') return ' (X)';
    if (winner == 'O') return ' (O)';
    return 'Tie / Draw';
  }
}
