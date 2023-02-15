part of 'game_history_bloc.dart';

abstract class GameHistoryEvent {}

/// Event to load storage for the first time.
class GameHistoryLoadedEvent extends GameHistoryEvent {}

/// Event for when a game is saved.
class GameSavedEvent extends GameHistoryEvent {
  final FinishedGameWinStatus finishedGameWinStatus;
  final GameResultType gameResultType;
  final BoardColor boardTheme;
  final ChessBoardController chessBoardController;
  final ChessClockSettings chessClockSettings;

  GameSavedEvent(this.finishedGameWinStatus, this.gameResultType,
      this.boardTheme, this.chessBoardController, this.chessClockSettings);
}
