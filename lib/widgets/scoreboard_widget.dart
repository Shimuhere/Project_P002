import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Player X Score
          Expanded(
            child: _ScoreItem(
              title: game.player1Name,
              symbol: symbolX,
              count: game.xWins,
              color: colorPlayerX,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          // Ties Score
          Expanded(
            child: _ScoreItem(
              title: 'Ties',
              symbol: '=',
              count: game.ties,
              color: colorTie,
            ),
          ),
          Container(
            height: 36,
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),
          // Player O Score
          Expanded(
            child: _ScoreItem(
              title: game.player2Name,
              symbol: symbolO,
              count: game.oWins,
              color: colorPlayerO,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String title;
  final String symbol;
  final int count;
  final Color color;

  const _ScoreItem({
    required this.title,
    required this.symbol,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}
