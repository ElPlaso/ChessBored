import 'package:bloc/bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/data/chess_clock_model.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'chess_clock_event.dart';
part 'chess_clock_state.dart';

/// The Bloc for handling the chess clock / timer.
class ChessClockBloc extends Bloc<ChessClockEvent, ChessClockState> {
  final ChessClockModel _chessClock = GetIt.instance<ChessClockModel>();
  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  ChessClockBloc() : super(ChessClockOffState()) {
    _chessClock.addListener(_onChessClockListen);
    _chessGame.addListener(_onChessGameListen);
    on<ClockSetEvent>(_onClockSet);
    on<ChessClockStartedEvent>(_onChessClockStarted);
    on<PlayerMovedEvent>(_onPlayerMoved);
    on<TimeTickedEvent>(_onTimeTicked);
    on<ChessClockStoppedEvent>(_onChessClockStopped);
    on<ChessClockPausedEvent>(_onChessClockPaused);
    on<ChessClockToggleOnOffEvent>(_onChessClockToggleOnOff);
  }

  _onChessClockToggleOnOff(event, emit) {
    if (state is ChessClockOffState) {
      emit(ChessClockInitial(_chessClock.whiteDuration));
    } else {
      emit(ChessClockOffState());
    }
  }

  _onChessGameListen() {
    // The game has ended.
    add(ChessClockStoppedEvent());
  }

  _onChessClockListen() {
    add(TimeTickedEvent());
  }

  _onClockSet(ClockSetEvent event, emit) {
    _chessClock.setClock(event.settings);
    emit(ChessClockInitial(Duration(minutes: event.settings.startTime)));
  }

  _onChessClockStarted(ChessClockStartedEvent event, emit) {
    // Black has just played, or no moves have been made, so start white's clock...
    if (_chessGame.moveCount % 2 == 0) {
      _chessClock.startWhiteTime();
    } else {
      _chessClock.startBlackTime();
    }
    emit(ChessClockRunningState(
        _chessClock.whiteDuration, _chessClock.blackDuration));
  }

  _onPlayerMoved(PlayerMovedEvent event, emit) {
    if (state is ChessClockRunningState) {
      // Black has just played, so start white's clock...
      if (_chessGame.moveCount % 2 == 0) {
        _chessClock.startWhiteTime();
      } else {
        // ... and vice versa.
        _chessClock.startBlackTime();
      }
    }
  }

  _onTimeTicked(TimeTickedEvent event, emit) {
    // Emite state with new durations.
    emit(ChessClockRunningState(
        _chessClock.whiteDuration, _chessClock.blackDuration));
  }

  _onChessClockStopped(ChessClockStoppedEvent event, emit) {
    // Reset the clock to an idle state.
    if (_chessClock.currentSettings != null) {
      _chessClock.setClock(_chessClock.currentSettings!);
      emit(ChessClockInitial(
        Duration(minutes: _chessClock.currentSettings!.startTime),
      ));
    }
  }

  _onChessClockPaused(ChessClockPausedEvent event, emit) {
    if (_chessClock.currentSettings != null) {
      _chessClock.pauseClock();
      emit(ChessClockPausedState(
          _chessClock.whiteDuration, _chessClock.blackDuration));
    }
  }
}
