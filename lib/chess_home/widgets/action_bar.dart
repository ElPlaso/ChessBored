import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_clock_bloc.dart';
import 'package:chess_bored/chess_home/bloc/chess_game_bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/widgets/clock_button.dart';
import 'package:chess_bored/chess_home/widgets/palette_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Widget to contain buttons for performing actions relating to the chess board/game.
class ActionBar extends StatelessWidget {
  ActionBar({super.key});

  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardViewBloc, BoardViewState>(
      builder: (context, boardViewState) {
        return BlocBuilder<ChessGameBloc, ChessGameState>(
          builder: (context, chessGameState) {
            return BlocBuilder<ChessClockBloc, ChessClockState>(
              builder: (chessClockContext, chessClockState) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Button to switch the board's orientation.
                      IconButton(
                        icon: const Icon(Icons.import_export),
                        onPressed: () {
                          context
                              .read<BoardViewBloc>()
                              .add(BoardOrientationChangedEvent());
                        },
                      ),
                      // Button to undo a move. (non-pawn and non-capture move).
                      IconButton(
                        icon: const Icon(Icons.undo),
                        onPressed: () {
                          _chessGame.undo();
                        },
                      ),
                      // Button to redo moves that were undone.
                      IconButton(
                        icon: const Icon(Icons.redo),
                        onPressed: () {
                          // TODO
                        },
                      ),
                      // Button to start a game.
                      (chessClockState is ChessClockInitial ||
                              chessClockState is ChessClockPausedState
                          ? IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () {
                                chessClockContext
                                    .read<ChessClockBloc>()
                                    .add(ChessClockStartedEvent());
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.pause),
                              onPressed: () {
                                chessClockContext
                                    .read<ChessClockBloc>()
                                    .add(ChessClockPausedEvent());
                              },
                            )),
                      // Button to update the clock settings.
                      const ClockButton(),
                      // Button for changing the board's theme.
                      PaletteButton(state: boardViewState),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context
                              .read<ChessGameBloc>()
                              .add(GameRestartedEvent());
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
