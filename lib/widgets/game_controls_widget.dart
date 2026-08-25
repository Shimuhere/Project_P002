import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/screens/match_history_screen.dart';
import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';
import 'package:cse464_p002_tictactoe/widgets/player_names_dialog.dart';

class GameControlsWidget extends StatelessWidget {
  const GameControlsWidget({super.key});

  void _confirmResetScoreboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Scoreboard?'),
        content: const Text('This will reset current X Wins, O Wins, and Ties to 0.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<GameProvider>().resetScoreboard();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scoreboard reset to 0!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _onResetBoard(BuildContext context, GameProvider game) {
    game.resetBoard();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Board reset! Ready for a new round.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final history = context.watch<MatchHistoryProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Game Over Banner
        if (game.isGameOver) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: game.winner == resultTie
                    ? [const Color(0xFFF59E0B), const Color(0xFFD97706)]
                    : (game.winner == symbolX
                        ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
                        : [const Color(0xFFEC4899), const Color(0xFFDB2777)]),
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (game.winner == resultTie
                          ? const Color(0xFFF59E0B)
                          : (game.winner == symbolX
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFEC4899)))
                      .withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      game.winner == resultTie ? '🤝' : '🎉',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.winner == resultTie
                              ? 'It is a Draw!'
                              : '${game.winnerPlayerName} Wins!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          game.winner == resultTie
                              ? 'Saved to history'
                              : 'Winner: ${game.winner} (Saved)',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _onResetBoard(context, game),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.replay_rounded, size: 18),
                  label: const Text(
                    'Next Round',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Row 1: Primary Reset & Controls
        Row(
          children: [
            // Reset Board
            Expanded(
              child: _ControlButton(
                icon: Icons.refresh_rounded,
                label: 'Reset Board',
                color: const Color(0xFF6366F1),
                onTap: () => _onResetBoard(context, game),
              ),
            ),
            const SizedBox(width: 10),
            // Reset Scores
            Expanded(
              child: _ControlButton(
                icon: Icons.restart_alt_rounded,
                label: 'Reset Scores',
                color: const Color(0xFFEF4444),
                onTap: () => _confirmResetScoreboard(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 2: Secondary Options (Starter, Names, Match History)
        Row(
          children: [
            // Switch Starting Player
            Expanded(
              child: _ControlButton(
                icon: Icons.swap_horiz_rounded,
                label: 'Starter: ${game.startingSymbol}',
                color: const Color(0xFF0EA5E9),
                onTap: () => game.switchStartingPlayer(),
              ),
            ),
            const SizedBox(width: 8),
            // Change Names
            Expanded(
              child: _ControlButton(
                icon: Icons.edit_note_rounded,
                label: 'Player Names',
                color: const Color(0xFF8B5CF6),
                onTap: () => PlayerNamesDialog.show(context),
              ),
            ),
            const SizedBox(width: 8),
            // Match History
            Expanded(
              child: _ControlButton(
                icon: Icons.history_rounded,
                label: 'History (${history.matches.length})',
                color: const Color(0xFF10B981),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MatchHistoryScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
