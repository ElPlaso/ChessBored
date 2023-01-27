import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

/// Page for the chess board view and state.
class ChessHomePage extends StatefulWidget {
  const ChessHomePage({super.key, required this.title});

  final String title;

  @override
  State<ChessHomePage> createState() => _ChessHomePageState();
}

class _ChessHomePageState extends State<ChessHomePage> {
  ChessBoardController controller = ChessBoardController();

  BoardColor color = BoardColor.brown;

  PlayerColor boardOrientation = PlayerColor.white;

  ScrollController scrollController = ScrollController();

  void scroll() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
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
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Theme: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  DropdownButton<BoardColor>(
                    value: color,
                    icon: const Icon(Icons.expand_more),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onChanged: (value) {
                      setState(() {
                        color = value!;
                      });
                    },
                    items: BoardColor.values.map((BoardColor value) {
                      return DropdownMenuItem<BoardColor>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
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
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 5, right: 50),
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
                            color: index % 2 == 0
                                ? Colors.grey[800]
                                : Colors.grey[700],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: ChessBoard(
              controller: controller,
              boardColor: color,
              boardOrientation: boardOrientation,
              onMove: scroll,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.import_export),
                      onPressed: () {
                        setState(() {
                          switch (boardOrientation) {
                            case PlayerColor.white:
                              boardOrientation = PlayerColor.black;
                              break;
                            case PlayerColor.black:
                              boardOrientation = PlayerColor.white;
                              break;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: () {
                        controller.undoMove();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      onPressed: () {
                        // TODO
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        // TODO
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.alarm),
                      onPressed: () {
                        // TODO
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.resetBoard();
                      },
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
