import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/screens/match_history_screen.dart';
import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/widgets/game_board_widget.dart';
import 'package:cse464_p002_tictactoe/widgets/game_controls_widget.dart';
import 'package:cse464_p002_tictactoe/widgets/player_header_widget.dart';
import 'package:cse464_p002_tictactoe/widgets/scoreboard_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void _confirmResetScoreboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Scoreboard?'),
        content: const Text('This will reset the current session scores to 0.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<GameProvider>().resetScoreboard();
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.score_outlined),
            tooltip: 'Reset Scoreboard',
            onPressed: () => _confirmResetScoreboard(context),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Match History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MatchHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: const [
              PlayerHeaderWidget(),
              SizedBox(height: 14),
              ScoreboardWidget(),
              SizedBox(height: 20),
              GameBoardWidget(),
              SizedBox(height: 20),
              GameControlsWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
