import 'package:flame/components.dart';
import 'package:flame/game.dart';
import './LifeMonster.dart';
import 'package:flutter/material.dart';
import 'GameBackground.dart';

class MonsterGame extends FlameGame {
  MonsterGame();

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'parallax-mountain.png',
      'monsterNull.png',
    ]);
    final LifeMonster _lifeMonster = LifeMonster();
    final GameBackground _gameBackground = GameBackground();
    add(_lifeMonster);
    add(_gameBackground);

    // empty
  }
}
