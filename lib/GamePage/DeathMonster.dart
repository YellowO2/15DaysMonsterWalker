import 'monster.dart';

class DeathMonster extends Monster {
  DeathMonster({String? monsterAnimationPath})
      : super(
            type: 'DeathMonster',
            monsterAnimationPath: monsterAnimationPath ?? 'DeathMonster0',
            attackSpeed: 1,
            attackNumber: 3);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  // @override
  // void wander(double delta) {
  //   direction = Vector2(1, 0);
  //   position += direction * speed * delta;
  // }
  // @override
  // void onCollision(Set<Vector2> points, PositionComponent other) {
  //   print('collide');
  //   if (other is DetectionBox) {
  //     print('detect');
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
