class GameLogic {
  List<String> board = List.filled(9, "");
  String currentPlayer = "O";
  bool gameOver = false;
  String winner = "";
  int circleWins = 0;
  int crossWins = 0;
  int draws = 0;

  /// Reset board
  void resetBoard() {
    board = List.filled(9, "");
    currentPlayer = "O";
    gameOver = false;
    winner = "";
  }

  /// Play move
  bool playMove(int index) {
    if (gameOver || board[index] != "") return false;

    board[index] = currentPlayer;

    if (_checkWinner(currentPlayer)) {
      gameOver = true;
      winner = currentPlayer;
      if (currentPlayer == "O") {
        circleWins++;
      } else {
        crossWins++;
      }
    } else if (!board.contains("")) {
      gameOver = true;
      winner = "Draw";
      draws++;
    } else {
      currentPlayer = currentPlayer == "O" ? "X" : "O";
    }
    return true;
  }

  /// Check if current player wins
  bool _checkWinner(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8], // rows
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8], // cols
      [0, 4, 8],
      [2, 4, 6], // diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }
}
