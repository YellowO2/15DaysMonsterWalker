import 'package:flame/components.dart';
import 'game.dart';

class GameBackground extends SpriteComponent with HasGameRef<MonsterGame> {
  GameBackground()
      : super(size: Vector2(1084 * 1.3, 232 * 1.3), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    position.x = 0;
    position.y = 232 * 1.3;
    priority = -1;
    final platformImage = game.images.fromCache('parallax-mountain-invert.png');
    sprite = Sprite(platformImage);
  }
}
