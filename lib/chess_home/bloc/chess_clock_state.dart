part of 'chess_clock_bloc.dart';

abstract class ChessClockState extends Equatable {}

/// State for when the clock is idle.
class ChessClockInitial extends ChessClockState {
  @override
  List<Object?> get props => [];
}

/// State for when the clock is running.
class ChessClockRunningState extends ChessClockState {
  /// White's remaining time.
  final Duration whiteDuration;

  /// Black's remaining time.
  final Duration blackDuration;

  ChessClockRunningState(this.whiteDuration, this.blackDuration);

  @override
  List<Object?> get props => [whiteDuration, blackDuration];
}
