import 'package:flame/game.dart';
import 'components/health_bar.dart';
import 'monster.dart';

class LifeMonster extends Monster {
  LifeMonster({Vector2? position})
      : super(
            level: 2,
            type: 'LifeMonster',
            monsterAnimationPath: 'monsterNull',
            attackSpeed: 3,
            attackNumber: 5,
            position: position,
            hitPoint: 3);
  late HealthBar healthBar = HealthBar(maxHealth: hitPoint, health: hitPoint);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(healthBar);
  }

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }
}
