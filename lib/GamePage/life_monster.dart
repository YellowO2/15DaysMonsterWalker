import 'package:flame/game.dart';
import 'monster.dart';

class LifeMonster extends Monster {
  void Function() onMonsterDefeated;
  LifeMonster(
      {Vector2? position,
      required int level,
      required traits,
      required this.onMonsterDefeated})
      : super(
            level: level,
            type: 'LifeMonster',
            monsterAnimationPath: 'monsterNull',
            attackSpeed: 1,
            attackNumber: 5,
            position: position,
            hitPoint: 15,
            traits: traits);

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }

  void levelUp() {
    level += 1;
  }

  @override
  void onRemove() {
    onMonsterDefeated();

    super.onRemove();
  }
}
