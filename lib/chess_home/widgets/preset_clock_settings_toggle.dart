import 'package:chess_bored/chess_home/data/chess_clock_settings.dart';
import 'package:flutter/material.dart';

typedef PresetChangedFunction = void Function(ChessClockSettings?);

/// Widget for picking a clock configuration from a list of predefined [ChessClockSettings].
class PresetClockSettingsToggle extends StatefulWidget {
  /// Function which decides what happens to the selected preset.
  final PresetChangedFunction onSelected;

  /// List of booleans to determine which index is selected.
  final List<bool> isSelected;

  /// The list of preset clock settings.
  final List<ChessClockSettings> presetClockSettings;

  /// Whether the buttons can be clicked or not.
  final bool disabled;

  const PresetClockSettingsToggle({
    super.key,
    required this.onSelected,
    required this.isSelected,
    required this.presetClockSettings,
    required this.disabled,
  });

  @override
  PresetClockSettingsToggleState createState() {
    return PresetClockSettingsToggleState();
  }
}

class PresetClockSettingsToggleState extends State<PresetClockSettingsToggle> {
  List<bool> _isSelected = [];
  List<ChessClockSettings> _presetClockSettings = [];

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
    _presetClockSettings = widget.presetClockSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 80,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
        children: List.generate(
          _isSelected.length,
          (index) {
            return OutlinedButton(
              onPressed: widget.disabled
                  ? null
                  : () {
                      setState(() {
                        // Unselect all the other presets.
                        for (int i = 0; i < _isSelected.length; i++) {
                          if (i != index) {
                            _isSelected[i] = false;
                          }
                        }
                        // If not selected, then select
                        // else if already selected, then treat as unselect.
                        _isSelected[index] = !_isSelected[index];
                      });
                      if (_isSelected[index]) {
                        widget.onSelected(_presetClockSettings[index]);
                      } else {
                        // Give function a null preset.
                        widget.onSelected(null);
                      }
                    },
              style: OutlinedButton.styleFrom(
                  backgroundColor: _isSelected[index]
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent),
              child: Text(
                  "${_presetClockSettings[index].startTime} + ${_presetClockSettings[index].incrementTime}"),
            );
          },
        ),
      ),
    );
  }
}
