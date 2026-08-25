import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/models/match_model.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';
import 'package:cse464_p002_tictactoe/widgets/mini_board_widget.dart';

class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Match History?'),
        content: const Text('All saved match records will be permanently deleted from Firestore.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<MatchHistoryProvider>().clearAllMatches();
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMatch(BuildContext context, MatchModel match) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Match?'),
        content: Text('Delete match between ${match.player1} and ${match.player2}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<MatchHistoryProvider>().deleteMatch(match.id);
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<MatchHistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match History'),
        actions: [
          if (history.matches.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear All History',
              onPressed: () => _confirmClearAll(context),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (history.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (history.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Color(0xFFEF4444), size: 48),
                    const SizedBox(height: 12),
                    Text(
                      history.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (history.matches.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('🎮', style: TextStyle(fontSize: 38)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Matches Saved Yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Play a game of Tic Tac Toe on the board to record your first match.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B), height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: history.matches.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final match = history.matches[index];
              return _MatchCard(
                match: match,
                onDelete: () => _confirmDeleteMatch(context, match),
              );
            },
          );
        },
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onDelete;

  const _MatchCard({
    required this.match,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isXWinner = match.winner == symbolX;
    final isOWinner = match.winner == symbolO;

    Color badgeColor = colorTie;
    String badgeText = '🤝 Tie';
    if (isXWinner) {
      badgeColor = colorPlayerX;
      badgeText = '👑 ${match.player1} (X) Won';
    } else if (isOWinner) {
      badgeColor = colorPlayerO;
      badgeText = '👑 ${match.player2} (O) Won';
    }

    final formattedDate =
        DateFormat('MMM d, yyyy • h:mm a').format(match.createdAt);

    return Dismissible(
      key: Key(match.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        onDelete();
        return false; // Handled by dialog
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever_rounded, color: Colors.white, size: 28),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Mini Board snapshot
              MiniBoardWidget(board: match.board, size: 54),
              const SizedBox(width: 14),
              // Match info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${match.player1} (X)  vs  ${match.player2} (O)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 13, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete Action Button
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFEF4444), size: 22),
                tooltip: 'Delete match',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
