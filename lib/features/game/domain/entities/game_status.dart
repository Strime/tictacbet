/// Current status of a game.
enum GameStatus {
  inProgress,
  redWins,
  blackWins,
  draw;

  bool get isGameOver => this != inProgress;
}
