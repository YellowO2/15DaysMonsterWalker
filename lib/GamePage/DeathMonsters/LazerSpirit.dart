import 'package:flame/game.dart';

import 'death_monster.dart';

class LazerSpirit extends DeathMonster {
  LazerSpirit(Vector2 position, void Function() onMonsterDefeated)
      : super(
            monsterAnimationPath: 'AncientLaserDude',
            attackNumber: 9,
            position: position,
            onMonsterDefeated: onMonsterDefeated);
}
