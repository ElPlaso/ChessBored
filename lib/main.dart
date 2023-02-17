import 'package:chess_bored/app/bloc/game_history_bloc.dart';
import 'package:chess_bored/app/data/game_history.dart';
import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_clock_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/data/chess_clock_model.dart';
import 'package:chess_bored/game_history/game_history_page.dart';
import 'package:flutter/material.dart';
import 'package:chess_bored/chess_home/chess_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

void main() {
  ChessGameMaker.register();
  ChessClockMaker.register();
  GameHistoryMaker.register();
  runApp(const ChessApp());
}

class ChessApp extends StatefulWidget {
  const ChessApp({super.key});

  @override
  State<StatefulWidget> createState() => _ChessAppState();
}

class _ChessAppState extends State<ChessApp> {
  int _currentPageIndex = 0;

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
          create: (BuildContext context) =>
              ChessGameBloc()..add(GameLoadedEvent()),
        ),
        BlocProvider<ChessClockBloc>(
          create: (BuildContext context) =>
              ChessClockBloc()..add(ClockSettingsLoadedEvent()),
        ),
        BlocProvider<GameHistoryBloc>(
          create: (BuildContext context) =>
              GameHistoryBloc()..add(GameHistoryLoadedEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChessBored',
        theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
        home: BlocBuilder<GameHistoryBloc, GameHistoryState>(
          builder: (context, state) {
            return Scaffold(
              body: <Widget>[
                const ChessHomePage(title: 'ChessBored.'),
                const GameHistoryPage(),
              ][_currentPageIndex],
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                    if (index == 1) {
                      context
                          .read<GameHistoryBloc>()
                          .add(GameHistoryLoadedEvent());
                    }
                  });
                },
                selectedIndex: _currentPageIndex,
                destinations: <Widget>[
                  const NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Play',
                  ),
                  NavigationDestination(
                    icon: state is GameSavedState
                        ? const badges.Badge(
                            badgeContent: null,
                            child: Icon(Icons.menu_book),
                          )
                        : const Icon(Icons.menu_book),
                    label: 'History',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
