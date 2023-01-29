part of 'board_view_bloc.dart';

abstract class BoardViewEvent {}

/// Event to change the board's theme to a given theme.
class BoardThemeChangedEvent extends BoardViewEvent {
  final BoardColor boardTheme;

  BoardThemeChangedEvent(this.boardTheme);
}

/// Event to switch the board's orientation.
class BoardOrientationChangedEvent extends BoardViewEvent {}
