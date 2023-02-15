import 'package:chess_bored/app/models/finished_game.dart';

class GameHistoryList {
  List<FinishedGame> finishedGames = [];

  toJSONEncodable() {
    return finishedGames.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}
