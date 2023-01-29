import 'package:bloc/bloc.dart';
import 'package:chess_bored/chess_home/bloc/game_result_type.dart';
import 'package:chess_bored/chess_home/controllers/chess_game.dart';
import 'package:get_it/get_it.dart';

part 'chess_game_event.dart';
part 'chess_game_state.dart';

/// Bloc for handling the result of the game.
class ChessGameBloc extends Bloc<ChessGameEvent, ChessGameState> {
  final ChessGame _chessGame = GetIt.instance<ChessGame>();

  ChessGameBloc() : super(ChessGameInitial()) {
    _chessGame.controller.addListener(_checkGameState);
    on<GameEndedByCheckmateEvent>(_onGameEndedByCheckmate);
    on<GameEndedByStalemateEvent>(_onGameEndedByStalemate);
    on<GameEndedByInsufficientMaterialEvent>(
        _onGameEndedByInsufficientMaterial);
    on<GameEndedByThreeFoldRepititionEvent>(_onGameEndedByThreeFoldRepitition);
    on<GameRestartedEvent>(_onGameRestarted);
  }

  _checkGameState() {
    if (_chessGame.controller.isCheckMate()) {
      add(GameEndedByCheckmateEvent());
    } else if (_chessGame.controller.isStaleMate()) {
      add(GameEndedByStalemateEvent());
    } else if (_chessGame.controller.isInsufficientMaterial()) {
      add(GameEndedByInsufficientMaterialEvent());
    } else if (_chessGame.controller.isThreefoldRepetition()) {
      add(GameEndedByThreeFoldRepititionEvent());
    }
  }

  _onGameEndedByCheckmate(GameEndedByCheckmateEvent event, emit) {
    emit(GameOverState(GameResultType.checkmate));
  }

  _onGameEndedByStalemate(event, emit) {
    emit(GameOverState(GameResultType.stalemate));
  }

  _onGameEndedByInsufficientMaterial(event, emit) {
    emit(GameOverState(GameResultType.insufficientMaterial));
  }

  _onGameEndedByThreeFoldRepitition(event, emit) {
    emit(GameOverState(GameResultType.threeFoldRepitition));
  }

  _onGameRestarted(event, emit) {
    _chessGame.reset();
    emit(ChessGameInitial());
  }
}
