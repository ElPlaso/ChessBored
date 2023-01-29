part of 'chess_game_bloc.dart';

abstract class ChessGameState {}

class ChessGameInitial extends ChessGameState {}

class GameOverState extends ChessGameState {
  final GameResultType gameResult;

  GameOverState(this.gameResult);
}
