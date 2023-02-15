import 'package:chess_bored/app/bloc/game_history_bloc.dart';
import 'package:chess_bored/game_history/widgets/game_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class GameHistoryPage extends StatefulWidget {
  const GameHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _GameHistoryPageState();
}

class _GameHistoryPageState extends State<GameHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'History.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
          ),
        ),
      ),
      body: BlocBuilder<GameHistoryBloc, GameHistoryState>(
        builder: (context, state) {
          return state is GameHistoryLoadedState
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: state.games.length,
                  itemBuilder: (context, index) {
                    ChessBoardController controller = ChessBoardController();
                    controller.loadFen(state.games[index].gameAsFen);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {},
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: GamePreview(
                                fen: state.games[index].gameAsFen,
                                theme: state.games[index].gameBoardTheme,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        },
      ),
    );
  }
}
