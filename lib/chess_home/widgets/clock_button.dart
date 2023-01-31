import 'package:chess_bored/chess_home/widgets/clock_settings_menu.dart';
import 'package:flutter/material.dart';

/// Button for opening up the [ClockSettingsMenu].
class ClockButton extends StatefulWidget {
  const ClockButton({super.key});

  @override
  State<StatefulWidget> createState() => ClockButtonState();
}

class ClockButtonState extends State<ClockButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.alarm),
      onPressed: () {
        _showDialog(context);
      },
    );
  }

  /// Opens a dialog box with the [ClockSettingsMenu] inside of it.
  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const ClockSettingsMenu();
      },
    );
  }
}
