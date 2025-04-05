import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  const SnakeGame({Key? key}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int squaresPerRow = 20;
  static const int squaresPerCol = 40;
  static const double boardSize = 320;
  static const double cellSize = boardSize / squaresPerRow;
  static const Duration speed = Duration(milliseconds: 200);

  int score = 0;
  bool gameOver = false;
  Direction direction = Direction.right;
  List<Offset> snakePositions = [];
  Offset? food;
  Timer? timer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      snakePositions = [
        const Offset(5, 10),
        const Offset(4, 10),
        const Offset(3, 10),
      ];
      score = 0;
      direction = Direction.right;
      gameOver = false;
      _generateFood();
    });

    timer = Timer.periodic(speed, (timer) {
      _updateSnake();
    });
  }

  void _generateFood() {
    int x = random.nextInt(squaresPerRow.toInt());
    int y = random.nextInt(squaresPerCol.toInt());
    food = Offset(x.toDouble(), y.toDouble());

    // Make sure food is not generated where the snake is
    for (Offset position in snakePositions) {
      if (position.dx == food!.dx && position.dy == food!.dy) {
        _generateFood();
        break;
      }
    }
  }

  void _updateSnake() {
    if (gameOver) {
      return;
    }

    setState(() {
      _moveSnake();
      _checkCollision();
      _checkFoodCollision();
    });
  }

  void _moveSnake() {
    Offset head = snakePositions.first;
    Offset newHead;

    switch (direction) {
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
    }

    snakePositions.insert(0, newHead);
    snakePositions.removeLast();
  }

  void _checkCollision() {
    Offset head = snakePositions.first;

    // Check wall collision
    if (head.dx < 0 ||
        head.dx >= squaresPerRow ||
        head.dy < 0 ||
        head.dy >= squaresPerCol) {
      _endGame();
      return;
    }

    // Check self collision
    for (int i = 1; i < snakePositions.length; i++) {
      if (head.dx == snakePositions[i].dx && head.dy == snakePositions[i].dy) {
        _endGame();
        return;
      }
    }
  }

  void _checkFoodCollision() {
    if (food != null &&
        snakePositions.first.dx == food!.dx &&
        snakePositions.first.dy == food!.dy) {
      snakePositions.add(snakePositions.last);
      score += 10;
      _generateFood();
    }
  }

  void _endGame() {
    setState(() {
      gameOver = true;
    });
    timer?.cancel();
  }

  void _changeDirection(Direction newDirection) {
    // Prevent 180-degree turns
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    direction = newDirection;
  }

  void _handleSwipe(DragUpdateDetails details) {
    if (details.delta.dx.abs() > details.delta.dy.abs()) {
      if (details.delta.dx > 0) {
        _changeDirection(Direction.right);
      } else {
        _changeDirection(Direction.left);
      }
    } else {
      if (details.delta.dy > 0) {
        _changeDirection(Direction.down);
      } else {
        _changeDirection(Direction.up);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'النقاط: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: GestureDetector(
            onPanUpdate: _handleSwipe,
            child: Container(
              width: boardSize,
              height: boardSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                color: Colors.grey[900],
              ),
              child: CustomPaint(
                painter: SnakeGamePainter(
                  snakePositions: snakePositions,
                  food: food,
                  cellSize: cellSize,
                ),
              ),
            ),
          ),
        ),
        if (gameOver)
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Column(
              children: [
                const Text(
                  'انتهت اللعبة!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('إعادة اللعب'),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _changeDirection(Direction.left),
                child: const Icon(Icons.arrow_back),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _changeDirection(Direction.up),
                    child: const Icon(Icons.arrow_upward),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _changeDirection(Direction.down),
                    child: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _changeDirection(Direction.right),
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SnakeGamePainter extends CustomPainter {
  final List<Offset> snakePositions;
  final Offset? food;
  final double cellSize;

  SnakeGamePainter({
    required this.snakePositions,
    required this.food,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw snake
    Paint snakePaint = Paint()..color = Colors.green;
    for (int i = 0; i < snakePositions.length; i++) {
      Offset position = snakePositions[i];

      // Make the head a different color
      if (i == 0) {
        snakePaint.color = Colors.lightGreen;
      } else {
        snakePaint.color = Colors.green;
      }

      canvas.drawRect(
        Rect.fromLTWH(
          position.dx * cellSize,
          position.dy * cellSize,
          cellSize,
          cellSize,
        ),
        snakePaint,
      );
    }

    // Draw food
    if (food != null) {
      Paint foodPaint = Paint()..color = Colors.red;
      canvas.drawCircle(
        Offset(
          food!.dx * cellSize + cellSize / 2,
          food!.dy * cellSize + cellSize / 2,
        ),
        cellSize / 2.5,
        foodPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
