import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:cse464_p002_tictactoe/firebase_options.dart';
import 'package:cse464_p002_tictactoe/screens/game_screen.dart';
import 'package:cse464_p002_tictactoe/state_management/game_provider.dart';
import 'package:cse464_p002_tictactoe/state_management/match_history_provider.dart';
import 'package:cse464_p002_tictactoe/utility/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatchHistoryProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Tic Tac Toe - Single Device Edition',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const GameScreen(),
      ),
    );
  }
}
