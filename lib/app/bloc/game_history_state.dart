part of 'game_history_bloc.dart';

abstract class GameHistoryState extends Equatable {
  const GameHistoryState();

  @override
  List<Object> get props => [];
}

class GameHistoryInitial extends GameHistoryState {}
