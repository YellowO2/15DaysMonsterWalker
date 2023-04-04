import '../monster.dart';
import 'package:flame/components.dart';
import '../life_plant.dart';

class DeathMonster extends Monster {
  void Function()? onMonsterDefeated;
  DeathMonster({
    String? monsterAnimationPath,
    Vector2? position,
    int? attackNumber,
    double? attackRange,
    this.onMonsterDefeated,
  }) : super(
          level: 1,
          type: 'DeathMonster',
          monsterAnimationPath: monsterAnimationPath ?? 'DeathMonster0',
          attackSpeed: 1,
          attackNumber: attackNumber ?? 3,
          position: position,
          attackRange: Vector2(attackRange ?? 60, 50),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
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
      if (withinAttackRange > 0) {
        speed = 0.5;
      }
      final difference = (other.center - center).normalized();
      direction.x = difference.x;
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
  void onRemove() {
    if (onMonsterDefeated != null) {
      onMonsterDefeated!();
    }

    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }
}
