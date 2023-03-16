import 'monster.dart';
import 'package:flame/components.dart';
import 'LifePlant.dart';

class DeathMonster extends Monster {
  DeathMonster({String? monsterAnimationPath, Vector2? position})
      : super(
            type: 'DeathMonster',
            monsterAnimationPath: monsterAnimationPath ?? 'DeathMonster0',
            attackSpeed: 1,
            attackNumber: 3,
            position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void wander(double delta) {
    position += direction * speed * delta;
    direction = Vector2(-1, 0);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is LifePlant) {
      super.combat(other);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is LifePlant) {
      if (withinAttackRange) {
        speed = 0.5;
      }
      direction = (other.position - position).normalized();
    }
  }
}
