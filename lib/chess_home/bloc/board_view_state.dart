part of 'board_view_bloc.dart';

/// The state of the board in terms of look. I.e orientation and theme.
abstract class BoardViewState extends Equatable {
  final BoardColor boardTheme;
  final PlayerColor boardOrientation;
  const BoardViewState(this.boardTheme, this.boardOrientation);

  @override
  List<Object> get props => [boardTheme, boardOrientation];
}

class BoardViewInitial extends BoardViewState {
  const BoardViewInitial(super.boardTheme, super.boardOrientation);
}
