import 'package:chess_bored/chess_home/bloc/chess_clock_bloc.dart';
import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:chess_bored/chess_home/widgets/number_selector.dart';
import 'package:chess_bored/chess_home/widgets/preset_clock_settings_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menu which allows for selecting a Chess Clock configuration.
///
/// Allows choosing from a predefined list of [ChessClockSettings] or creating a custom configuration
/// via the [NumberSelector]s.
class ClockSettingsMenu extends StatefulWidget {
  const ClockSettingsMenu({super.key});

  @override
  State<StatefulWidget> createState() => ClockSettingsMenuState();
}

class ClockSettingsMenuState extends State<ClockSettingsMenu> {
  int _minutes = 0;
  int _increment = 0;

  int _customMinutes = 0;
  int _customIncrement = 0;

  final _presetClockSettings = PresetChessClockSettings.getList();

  /// List of booleans to determine which clock preset is selected.=
  final _isSelected = List<bool>.generate(
      PresetChessClockSettings.getList().length, (index) => false);

  /// Sets the chosen minutes to the custom one.
  void _setCustomMinutes(int minutes) {
    setState(() {
      // Keep track of the custom minutes, in case a preset is unselected.
      _customMinutes = minutes;
      _minutes = _customMinutes;
      // Unselect all the presets, since a custom minute has just been chosen.
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      // Likewise, make sure that the increment is also reset to the custom one.
      _increment = _customIncrement;
    });
  }

  /// Sets the chosen increment to the custom one.
  void _setCustomIncrement(int increment) {
    setState(() {
      // Keep track of the custom increment, in case a preset is unselected.
      _customIncrement = increment;
      _increment = _customIncrement;
      // Unselect all the presets, since a custom increment has just been chosen.
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      // Likewise, make sure that the minutes is also reset to the custom one.
      _minutes = _customMinutes;
    });
  }

  /// Sets the minutes and increment to that of a preset.
  void _setPreset(ChessClockSettings? settings) {
    if (settings != null) {
      setState(() {
        _minutes = settings.startTime;
        _increment = settings.incrementTime;
      });
    } else {
      // Since the preset is null,
      // we can treat this as unchoosing the preset and choosing the custom settings.
      setState(() {
        _minutes = _customMinutes;
        _increment = _customIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChessClockBloc, ChessClockState>(
      builder: (context, state) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Clock Settings'),
              Switch(
                  value: state is ChessClockOffState ? false : true,
                  onChanged: (_) {
                    context
                        .read<ChessClockBloc>()
                        .add(ChessClockToggleOnOffEvent());
                  })
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Presets",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                PresetClockSettingsToggle(
                  onSelected: _setPreset,
                  isSelected: _isSelected,
                  presetClockSettings: _presetClockSettings,
                ),
                Text(
                  "Custom",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberSelector(
                        itemCount: 61,
                        onSelected: _setCustomMinutes,
                      ),
                      Text("+",
                          style: Theme.of(context).textTheme.displaySmall),
                      NumberSelector(
                          itemCount: 60, onSelected: _setCustomIncrement),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Minutes per side",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          _minutes.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Increment in seconds",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          _increment.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
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
              onPressed: _minutes == 0
                  ? null
                  : () {
                      context.read<ChessClockBloc>().add(
                            ClockSetEvent(
                              ChessClockSettings(_minutes, _increment),
                            ),
                          );
                      Navigator.of(context).pop();
                    },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
