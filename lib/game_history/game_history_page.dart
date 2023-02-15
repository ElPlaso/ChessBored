import 'package:chess_bored/app/bloc/game_history_bloc.dart';
import 'package:chess_bored/game_history/widgets/game_preview.dart';
import 'package:flutter/cupertino.dart';
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
    return BlocBuilder<GameHistoryBloc, GameHistoryState>(
      builder: (context, state) {
        return state is GameHistoryLoadedState
            ? Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  title: Text(
                    'History.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.headlineLarge!.fontSize,
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          if (state.games.isNotEmpty) {
                            _showClearHistorydialog(context);
                          }
                        },
                        icon: Icon(
                          state.games.isEmpty
                              ? Icons.delete_outline
                              : Icons.delete,
                          color: Colors.black,
                        ))
                  ],
                ),
                body: CupertinoScrollbar(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: state.games.length,
                    itemBuilder: (context, index) {
                      ChessBoardController controller = ChessBoardController();
                      controller.loadFen(state.games[index].gameAsFen);
                      return Card(
                        elevation: 2,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: GamePreview(
                                    fen: state.games[index].gameAsFen,
                                    theme: state.games[index].gameBoardTheme,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                          state.games[index]
                                                      .gameClockSettings !=
                                                  null
                                              ? "${state.games[index].gameClockSettings!.startTime} + ${state.games[index].gameClockSettings!.incrementTime}"
                                              : '-',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(state.games[index].winStatus.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      Text(state.games[index].gameResult.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ))
            : Container();
      },
    );
  }

  Future<void> _showClearHistorydialog(BuildContext context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext _) {
          return AlertDialog(
            title: const Text('Clear History?'),
            content: const Text(
                'This will remove all your saved games. This action cannot be undone. Are you sure you want to proceed?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<GameHistoryBloc>().add(AllHistoryClearedEvent());
                  Navigator.pop(context);
                },
                child: const Text('Proceed'),
              )
            ],
          );
        });
  }
}
