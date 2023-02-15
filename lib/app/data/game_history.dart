import 'package:chess_bored/app/models/finished_game.dart';
import 'package:chess_bored/app/models/finished_game_win_status.dart';
import 'package:chess_bored/app/models/game_history_list.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get_it/get_it.dart';
import 'package:localstorage/localstorage.dart';

/// Class to register the [GameHistory] as a singleton.
class GameHistoryMaker {
  static register() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton(GameHistory());
  }
}

class GameHistory {
  final GameHistoryList _gameHistoryList = GameHistoryList();
  final LocalStorage _storage = LocalStorage('game_history.json');

  GameHistoryList get gameHistory => _gameHistoryList;

  Map<String, BoardColor> themeMap = {
    'brown': BoardColor.brown,
    'darkBrown': BoardColor.darkBrown,
    'orange': BoardColor.orange,
    'green': BoardColor.green
  };
  Map<String, GameResultType> resultMap = {
    'checkmate': GameResultType.checkmate,
    'stalemate': GameResultType.stalemate,
    'insufficientMaterial': GameResultType.insufficientMaterial,
    'threeFoldRepitition': GameResultType.threeFoldRepitition,
    'flagged': GameResultType.flagged,
  };

  Map<String, FinishedGameWinStatus> winnerMap = {
    'whiteVictory': FinishedGameWinStatus.whiteVictory,
    'blackVictory': FinishedGameWinStatus.blackVictory,
    'draw': FinishedGameWinStatus.draw
  };

  loadGameHistory() async {
    if (await _storage.ready) {
      var storedList = _storage.getItem('game_history');
      if (storedList != null) {
        _gameHistoryList.finishedGames = List<FinishedGame>.from(
          (storedList as List).map(
            (finishedGame) => FinishedGame(
              finishedGame['gameAsFen'],
              List<String?>.from(finishedGame['gameAsSan']),
              themeMap[finishedGame['gameBoardTheme']]!,
              ChessClockSettings(
                finishedGame['gameClockSettings']['startTime'],
                finishedGame['gameClockSettings']['incrementTime'],
              ),
              resultMap[finishedGame['gameResult']]!,
              winnerMap[finishedGame['winStatus']]!,
            ),
          ),
        );
      }
    }
  }

  saveGameToList(FinishedGame game) {
    _gameHistoryList.finishedGames.add(game);
    _storage.setItem('game_history', _gameHistoryList.toJSONEncodable());
  }

  clearAll() async {
    if (await _storage.ready) {
      var storedList = _storage.getItem('game_history');
      if (storedList != null) {
        _storage.clear();
      }
      _gameHistoryList.finishedGames.clear();
    }
  }
}
