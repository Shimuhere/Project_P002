import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final history = context.read<MatchHistoryProvider>();

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final symbol = game.board[index];
            final isWinningCell = game.winningLine.contains(index);

            return _BoardCell(
              index: index,
              symbol: symbol,
              isWinningCell: isWinningCell,
              isGameOver: game.isGameOver,
              onTap: () {
                game.makeMove(index, historyProvider: history);
              },
            );
          },
        ),
      ),
    );
  }
}

class _BoardCell extends StatelessWidget {
  final int index;
  final String symbol;
  final bool isWinningCell;
  final bool isGameOver;
  final VoidCallback onTap;

  const _BoardCell({
    required this.index,
    required this.symbol,
    required this.isWinningCell,
    required this.isGameOver,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isX = symbol == symbolX;

    Color cellBg = const Color(0xFFF8FAFC);
    Color borderColor = const Color(0xFFE2E8F0);

    if (isWinningCell) {
      cellBg = const Color(0xFFECFDF5); // light green
      borderColor = const Color(0xFF10B981);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (symbol.isEmpty && !isGameOver) ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        splashColor: isX ? colorPlayerX.withValues(alpha: 0.1) : colorPlayerO.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: cellBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isWinningCell ? borderColor : const Color(0xFFE2E8F0),
              width: isWinningCell ? 2.5 : 1.2,
            ),
            boxShadow: isWinningCell
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
                child: child,
              ),
              child: symbol.isEmpty
                  ? const SizedBox.shrink()
                  : Text(
                      symbol,
                      key: ValueKey(symbol + index.toString()),
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: isWinningCell
                            ? const Color(0xFF059669)
                            : (isX ? colorPlayerX : colorPlayerO),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
