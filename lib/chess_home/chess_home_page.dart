import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/widgets/action_bar.dart';
import 'package:chess_bored/chess_home/widgets/move_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Page for the chess board view and state.
class ChessHomePage extends StatefulWidget {
  const ChessHomePage({super.key, required this.title});

  final String title;

  @override
  State<ChessHomePage> createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  final ScrollController _moveListScrollController = ScrollController();

  /// Scrolls the move list to the end so that the latest move is always visible.
  void _scrollMoveList() {
    _moveListScrollController.animateTo(
      _moveListScrollController.position.maxScrollExtent,
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
          ),
        ),
      ),
      body: BlocBuilder<BoardViewBloc, BoardViewState>(
        builder: (context, state) {
          return BlocListener<ChessGameBloc, ChessGameState>(
            listener: (context, state) {
              if (state is GameOverState) {
                switch (state.gameResult) {
                  case GameResultType.checkmate:
                    // The last move is the checkmating move.
                    // Every black move is even, and every white move is odd.
                    if (_chessGame.moveCount % 2 == 0) {
                      _showGameOverDialog(context, "Black wins by checkmate!");
                    } else {
                      _showGameOverDialog(context, "White wins by checkmate!");
                    }
                    break;
                  case GameResultType.stalemate:
                    _showGameOverDialog(context, "Draw by stalemate");
                    break;
                  case GameResultType.insufficientMaterial:
                    _showGameOverDialog(
                        context, "Draw by insufficient material");
                    break;
                  case GameResultType.threeFoldRepitition:
                    _showGameOverDialog(
                        context, "Draw by three fold repitition");
                    break;
                }
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: MoveList(
                    controller: _chessGame.controller,
                    scrollController: _moveListScrollController,
                  ),
                ),
                const Spacer(),
                ChessBoard(
                  controller: _chessGame.controller,
                  boardColor: state.boardTheme,
                  boardOrientation: state.boardOrientation,
                  onMove: () {
                    _scrollMoveList();
                    _chessGame.moveCount++;
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ActionBar(),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Opens a dialog to inform of the current game over state. E.g. checkmate, stalemate etc.
Future<void> _showGameOverDialog(BuildContext context, String title) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext _) {
      return BlocBuilder<ChessGameBloc, ChessGameState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<ChessGameBloc>().add(GameRestartedEvent());
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        },
      );
    },
  );
}
