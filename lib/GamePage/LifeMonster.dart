import 'package:flame/game.dart';

import 'monster.dart';

class LifeMonster extends Monster {
  LifeMonster({Vector2? position})
      : super(
            type: 'LifeMonster',
            monsterAnimationPath: 'monsterNull',
            attackSpeed: 1,
            attackNumber: 5,
            position: position);
  // @override
  // void wander(double delta) {
  //   position += direction * speed * delta;
  //   direction = Vector2(1, 0);
  // }
}
