import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class PlayerNamesDialog extends StatefulWidget {
  const PlayerNamesDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const PlayerNamesDialog(),
    );
  }

  @override
  State<PlayerNamesDialog> createState() => _PlayerNamesDialogState();
}

class _PlayerNamesDialogState extends State<PlayerNamesDialog> {
  late final TextEditingController _p1Controller;
  late final TextEditingController _p2Controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final game = context.read<GameProvider>();
    _p1Controller = TextEditingController(text: game.player1Name);
    _p2Controller = TextEditingController(text: game.player2Name);
  }

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<GameProvider>().updatePlayerNames(
          _p1Controller.text,
          _p2Controller.text,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.edit_note_rounded, color: Color(0xFF6366F1)),
          SizedBox(width: 8),
          Text(
            'Change Player Names',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _p1Controller,
                decoration: InputDecoration(
                  labelText: 'Player 1 (X) Name',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorPlayerX.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'X',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorPlayerX,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter Player 1 name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _p2Controller,
                decoration: InputDecoration(
                  labelText: 'Player 2 (O) Name',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorPlayerO.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'O',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorPlayerO,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter Player 2 name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Save Names'),
        ),
      ],
    );
  }
}
