import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/widgets/action_bar.dart';
import 'package:chess_bored/chess_home/widgets/move_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter/material.dart';

/// Page for the chess board view and state.
class ChessHomePage extends StatefulWidget {
  const ChessHomePage({super.key, required this.title});

  final String title;

  @override
  State<ChessHomePage> createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  final ChessBoardController _controller = ChessBoardController();

  final ScrollController _moveListScrollController = ScrollController();

  /// Scrolls the move list to the end so that the latest move is always visible.
  void _scrollMoveList() {
    _moveListScrollController.animateTo(
      _moveListScrollController.position.maxScrollExtent,
      curve: Curves.easeInOut,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
          ),
        ),
      ),
      body: BlocBuilder<BoardViewBloc, BoardViewState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: MoveList(
                  controller: _controller,
                  scrollController: _moveListScrollController,
                ),
              ),
              ChessBoard(
                controller: _controller,
                boardColor: state.boardTheme,
                boardOrientation: state.boardOrientation,
                onMove: _scrollMoveList,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: ActionBar(controller: _controller),
              ),
            ],
          );
        },
      ),
    );
  }
}
