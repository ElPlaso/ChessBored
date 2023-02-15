/// Who won a finished game.
enum FinishedGameWinStatus {
  whiteVictory('White wins'),
  blackVictory('Black wins'),
  draw('Draw');

  final String title;
  const FinishedGameWinStatus(this.title);
}
