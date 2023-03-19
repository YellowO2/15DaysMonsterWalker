import 'package:flame/components.dart';
import 'game.dart';
import 'package:flame/collisions.dart';
import 'monster.dart';
import 'components/health_bar.dart';

class LifePlant extends SpriteAnimationComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  final double speed = 100; // pixels per second
  final Vector2 direction = Vector2(1, 0); // start moving right
  int hitPoint;
  String type = 'lifePlant';
  RectangleHitbox hitbox = RectangleHitbox(size: Vector2(20, 20));
  late HealthBar healthBar = HealthBar(maxHealth: hitPoint, health: hitPoint);

  LifePlant({this.hitPoint = 5, Vector2? position})
      : super(size: Vector2.all(50.0), position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('lifePlant.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    position.y = game.groundLevel.toDouble();
    add(hitbox);
    add(healthBar);
  }

  @override
  void update(double dt) {
    super.update(dt);
    healthBar.health = hitPoint;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is AttackBox) {
      if (other.type == 'DeathMonster') {
        hitPoint -= other.damage;
        if (hitPoint <= 0) {
          removeFromParent();
        }
        healthBar.update(hitPoint.toDouble());
        other.removeAttackBox();
      }
    }
  }
}
