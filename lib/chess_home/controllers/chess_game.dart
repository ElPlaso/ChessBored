import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:get_it/get_it.dart';

/// Class to register the home page's [ChessGame] as a singleton.
class ChessGameMaker {
  static register() {
    GetIt getIt = GetIt.instance;
    getIt.registerSingleton(ChessGame());
  }
}

/// Model for the home page's chess game.
///
/// Exposes a [ChessBoardController] and the number of moves made so far.
class ChessGame extends ChangeNotifier {
  ChessBoardController controller = ChessBoardController();

  /// The total number of half moves.
  ///
  /// Used to determine which color wins a game if it's checkmate.
  int moveCount = 0;

  /// Makes sure the move count decrements if a move is undone.
  undo() {
    controller.undoMove();
    if (moveCount > 0) {
      moveCount--;
    }
  }

  /// Makes sure the move count is zero if the game is reset.
  reset() {
    controller.resetBoard();
    moveCount = 0;
    notifyListeners();
  }
}
