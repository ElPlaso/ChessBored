import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

part 'board_view_event.dart';
part 'board_view_state.dart';

/// Bloc to handle the look of the board. I.e it's orientation and theme.
class BoardViewBloc extends Bloc<BoardViewEvent, BoardViewState> {
  BoardViewBloc()
      : super(const BoardViewInitial(BoardColor.brown, PlayerColor.white)) {
    on<BoardThemeChangedEvent>(_onBoardThemeChanged);
    on<BoardOrientationChangedEvent>(_onBoardOrientationChanged);
  }

  _onBoardThemeChanged(BoardThemeChangedEvent event, emit) {
    emit(BoardViewInitial(event.boardTheme, state.boardOrientation));
  }

  _onBoardOrientationChanged(event, emit) {
    PlayerColor boardOrientation = PlayerColor.white;
    if (state.boardOrientation == PlayerColor.white) {
      boardOrientation = PlayerColor.black;
    }
    emit(BoardViewInitial(state.boardTheme, boardOrientation));
  }
}
