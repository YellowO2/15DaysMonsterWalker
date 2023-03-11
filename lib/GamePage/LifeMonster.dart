import 'monster.dart';

class LifeMonster extends Monster {
  LifeMonster()
      : super(
            type: 'LifeMonster',
            monsterAnimationPath: 'monsterNull',
            attackSpeed: 1,
            attackNumber: 5);

  // @override
  // void onCollision(Set<Vector2> points, PositionComponent other) {
  //   if (other is DetectionBox) {
  //     if (other.type != type) {
  //       other.onCollide(true);
  //     }
  //   } else if (other is AttackBox) {
  //     if (other.type != type) {
  //       hitPoint -= other.damage;
  //       print('hp');
  //       print(hitPoint);
  //     }
  //   }
  // }
}
