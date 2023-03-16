import 'package:flame/game.dart';

import './LifeMonster.dart';
import 'GameBackground.dart';
import 'LifePlant.dart';
import 'DeathMonster.dart';

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame();
  final groundLevel = 200;

  @override
  bool debugMode = true;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'parallax-mountain-invert.png',
      'monsterNull.png',
      'lifePlant.png',
      'DeathMonster0.png'
    ]);
    final LifeMonster _lifeMonster = LifeMonster();
    final DeathMonster _deathMonster =
        DeathMonster(position: Vector2(1100, 100));
    final GameBackground _gameBackground = GameBackground();
    final LifePlant _lifePlant = LifePlant();
    final LifePlant _lifePlant2 = LifePlant(position: Vector2(600, 100));

    // add(_lifeMonster);
    add(_deathMonster);
    add(_gameBackground);
    // add(_lifePlant);
    add(_lifePlant2);
  }
}
