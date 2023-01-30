import 'package:chess_bored/chess_home/widgets/clock_settings_menu.dart';
import 'package:flutter/material.dart';

/// Button for showing the [ClockSettingsMenu] inside a dialog box when clicked.
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
        return AlertDialog(
          title: const Text('Clock Settings'),
          content: const ClockSettingsMenu(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Done'),
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
