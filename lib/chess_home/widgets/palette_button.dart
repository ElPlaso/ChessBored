import 'package:chess_bored/chess_home/bloc/board_view_bloc.dart';
import 'package:chess_bored/chess_home/widgets/theme_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Button which displays a [ThemePicker] inside a pop up menu when clicked.
///
/// This button displays the pop up menu just above itself.
class PaletteButton extends StatefulWidget {
  final BoardViewState state;

  const PaletteButton({super.key, required this.state});

  @override
  State<StatefulWidget> createState() => PaletteButtonState();
}

class PaletteButtonState extends State<PaletteButton> {
  final _key = GlobalKey();

  double _xPosition = 0.00;
  double _yPosition = 0.00;

  // Gets the xy position of the button.
  void _getPosition() {
    RenderBox? box = _key.currentContext!.findRenderObject() as RenderBox?;

    Offset position = box!.localToGlobal(Offset.zero);

    setState(() {
      _xPosition = position.dx;
      _yPosition = position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _key,
      icon: const Icon(Icons.palette),
      onPressed: () {
        _getPosition();
        _showPopupMenu(context);
      },
    );
  }

  /// Opens a pop up with the [ThemePicker] inside of it.
  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      // Shrink the size, as the padding is too big otherwise.
      constraints: const BoxConstraints(maxWidth: 225),
      context: context,
      // Minus 75 to display above instead of over.
      position: RelativeRect.fromLTRB(_xPosition, _yPosition - 75, 0, 0),
      items: [
        PopupMenuItem(
          // This pop up menu item is used merely
          // as a container for the theme picker
          // so there is no need to click it.
          enabled: false,
          value: 1,
          child: SizedBox(
            width: 200,
            height: 50,
            child: ThemePicker(
              currentlySelected: widget.state.boardTheme,
              onSelected: (value) {
                context
                    .read<BoardViewBloc>()
                    .add(BoardThemeChangedEvent(value));
              },
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
}
