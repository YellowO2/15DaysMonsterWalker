import 'package:flame/game.dart';
import 'life_monster.dart';
import 'game_background.dart';
import 'DeathMonsters/death_monster.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async' as async_timer;
import 'dart:convert';
import 'DeathMonsters/LazerSpirit.dart';
import 'DeathMonsters/mutatedBat.dart';
import 'dart:math';

class MonsterGame extends FlameGame with HasCollisionDetection {
  MonsterGame(this.setHasBattle, this.levelUp, this.setGameEnd);
  final groundLevel = 230;
  late SharedPreferences prefs;
  late LifeMonster lifeMonster;
  final Function(bool) setHasBattle;
  final Function() setGameEnd;
  void Function() levelUp;
  int enemyCount = 0;
  bool hasBattle = false;
  // late int currentDate;

  void autoSave() async {
    async_timer.Timer.periodic(const Duration(seconds: 160), (timer) {
      prefs.setString('monster', jsonEncode(lifeMonster.toJson()));
    });
  }

  Future<Map<String, dynamic>> getData() async {
    late Map<String, dynamic> monster;
    prefs = await SharedPreferences.getInstance();
    const defaultMonster = {
      'level': 1,
    };
    String? monsterData = prefs.getString('monster');
    if (monsterData != null && monsterData != '') {
      monster = {
        'level': 1,
      };
    } else {
      monster = defaultMonster;
    }

    return monster;
  }

  void resetMonster() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('monster', '');
    prefs.setStringList('trait', []);
  }

  void setGameEndAndResetMonster() {
    resetMonster();
    setGameEnd();
  }

  @override
  Future<void> onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final traitsData = prefs.getStringList('trait') ?? [];
    autoSave();
    await images.loadAll([
      'parallax-mountain-invert.png',
      'monsterNull.png',
      'lifePlant.png',
      'DeathMonster0.png'
    ]);
    lifeMonster = LifeMonster(
        position: Vector2(400, 100),
        level: 1,
        traits: traitsData,
        onMonsterDefeated: setGameEndAndResetMonster);
    final GameBackground gameBackground = GameBackground();

    add(lifeMonster);
    add(gameBackground);
  }

  void onMonsterDefeated() {
    enemyCount -= 1;
  }

  void spawnMonsters() {
    hasBattle = true;
    enemyCount += 1;
    final randNo = Random().nextInt(3);
    DeathMonster newMonster = DeathMonster(
        onMonsterDefeated: onMonsterDefeated, position: Vector2(1100, 100));
    if (randNo == 0) {
      newMonster = LazerSpirit(Vector2(1100, 100), onMonsterDefeated);
    } else if (randNo == 1) {
      newMonster = DeathMonster(
          position: Vector2(1100, 100), onMonsterDefeated: onMonsterDefeated);
    } else if (randNo == 2) {
      newMonster = MutatedBat(
          onMonsterDefeated: onMonsterDefeated, position: Vector2(1100, 60));
    }
    add(newMonster);
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

  void addTrait(String newTrait) {
    lifeMonster.addTrait(newTrait);
  }
}
