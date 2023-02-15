import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class GamePreview extends StatefulWidget {
  final String fen;
  final BoardColor theme;
  const GamePreview({super.key, required this.fen, required this.theme});

  @override
  State<StatefulWidget> createState() => _GamePreviewState();
}

class _GamePreviewState extends State<GamePreview> {
  ChessBoardController controller = ChessBoardController();
  @override
  initState() {
    super.initState();
    controller.loadFen(widget.fen);
  }

  @override
  Widget build(BuildContext context) {
    return ChessBoard(
      controller: controller,
      enableUserMoves: false,
      boardColor: widget.theme,
    );
  }
}
