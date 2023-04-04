import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../game.dart';

class AttackBox extends SpriteAnimationComponent with HasGameRef<MonsterGame> {
  AttackBox(
      {required this.type,
      this.direction,
      this.speed = 0,
      this.animationPath,
      required this.damage})
      : super(size: Vector2(64, 64));
  final String type;
  final Vector2? direction;
  final String? animationPath;
  final double speed;
  final int damage;
  late SpriteAnimation? fadeAnimation;
  RectangleHitbox hitBox = RectangleHitbox(
    size: Vector2(60, 20),
    position: Vector2(50, 50),
  )..collisionType = CollisionType.passive;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(hitBox);
    animation = animationPath != null
        ? SpriteAnimation.fromFrameData(
            await gameRef.images.load('$animationPath.png'),
            SpriteAnimationData.sequenced(
              amount: 6,
              textureSize: Vector2.all(64),
              stepTime: 0.5,
            ),
          )
        : null;
    fadeAnimation = animationPath != null
        ? SpriteAnimation.fromFrameData(
            await gameRef.images.load('$animationPath-fade.png'),
            SpriteAnimationData.sequenced(
                amount: 3,
                textureSize: Vector2.all(64),
                stepTime: 0.2,
                loop: false),
          )
        : null;
    Future.delayed(const Duration(milliseconds: 3200), () {
      removeFromParent();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (direction != null) {
      position -= direction! * speed;
    }
  }

  void removeAttackBox() {
    remove(hitBox);
    animation = fadeAnimation;
    animation?.completed.then((value) => removeFromParent());
  }
}
