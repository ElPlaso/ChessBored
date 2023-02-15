part of 'chess_clock_bloc.dart';

abstract class ChessClockState extends Equatable {
  final ChessClockSettings? settings;

  const ChessClockState(this.settings);
}

/// State for when the clock is idle.
class ChessClockInitial extends ChessClockState {
  const ChessClockInitial(super.settings);

  @override
  List<Object?> get props => [settings];
}

/// State for when the clock is running.
class ChessClockRunningState extends ChessClockState {
  /// White's remaining time.
  final Duration whiteDuration;

  /// Black's remaining time.
  final Duration blackDuration;

  const ChessClockRunningState(
      this.whiteDuration, this.blackDuration, super.settings);

  @override
  List<Object?> get props => [whiteDuration, blackDuration];
}

/// State for when the clock is paused.
class ChessClockPausedState extends ChessClockRunningState {
  const ChessClockPausedState(
      super.whiteDuration, super.blackDuration, super.settings);
}

/// State for when the clock is turned "off", i.e there are no clock settings.
class ChessClockOffState extends ChessClockState {
  const ChessClockOffState() : super(null);

  @override
  List<Object?> get props => [];
}
