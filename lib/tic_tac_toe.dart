import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tictactoe/logic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  final GameLogic _logic = GameLogic();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    _confettiController.play();
  }

  void _handleTap(int index) {
  bool movePlayed = _logic.playMove(index);

  if (movePlayed) {
    setState(() {}); // refresh board only if move was valid
  }

  if (_logic.gameOver) {
    if (_logic.winner != "Draw") {
      _triggerConfetti(); // <-- trigger confetti only if there is a winner
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      _showResultDialog();
    });
  }
}

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_logic.winner == "Draw"
            ? "It's a Draw!"
            : "${_logic.winner} Wins!"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _logic.resetBoard();
              });
              Navigator.of(context).pop();
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TIC TAC TOE",
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "O",
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${_logic.circleWins} Wins",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 32),
                Column(
                  children: [
                    Text(
                      "Draws",
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "${_logic.draws} Draws",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 32),
                Column(
                  children: [
                    Text(
                      "X",
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${_logic.crossWins} Wins",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 48),
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                children: [
                  // Background first (lowest layer)
                  SvgPicture.asset(
                    'board.svg',
                  ),

                  // Then interactive overlay (highest layer)
                  GridView.builder(
                    itemCount: 9,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent, // <- important
                        onTap: () => _handleTap(index),
                        child: Center(
                          child: Text(
                            _logic.board[index],
                            style: GoogleFonts.montserrat(
                              fontSize: 48,
                              fontWeight: FontWeight.w600,
                              color: _logic.board[index] == "O"
                                  ? Colors.cyan
                                  : Colors.indigo,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    left: 150,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      numberOfParticles: 50,
                      gravity: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),
            TextButton(
              onPressed: () {
                setState(() {
                  _logic.resetBoard();
                });
              },
              child: Text(
                "Reset Game",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
          
        ),
        
      ),
    );
  }
}
