import 'package:flame/components.dart';
import 'game.dart';

class GameBackground extends SpriteComponent with HasGameRef<MonsterGame> {
  GameBackground() : super(size: Vector2(544, 232), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    position.x = 0;
    position.y = 200;
    priority = -1;
    print(position);
    final platformImage = game.images.fromCache('parallax-mountain.png');
    sprite = Sprite(platformImage);
  }
}
