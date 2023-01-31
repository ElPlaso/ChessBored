part of 'chess_clock_bloc.dart';

/// An event sent to the Chess Clock Bloc.
abstract class ChessClockEvent {}

class ClockSetEvent extends ChessClockEvent {
  final ChessClockSettings settings;

  ClockSetEvent(this.settings);
}

class ChessClockStartedEvent extends ChessClockEvent {}

class ChessClockPausedEvent extends ChessClockEvent {}

class PlayerMovedEvent extends ChessClockEvent {}

class TimeTickedEvent extends ChessClockEvent {}

class ChessClockStoppedEvent extends ChessClockEvent {}
