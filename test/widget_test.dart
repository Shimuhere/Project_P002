import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/screens/game_screen.dart';
import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';

void main() {
  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => MatchHistoryProvider()),
      ],
      child: const MaterialApp(
        home: GameScreen(),
      ),
    );
  }

  testWidgets('Tic Tac Toe initial screen renders correctly with Reset buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Verify Title & Player Names
    expect(find.text('Tic Tac Toe'), findsOneWidget);
    expect(find.text('Player 1'), findsWidgets);
    expect(find.text('Player 2'), findsWidgets);

    // Verify Reset Board and Reset Scores buttons exist
    expect(find.text('Reset Board'), findsOneWidget);
    expect(find.text('Reset Scores'), findsOneWidget);

    // Verify AppBar Reset Game icon exists
    expect(find.byTooltip('Reset Game'), findsOneWidget);
    expect(find.byTooltip('Reset Scoreboard'), findsOneWidget);
  });

  testWidgets('Tapping Reset Board button resets the board',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createTestWidget());

    // Tap cell 0 to place X
    final firstCell = find.byType(InkWell).first;
    await tester.tap(firstCell);
    await tester.pumpAndSettle();

    expect(find.text('X'), findsWidgets);

    // Ensure Reset Board button is visible and tap it
    final resetBoardButton = find.text('Reset Board');
    await tester.ensureVisible(resetBoardButton);
    await tester.tap(resetBoardButton);
    await tester.pumpAndSettle();

    // Verify snackbar is shown
    expect(find.text('Board reset! Ready for a new round.'), findsOneWidget);
  });

  testWidgets('Tapping AppBar Reset Game icon opens reset dialog with options',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap AppBar Reset Game button
    await tester.tap(find.byTooltip('Reset Game'));
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Choose how you would like to reset the game:\n\n'
        '• Reset Board: Clears the current 3×3 grid to start a new round (keeps session scores).\n'
        '• Reset All: Clears the board and resets all session scores to 0.'), findsOneWidget);

    // Tap "Reset All" button in dialog
    await tester.tap(find.widgetWithText(FilledButton, 'Reset All'));
    await tester.pumpAndSettle();

    // Dialog closed and SnackBar appears
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Game and scores reset to 0!'), findsOneWidget);
  });
}
