import 'dart:async';

import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Class to register the [ChessClockModel] as a singleton.
class ChessClockMaker {
  static register() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton(ChessClockModel());
  }
}

/// Model for getting both side's remaining time during a timed game.
///
/// Allows for setting, starting, and pausing the clock.
class ChessClockModel extends ChangeNotifier {
  /// Keeps track of the current clock settings.
  ChessClockSettings? _currentSettings;

  /// White's remaining time.
  Duration _whiteDuration = const Duration(minutes: 0);

  /// Black's remaining time.
  Duration _blackDuration = const Duration(minutes: 0);

  /// The timer for white's clock.
  Timer? _whiteTimer;

  /// The timer for black's clock.
  Timer? _blackTimer;

  /// Exposes white's current remaining time.
  Duration get whiteDuration => _whiteDuration;

  /// Exposes black's current remaining time.
  Duration get blackDuration => _blackDuration;

  /// Exposes the current clock settings.
  ///
  /// This is useful for resetting the clock once a game has ended.
  ChessClockSettings? get currentSettings => _currentSettings;

  /// Set/reset the initial time settings.
  void setClock(ChessClockSettings settings) {
    _currentSettings = settings;

    _whiteDuration = Duration(minutes: settings.startTime);
    _blackDuration = Duration(minutes: settings.startTime);

    _whiteTimer?.cancel();
    _blackTimer?.cancel();
  }

  /// Starts/restarts white's time.
  void startWhiteTime() {
    // Stop black's clock if it's running
    // and increment black's remaining time.
    if (_blackTimer != null) {
      if (_blackTimer!.isActive) {
        _blackTimer!.cancel();
        _blackDuration = Duration(
            seconds:
                _blackDuration.inSeconds + _currentSettings!.incrementTime);
      }
    }
    _whiteTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = _whiteDuration.inSeconds - 1;
      if (seconds <= 0) {
        _whiteTimer!.cancel();
      } else {
        _whiteDuration = Duration(seconds: seconds);
      }
      notifyListeners();
    });
  }

  /// Starts/restarts black's time.
  void startBlackTime() {
    // Stop white's time if it's running
    // and increment white's remaining time.
    if (_whiteTimer != null) {
      _whiteTimer!.cancel();
      _whiteDuration = Duration(
          seconds: _whiteDuration.inSeconds + _currentSettings!.incrementTime);
    }
    _blackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = _blackDuration.inSeconds - 1;
      if (seconds <= 0) {
        _blackTimer!.cancel();
      } else {
        _blackDuration = Duration(seconds: seconds);
      }
      notifyListeners();
    });
  }

  /// Pauses the clock.
  ///
  /// This is needed for when games are ended by checkmate or draw.
  /// Or in the event of players choosing to pause the game at any point.
  void pauseClock() {
    _whiteTimer?.cancel();
    _blackTimer?.cancel();
  }
}
