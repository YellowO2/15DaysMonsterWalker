import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:lifemon/GamePage/game.dart';
import 'game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final MonsterGame _game;

  @override
  void initState() {
    super.initState();
    _game = MonsterGame();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1084 * 1.3,
        height: 232 * 1.3,
        child: GameWidget(game: _game),
      ),
    );
  }
}
