import 'package:flame/game.dart';
import 'components/health_bar.dart';
import 'monster.dart';

class LifeMonster extends Monster {
  late List<String> traits;
  void Function()? onMonsterDefeated;
  LifeMonster(
      {Vector2? position,
      required int level,
      required this.traits,
      required this.onMonsterDefeated})
      : super(
          level: level,
          type: 'LifeMonster',
          monsterAnimationPath: 'monsterNull',
          attackSpeed: 1,
          attackNumber: 5,
          position: position,
          hitPoint: 15,
        );
  late HealthBar healthBar = HealthBar(maxHealth: hitPoint, health: hitPoint);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(healthBar);
    print('my m level $level');
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
    print('life monster lvl up');
    level += 1;
  }

  @override
  void onRemove() {
    if (onMonsterDefeated != null) {
      onMonsterDefeated!();
    }

    super.onRemove();
  }
}
