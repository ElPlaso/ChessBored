/// Model for a Chess Clock configuration.
class ChessClockSettings {
  final int startTime;
  final int incrementTime;

  ChessClockSettings(this.startTime, this.incrementTime);

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['startTime'] = startTime;
    m['incrementTime'] = incrementTime;

    return m;
  }
}

/// Class for getting the list of predefined clock settings.
class PresetChessClockSettings {
  static List<ChessClockSettings> getList() => <ChessClockSettings>[
        ChessClockSettings(3, 2),
        ChessClockSettings(5, 0),
        ChessClockSettings(5, 3),
        ChessClockSettings(10, 0),
        ChessClockSettings(10, 5),
        ChessClockSettings(15, 10),
      ];
}
