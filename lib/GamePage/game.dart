import 'package:flame/game.dart';

import './LifeMonster.dart';
import 'GameBackground.dart';
import 'LifePlant.dart';
import 'DeathMonster.dart';

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame();
  final groundLevel = 200;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'parallax-mountain-invert.png',
      'monsterNull.png',
      'lifePlant.png',
      'DeathMonster0-Idle.png'
    ]);
    final LifeMonster _lifeMonster = LifeMonster();
    final LifeMonster _lifeMonster2 = LifeMonster();
    final DeathMonster _deathMonster = DeathMonster();
    final GameBackground _gameBackground = GameBackground();
    final LifePlant _lifePlant = LifePlant();

    add(_lifeMonster);
    add(_lifeMonster2);
    add(_deathMonster);
    add(_gameBackground);
    add(_lifePlant);

    // empty
  }
}
