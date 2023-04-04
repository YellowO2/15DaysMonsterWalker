import 'package:flame/game.dart';
import 'components/health_bar.dart';
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
  late HealthBar healthBar = HealthBar(maxHealth: hitPoint, health: hitPoint);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }

  @override
  Map<String, dynamic> toJson() {
    return {'level': level};
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
