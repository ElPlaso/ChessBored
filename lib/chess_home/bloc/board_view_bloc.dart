import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

import 'package:localstorage/localstorage.dart';

part 'board_view_event.dart';
part 'board_view_state.dart';

/// Bloc to handle the look of the board. I.e it's orientation and theme.
class BoardViewBloc extends Bloc<BoardViewEvent, BoardViewState> {
  final LocalStorage _storage = LocalStorage('board_view.json');

  BoardViewBloc()
      : super(const BoardViewInitial(BoardColor.brown, PlayerColor.white)) {
    on<BoardThemeLoadedEvent>(_onBoardThemeLoaded);
    on<BoardThemeChangedEvent>(_onBoardThemeChanged);
    on<BoardOrientationChangedEvent>(_onBoardOrientationChanged);
  }

  _onBoardThemeLoaded(event, emit) async {
    if (await _storage.ready) {
      String theme = _storage.getItem('board_theme');
      BoardColor boardColor = BoardColor.brown;
      switch (theme) {
        case 'brown':
          break;
        case 'darkBrown':
          boardColor = BoardColor.darkBrown;
          break;
        case 'orange':
          boardColor = BoardColor.orange;
          break;
        case 'green':
          boardColor = BoardColor.green;
          break;
        default:
          break;
      }
      emit(
        BoardViewInitial(boardColor, PlayerColor.white),
      );
    }
  }

  _onBoardThemeChanged(BoardThemeChangedEvent event, emit) {
    emit(
      BoardViewInitial(event.boardTheme, state.boardOrientation),
    );
    _saveThemeToStorage(event.boardTheme);
  }

  _onBoardOrientationChanged(event, emit) {
    PlayerColor boardOrientation = PlayerColor.white;
    if (state.boardOrientation == PlayerColor.white) {
      boardOrientation = PlayerColor.black;
    }
    emit(BoardViewInitial(state.boardTheme, boardOrientation));
  }

  _saveThemeToStorage(BoardColor theme) {
    _storage.setItem(
      'board_theme',
      theme.name,
    );
  }
}
