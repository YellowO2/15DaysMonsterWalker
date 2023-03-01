import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:lifemon/game.dart';
import '../game.dart';

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
    return GameWidget(game: _game);
  }
}
