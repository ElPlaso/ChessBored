import 'package:chess_bored/app/models/finished_game.dart';
import 'package:chess_bored/app/models/game_history_list.dart';
import 'package:localstorage/localstorage.dart';

class GameHistory {
  GameHistoryList _gameHistoryList = GameHistoryList();
  final LocalStorage _storage = LocalStorage('game_history.json');

  GameHistoryList get gameHistory => _gameHistoryList;

  loadGameHistory() async {
    if (await _storage.ready) {
      var storedList = _storage.getItem('game_history');
      if (storedList != null) {
        _gameHistoryList = storedList;
      }
    }
  }

  saveGameToList(FinishedGame game) {
    _gameHistoryList.finishedGames.add(game);
    _storage.setItem('todos', _gameHistoryList.toJSONEncodable());
  }
}
