/// Who won a finished game.
enum FinishedGameWinStatus {
  whiteVictory('White wins'),
  blackVictory('Black wins'),
  draw('Draw');

  final String name;
  const FinishedGameWinStatus(this.name);
}
