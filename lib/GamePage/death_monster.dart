import 'package:flame/palette.dart';

import 'monster.dart';
import 'package:flame/components.dart';
import 'life_plant.dart';
import 'components/health_bar.dart';

class DeathMonster extends Monster {
  DeathMonster({String? monsterAnimationPath, Vector2? position})
      : super(
            level: 1,
            type: 'DeathMonster',
            monsterAnimationPath: monsterAnimationPath ?? 'DeathMonster0',
            attackSpeed: 1,
            attackNumber: 3,
            position: position);
  late HealthBar healthBar = HealthBar(
      maxHealth: hitPoint,
      health: hitPoint,
      healthBarColor: BasicPalette.black.paint());

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(healthBar);
  }

  @override
  void wander(double dt) {
    position += direction * speed * dt;
    direction = Vector2(-1, 0);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is LifePlant) {
      super.combat(other);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is LifePlant) {
      if (withinAttackRange) {
        speed = 0.5;
      }
      direction = (other.position - position).normalized();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    //change this in the future (like the iscombat flag to be a list in future)
    if (other is LifePlant) {
      exitCombat();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }
}
