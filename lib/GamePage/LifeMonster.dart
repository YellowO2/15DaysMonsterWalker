
import 'package:flame/components.dart';
import 'game.dart';

class LifeMonster extends SpriteAnimationComponent
    with HasGameRef<MonsterGame> {
  LifeMonster()
      : super(
          size: Vector2.all(50.0),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('monsterNull.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    position = gameRef.size / 2;
    // TODO 1
  }

  @override
  void update(double delta) {
    super.update(delta);
    movePlayer(delta);
  }

  void movePlayer(double delta) {
    position.add(Vector2(delta * 5, 0));
  }
}
