import 'package:chess_bored/app/models/finished_game_win_status.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

/// Model for a saved chess game.
///
/// Will be used for previous chess game history.
class FinishedGame {
  /// Used to store the game's final state.
  final String gameAsFen;

  /// Used to store every move of the game.
  final String gameAsSan;

  /// The board theme when the game was played.
  final BoardColor gameBoardTheme;

  /// The clock settings of this particular game.
  final ChessClockSettings gameClockSettings;

  /// The result of the game.
  final GameResultType gameResult;

  /// In addition to [gameResult], this is who won the game.
  final FinishedGameWinStatus winStatus;

  FinishedGame(this.gameAsFen, this.gameAsSan, this.gameBoardTheme,
      this.gameClockSettings, this.gameResult, this.winStatus);

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['gameAsFen'] = gameAsFen;
    m['gameAsSan'] = gameAsSan;
    m['gameBoardTheme'] = gameBoardTheme;
    m['gameClockSettings'] = gameClockSettings;
    m['gameResult'] = gameResult;
    m['winStatu'] = winStatus;

    return m;
  }
}
