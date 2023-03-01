import 'package:flame/game.dart';
import 'LifeMonster.dart';

class MonsterGame extends FlameGame {
  MonsterGame();

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'monsterNull.png',
    ]);
    final LifeMonster _lifeMonster = LifeMonster();
    add(_lifeMonster);

    // empty
  }
}
