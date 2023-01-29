import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:flutter/material.dart';
import 'package:chess_bored/chess_home/chess_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  ChessGameMaker.register();
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
          create: (BuildContext context) => BoardViewBloc(),
        ),
        BlocProvider<ChessGameBloc>(
          create: (BuildContext context) => ChessGameBloc(),
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
