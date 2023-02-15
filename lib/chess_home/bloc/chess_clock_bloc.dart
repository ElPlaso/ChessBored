import 'package:bloc/bloc.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:chess_bored/chess_home/data/chess_clock_model.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import 'package:localstorage/localstorage.dart';

part 'chess_clock_event.dart';
part 'chess_clock_state.dart';

/// The Bloc for handling the chess clock / timer.
class ChessClockBloc extends Bloc<ChessClockEvent, ChessClockState> {
  final ChessClockModel _chessClock = GetIt.instance<ChessClockModel>();
  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  final LocalStorage _storage = LocalStorage('chess_clock.json');

  ChessClockBloc() : super(const ChessClockOffState()) {
    _chessClock.addListener(_onChessClockListen);
    _chessGame.addListener(_onChessGameListen);
    on<ClockSettingsLoadedEvent>(_onClockSettingsLoaded);
    on<ClockSetEvent>(_onClockSet);
    on<ChessClockStartedEvent>(_onChessClockStarted);
    on<PlayerMovedEvent>(_onPlayerMoved);
    on<TimeTickedEvent>(_onTimeTicked);
    on<ChessClockStoppedEvent>(_onChessClockStopped);
    on<ChessClockPausedEvent>(_onChessClockPaused);
    on<ChessClockToggleOnOffEvent>(_onChessClockToggleOnOff);
  }

  _onClockSettingsLoaded(event, emit) async {
    if (await _storage.ready) {
      var settings = _storage.getItem('clock_settings');
      if (settings != null) {
        _chessClock.setClock((ChessClockSettings(
            settings['startTime'], settings['incrementTime'])));
        emit(
          ChessClockInitial(
            _chessClock.currentSettings,
          ),
        );
      }
    }
  }

  _onChessClockToggleOnOff(event, emit) {
    if (state is ChessClockOffState) {
      emit(ChessClockInitial(_chessClock.currentSettings));
    } else {
      emit(const ChessClockOffState());
      _saveSettingsToStorage(null);
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
    emit(ChessClockInitial(event.settings));
    _saveSettingsToStorage(event.settings);
  }

  _onChessClockStarted(ChessClockStartedEvent event, emit) {
    // Black has just played, or no moves have been made, so start white's clock...
    if (_chessGame.moveCount % 2 == 0) {
      _chessClock.startWhiteTime();
    } else {
      _chessClock.startBlackTime();
    }
    emit(ChessClockRunningState(_chessClock.whiteDuration,
        _chessClock.blackDuration, _chessClock.currentSettings));
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
    emit(ChessClockRunningState(_chessClock.whiteDuration,
        _chessClock.blackDuration, _chessClock.currentSettings));
  }

  _onChessClockStopped(ChessClockStoppedEvent event, emit) {
    // Reset the clock to an idle state.
    _chessClock.setClock(_chessClock.currentSettings);
    if (state is! ChessClockOffState) {
      emit(
        ChessClockInitial(
          _chessClock.currentSettings,
        ),
      );
    }
  }

  _onChessClockPaused(ChessClockPausedEvent event, emit) {
    _chessClock.pauseClock();
    emit(ChessClockPausedState(_chessClock.whiteDuration,
        _chessClock.blackDuration, _chessClock.currentSettings));
  }

  _saveSettingsToStorage(ChessClockSettings? settings) {
    if (settings != null) {
      _storage.setItem(
        'clock_settings',
        settings.toJSONEncodable(),
      );
    } else {
      _storage.setItem(
        'clock_settings',
        null,
      );
    }
  }
}
