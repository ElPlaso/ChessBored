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

  void changeTheme(BoardColor value) {
    setState(() {
      color = value;
    });
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
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
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
                      icon: const Icon(Icons.palette),
                      onPressed: () {
                        _showThemePicker(context, color);
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

  Future<void> _showThemePicker(BuildContext context, BoardColor groupValue) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        BoardColor selected = color;
        return AlertDialog(
          title: const Text('Theme'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: BoardColor.values.length,
                itemBuilder: (context, index) {
                  BoardColor boardColor = BoardColor.values[index];
                  return RadioListTile<BoardColor>(
                    activeColor: boardColor == BoardColor.brown
                        ? Colors.brown
                        : boardColor == BoardColor.darkBrown
                            ? Colors.brown[900]
                            : boardColor == BoardColor.orange
                                ? Colors.orange
                                : Colors.teal,
                    title: Text(boardColor.name.toUpperCase()),
                    value: boardColor,
                    groupValue: selected,
                    onChanged: (BoardColor? value) {
                      setState(() {
                        changeTheme(value!);
                        selected = value;
                      });
                    },
                  );
                },
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
