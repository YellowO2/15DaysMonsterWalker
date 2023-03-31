import 'package:flame/game.dart';
import 'life_monster.dart';
import 'game_background.dart';
import 'life_plant.dart';
import 'DeathMonsters/death_monster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' as async_timer;
import 'dart:convert';
import 'DeathMonsters/LazerSpirit.dart';
import 'DeathMonsters/mutatedBat.dart';
import 'dart:math';

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame(this.setHasBattle, this.levelUp, this.traits, this.setGameEnd);
  final groundLevel = 230;
  late SharedPreferences prefs;
  late LifeMonster lifeMonster;
  final Function(bool) setHasBattle;
  final Function() setGameEnd;
  void Function() levelUp;
  int enemyCount = 0;
  bool hasBattle = false;
  late List<String> traits;

  void autoSave() async {
    async_timer.Timer.periodic(const Duration(seconds: 10), (timer) {
      prefs.setString('monster', jsonEncode(lifeMonster.toJson()));
    });
  }

  Future<Map<String, dynamic>> getData() async {
    late Map<String, dynamic> monster;
    prefs = await SharedPreferences.getInstance();
    const defaultMonster = {
      'level': 0,
    };
    String? monsterData = prefs.getString('monster');
    if (monsterData != null) {
      monster = jsonDecode(monsterData);
    } else {
      monster = defaultMonster;
    }

    return monster;
  }

  @override
  Future<void> onLoad() async {
    Map<String, dynamic> monster = await getData();
    autoSave();
    print("game $monster");
    await images.loadAll([
      'parallax-mountain-invert.png',
      'monsterNull.png',
      'lifePlant.png',
      'DeathMonster0.png'
    ]);
    lifeMonster = LifeMonster(
        position: Vector2(400, 100),
        level: monster['level'],
        traits: traits,
        onMonsterDefeated: setGameEnd);
    final DeathMonster deathMonster =
        DeathMonster(position: Vector2(1100, 100));
    final GameBackground gameBackground = GameBackground();
    final LifePlant lifePlant = LifePlant();
    final LifePlant lifePlant2 = LifePlant(position: Vector2(600, 100));

    add(lifeMonster);
    // add(deathMonster);
    add(gameBackground);
    add(lifePlant);
    add(lifePlant2);
    // add(lazerSpirit);
    // add(mutatedBat);
  }

  void onMonsterDefeated() {
    enemyCount -= 1;
  }

  void spawnMonsters() {
    hasBattle = true;
    enemyCount += 1;
    final randNo = Random().nextInt(3);
    DeathMonster newMonster =
        DeathMonster(onMonsterDefeated: onMonsterDefeated);
    ;
    if (randNo == 0) {
      newMonster = LazerSpirit(Vector2(800, 100), onMonsterDefeated);
    } else if (randNo == 1) {
      newMonster = DeathMonster(onMonsterDefeated: onMonsterDefeated);
    } else if (randNo == 2) {
      newMonster = MutatedBat(
          onMonsterDefeated: onMonsterDefeated, position: Vector2(800, 100));
    }

    //MutatedBat(Vector2(1000, 100));
    if (newMonster != null) {
      add(newMonster);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (enemyCount == 0 && hasBattle) {
      hasBattle = false;
      setHasBattle(false);
      lifeMonster.levelUp();
      levelUp();
      prefs.setString('monster', jsonEncode(lifeMonster.toJson()));
    }
  }

  @override
  void onRemove() {
    super.onRemove();
  }
}
