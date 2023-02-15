enum GameResultType {
  checkmate('Checkmate'),
  stalemate('Stalemate'),
  insufficientMaterial('Insufficient Material'),
  threeFoldRepitition('Threefold Repitition'),
  flagged('Time Out');

  final String title;
  const GameResultType(this.title);
}
