import '../monster.dart';
import 'package:flame/components.dart';

class DeathMonster extends Monster {
  void Function()? onMonsterDefeated;
  DeathMonster({
    String? monsterAnimationPath,
    Vector2? position,
    int? attackNumber,
    double? attackRange,
    this.onMonsterDefeated,
    int? hitPoint,
  }) : super(
          level: 1,
          type: 'DeathMonster',
          monsterAnimationPath: monsterAnimationPath ?? 'DeathMonster0',
          attackSpeed: 1,
          attackNumber: attackNumber ?? 3,
          position: position,
          attackRange: Vector2(attackRange ?? 60, 50),
          hitPoint: hitPoint ?? 10,
        );

  @override
  void wander(double dt) {
    position += direction * speed * dt;
    direction = Vector2(-1, 0);
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
