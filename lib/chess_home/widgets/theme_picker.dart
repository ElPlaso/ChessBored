import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'dart:ui' as dart;

typedef ThemeChangedFunction = void Function(BoardColor);

/// Widget for choosing the theme of the board.
///
/// It's purpose is to showcase the available themes, and to allow for selecting a theme.
/// The [onChanged] function handles what happens to the selected value.
class ThemePicker extends StatefulWidget {
  final ThemeChangedFunction onSelected;
  final BoardColor currentlySelected;
  const ThemePicker(
      {super.key, required this.onSelected, required this.currentlySelected});

  @override
  State<StatefulWidget> createState() => ThemePickerState();
}

class ThemePickerState extends State<ThemePicker> {
  late BoardColor _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentlySelected;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardViewBloc, BoardViewState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: BoardColor.values.length,
            itemBuilder: (context, index) {
              BoardColor boardColor = BoardColor.values[index];
              dart.Color radioColor;
              switch (boardColor) {
                case BoardColor.brown:
                  radioColor = Colors.brown;
                  break;
                case BoardColor.darkBrown:
                  radioColor = Colors.brown[900]!;
                  break;
                case BoardColor.orange:
                  radioColor = Colors.orange;
                  break;
                case BoardColor.green:
                  radioColor = Colors.teal;
                  break;
              }
              return Theme(
                data: ThemeData(
                  unselectedWidgetColor: radioColor,
                ),
                child: Radio<BoardColor>(
                  activeColor: radioColor,
                  value: boardColor,
                  groupValue: _selected,
                  onChanged: (BoardColor? value) {
                    setState(() {
                      widget.onSelected(value!);
                      _selected = value;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
