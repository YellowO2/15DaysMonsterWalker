import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import './LifeMonster.dart';
import 'GameBackground.dart';
import 'LifePlant.dart';

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame();

  @override
  Future<void> onLoad() async {
    await images
        .loadAll(['parallax-mountain.png', 'monsterNull.png', 'lifePlant.png']);
    final LifeMonster _lifeMonster = LifeMonster();
    final GameBackground _gameBackground = GameBackground();
    final LifePlant _lifePlant = LifePlant();

    add(_lifeMonster);
    add(_gameBackground);
    add(_lifePlant);

    // empty
  }
}
