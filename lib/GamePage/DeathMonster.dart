import 'monster.dart';
import 'package:flame/components.dart';

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
}
