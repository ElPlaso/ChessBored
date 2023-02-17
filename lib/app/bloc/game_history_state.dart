part of 'game_history_bloc.dart';

abstract class GameHistoryState extends Equatable {
  const GameHistoryState();

  @override
  List<Object> get props => [];
}

class GameHistoryInitial extends GameHistoryState {}

class GameHistoryLoadedState extends GameHistoryState {
  final List<FinishedGame> games;

  const GameHistoryLoadedState(this.games);

  @override
  List<Object> get props => games;
}

class GameSavedState extends GameHistoryState {}
