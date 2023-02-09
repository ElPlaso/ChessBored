part of 'chess_clock_bloc.dart';

abstract class ChessClockState extends Equatable {}

/// State for when the clock is idle.
class ChessClockInitial extends ChessClockState {
  // Used to show the clock start time settings when a game isn't in play.
  final Duration initialDuration;

  ChessClockInitial(this.initialDuration);

  @override
  List<Object?> get props => [initialDuration];
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

/// State for when the clock is paused.
class ChessClockPausedState extends ChessClockRunningState {
  ChessClockPausedState(super.whiteDuration, super.blackDuration);
}

/// State for when the clock is turned "off", i.e there are no clock settings.
class ChessClockOffState extends ChessClockState {
  @override
  List<Object?> get props => [];
}
