import 'package:chess_bored/app/models/finished_game_win_status.dart';
import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_clock_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/widgets/action_bar.dart';
import 'package:chess_bored/chess_home/widgets/move_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:localstorage/localstorage.dart';

/// Page for the chess board view and state.
class ChessHomePage extends StatefulWidget {
  const ChessHomePage({super.key, required this.title});

  final String title;

  @override
  State<ChessHomePage> createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _moveAudioPath = "sounds/move_sound.mp3";

  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  final ScrollController _moveListScrollController = ScrollController();

  final LocalStorage _storage = LocalStorage('unfinished_game.json');

  /// Scrolls the move list to the end so that the latest move is always visible.
  void _scrollMoveList() {
    _moveListScrollController.animateTo(
      _moveListScrollController.position.maxScrollExtent,
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
    );
  }

  /// Controls what happens each time a player moves.
  void _onMove() {
    _audioPlayer.play(AssetSource(_moveAudioPath));
    context.read<ChessClockBloc>().add(PlayerMovedEvent());
    _scrollMoveList();
    _chessGame.moveCount++;
    // Save the game to local storage each time.
    // This is so the game can be continued if the app is closed.
    _storage.setItem('fen_game', _chessGame.controller.getFen());
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
          return BlocBuilder<ChessClockBloc, ChessClockState>(
            builder: (clockContext, clockState) {
              return BlocListener<ChessGameBloc, ChessGameState>(
                listener: (context, state) {
                  if (state is GameOverState) {
                    clockContext.read<ChessClockBloc>().add(
                          ChessClockPausedEvent(),
                        );
                    FinishedGameWinStatus whoWon = FinishedGameWinStatus.draw;

                    if (state.gameResult == GameResultType.checkmate ||
                        state.gameResult == GameResultType.flagged) {
                      // The last move is the winning move.
                      // Every black move is even, and every white move is odd.
                      if (_chessGame.moveCount % 2 == 0) {
                        whoWon = FinishedGameWinStatus.blackVictory;
                      } else {
                        whoWon = FinishedGameWinStatus.whiteVictory;
                      }
                    }
                    _showGameOverDialog(context, whoWon, state.gameResult);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns:
                          state.boardOrientation == PlayerColor.black ? 2 : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: MoveList(
                          controller: _chessGame.controller,
                          scrollController: _moveListScrollController,
                        ),
                      ),
                    ),
                    if (clockState is! ChessClockOffState)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Account for swapped orientation.
                            Row(
                              children: [
                                RotatedBox(
                                  quarterTurns:
                                      clockState is ChessClockRunningState
                                          ? 2
                                          : 0,
                                  child: _buildDurationDisplay(
                                      clockState is ChessClockRunningState
                                          ? state.boardOrientation ==
                                                  PlayerColor.white
                                              ? clockState.blackDuration
                                              : clockState.whiteDuration
                                          : clockState is ChessClockInitial
                                              ? Duration(
                                                  minutes: clockState
                                                      .settings.startTime)
                                              : const Duration(seconds: 0),
                                      clockState is! ChessClockRunningState
                                          ? false
                                          : state.boardOrientation ==
                                                  PlayerColor.white
                                              ? _chessGame.moveCount % 2 != 0
                                              : _chessGame.moveCount % 2 == 0),
                                ),
                                if (clockState is ChessClockInitial)
                                  Text(
                                    "  + ${clockState.settings.incrementTime}",
                                  ),
                              ],
                            ),

                            RotatedBox(
                              quarterTurns:
                                  clockState is ChessClockRunningState ? 2 : 0,
                              child: Text(
                                  state.boardOrientation == PlayerColor.white
                                      ? "Black"
                                      : "White"),
                            ),
                          ],
                        ),
                      ),
                    ChessBoard(
                      controller: _chessGame.controller,
                      boardColor: state.boardTheme,
                      boardOrientation: state.boardOrientation,
                      onMove: _onMove,
                      enableUserMoves: clockState is! ChessClockPausedState,
                    ),
                    if (clockState is! ChessClockOffState)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Account for swapped orientation.
                              Text(state.boardOrientation == PlayerColor.white
                                  ? "White"
                                  : "Black"),
                              Row(
                                children: [
                                  if (clockState is ChessClockInitial)
                                    Text(
                                      "+ ${clockState.settings.incrementTime}  ",
                                    ),
                                  _buildDurationDisplay(
                                      clockState is ChessClockRunningState
                                          ? state.boardOrientation ==
                                                  PlayerColor.white
                                              ? clockState.whiteDuration
                                              : clockState.blackDuration
                                          : clockState is ChessClockInitial
                                              ? Duration(
                                                  minutes: clockState
                                                      .settings.startTime)
                                              : const Duration(seconds: 0),
                                      clockState is! ChessClockRunningState
                                          ? false
                                          : state.boardOrientation ==
                                                  PlayerColor.white
                                              ? _chessGame.moveCount % 2 == 0
                                              : _chessGame.moveCount % 2 != 0),
                                ],
                              )
                            ],
                          )),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: ActionBar(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Formats and displays duration as text.
  Widget _buildDurationDisplay(Duration duration, bool thisTurn) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
          backgroundColor: thisTurn
              ? Theme.of(context).colorScheme.surfaceVariant
              : Colors.transparent),
      child: Text(
        "$minutes:$seconds",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

/// Opens a dialog to inform of the current game over state. E.g. checkmate, stalemate etc.
Future<void> _showGameOverDialog(BuildContext context,
    FinishedGameWinStatus whoWon, GameResultType gameResult) {
  String title = whoWon.name;

  switch (gameResult) {
    case GameResultType.checkmate:
      title += " by checkmate!";
      break;
    case GameResultType.stalemate:
      title += " by stalemate.";
      break;
    case GameResultType.insufficientMaterial:
      title += " by insufficient material.";
      break;
    case GameResultType.threeFoldRepitition:
      title += " by three fold repitition.";
      break;
    case GameResultType.flagged:
      title += " on time.";
      break;
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext _) {
      return BlocBuilder<ChessGameBloc, ChessGameState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(title),
            content: const Text("Would you like to save this game?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  context.read<ChessGameBloc>().add(GameRestartedEvent());
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    },
  );
}
