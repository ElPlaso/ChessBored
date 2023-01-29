import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

/// Widget to show all the current moves in a game.
///
/// Shows the moves via San notation in a horizontal scrollable list.
class MoveList extends StatelessWidget {
  final ChessBoardController controller;
  final ScrollController scrollController;

  const MoveList(
      {super.key, required this.controller, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.withOpacity(0.2),
      ),
      width: MediaQuery.of(context).size.width,
      height: 30,
      child: ValueListenableBuilder<Chess>(
        valueListenable: controller,
        builder: (context, game, _) {
          return ListView.builder(
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 50),
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: controller.getSan().length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  controller.getSan()[index]!,
                  style: TextStyle(
                    color: index % 2 == 0 ? Colors.grey[800] : Colors.grey[700],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
