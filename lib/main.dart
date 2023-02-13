import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_clock_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/data/chess_clock_model.dart';
import 'package:flutter/material.dart';
import 'package:chess_bored/chess_home/chess_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  ChessGameMaker.register();
  ChessClockMaker.register();
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  // The root of this application :)
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BoardViewBloc>(
          create: (BuildContext context) =>
              BoardViewBloc()..add(BoardThemeLoadedEvent()),
        ),
        BlocProvider<ChessGameBloc>(
          create: (BuildContext context) => ChessGameBloc(),
        ),
        BlocProvider<ChessClockBloc>(
          create: (BuildContext context) =>
              ChessClockBloc()..add(ClockSettingsLoadedEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChessBored',
        theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
        home: const ChessHomePage(title: 'ChessBored.'),
      ),
    );
  }
}
