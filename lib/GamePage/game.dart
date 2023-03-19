import 'package:flame/game.dart';
import 'life_monster.dart';
import 'game_background.dart';
import 'life_plant.dart';
import 'death_monster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' as async_timer;

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame();
  final groundLevel = 230;
  late SharedPreferences prefs;
  late LifeMonster lifeMonster;

  @override
  bool debugMode = true;

  void autoSave() async {
    async_timer.Timer.periodic(const Duration(seconds: 10), (timer) {
      prefs.setString('monster', lifeMonster.toJson());
      print('saved');
    });
  }

  Future<String> getData() async {
    prefs = await SharedPreferences.getInstance();
    String monster = prefs.getString('monster') ?? 'no monster';
    return monster;
  }

  @override
  Future<void> onLoad() async {
    String monster = await getData();
    autoSave();
    print(monster);
    await images.loadAll([
      'parallax-mountain-invert.png',
      'monsterNull.png',
      'lifePlant.png',
      'DeathMonster0.png'
    ]);
    lifeMonster = LifeMonster(position: Vector2(400, 100));
    final DeathMonster deathMonster =
        DeathMonster(position: Vector2(1100, 100));
    final GameBackground gameBackground = GameBackground();
    final LifePlant lifePlant = LifePlant();
    final LifePlant lifePlant2 = LifePlant(position: Vector2(600, 100));

    add(lifeMonster);
    add(deathMonster);
    add(gameBackground);
    add(lifePlant);
    add(lifePlant2);
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }
}
