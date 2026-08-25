import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class PlayerHeaderWidget extends StatelessWidget {
  const PlayerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    final isXTurn = game.currentSymbol == symbolX && !game.isGameOver;
    final isOTurn = game.currentSymbol == symbolO && !game.isGameOver;

    final isXWinner = game.winner == symbolX;
    final isOWinner = game.winner == symbolO;

    return Row(
      children: [
        // Player 1 (X)
        Expanded(
          child: _PlayerCard(
            name: game.player1Name,
            symbol: symbolX,
            color: colorPlayerX,
            isActive: isXTurn,
            isWinner: isXWinner,
            isStarting: game.startingSymbol == symbolX,
          ),
        ),
        const SizedBox(width: 12),
        // VS Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Player 2 (O)
        Expanded(
          child: _PlayerCard(
            name: game.player2Name,
            symbol: symbolO,
            color: colorPlayerO,
            isActive: isOTurn,
            isWinner: isOWinner,
            isStarting: game.startingSymbol == symbolO,
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final String name;
  final String symbol;
  final Color color;
  final bool isActive;
  final bool isWinner;
  final bool isStarting;

  const _PlayerCard({
    required this.name,
    required this.symbol,
    required this.color,
    required this.isActive,
    required this.isWinner,
    required this.isStarting,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    if (isWinner) {
      borderColor = const Color(0xFF10B981); // Emerald Green
    } else if (isActive) {
      borderColor = color;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isActive || isWinner) ? borderColor : const Color(0xFFE2E8F0),
          width: (isActive || isWinner) ? 2 : 1,
        ),
        boxShadow: [
          if (isActive || isWinner)
            BoxShadow(
              color: borderColor.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  symbol,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (isWinner)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '👑 WINNER',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            )
          else if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'YOUR TURN',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            )
          else if (isStarting)
            const Text(
              'Starts First',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            )
          else
            const Text(
              'Waiting',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
