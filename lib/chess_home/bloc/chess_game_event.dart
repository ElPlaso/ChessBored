part of 'chess_game_bloc.dart';

abstract class ChessGameEvent {}

/// Event sent when .isCheckMate() returns true for the chess board controller.
class GameEndedByCheckmateEvent extends ChessGameEvent {}

/// Event sent when .isStaleMate() returns true for the chess board controller.
class GameEndedByStalemateEvent extends ChessGameEvent {}

/// Event sent when .isInsufficientMaterial() returns true for the chess board controller.
class GameEndedByInsufficientMaterialEvent extends ChessGameEvent {}

/// Event sent when .isThreefoldRepetition()) returns true for the chess board controller.
class GameEndedByThreeFoldRepititionEvent extends ChessGameEvent {}

/// Event to reset the chess game to an initial state.
class GameRestartedEvent extends ChessGameEvent {}
