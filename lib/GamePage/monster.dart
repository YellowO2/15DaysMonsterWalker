import 'dart:math';
import 'dart:async' as asyncTimer;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

class DetectionBox extends PositionComponent {
  final String type;
  DetectionBox(this.type);

  Future<void> onLoad() async {
    add(RectangleHitbox(size: Vector2(100, 100))
      ..collisionType = CollisionType.passive);
  }
}

class AttackBox extends PositionComponent {
  AttackBox(this.type);
  final String type;
  final int damage = 1;
  RectangleHitbox hitBox =
      RectangleHitbox(size: Vector2(200, 20), anchor: Anchor.bottomCenter)
        ..collisionType = CollisionType.passive;
  Future<void> onLoad() async {
    add(hitBox);
  }

  void removeAttackBox() {
    this.removeFromParent();
  }
}

class Monster extends SpriteAnimationGroupComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  final String type;
  double speed = 100; // pixels per second
  Vector2 direction = Vector2(1, 0); // start moving right
  bool combatState = false;
  int hitPoint = 10;
  late DetectionBox detectBox;
  late AttackBox attackBox;
  double attackSpeed;
  int attackNumber;
  final String monsterAnimationPath;

  Monster(
      {required this.type,
      required this.monsterAnimationPath,
      this.attackSpeed = 2,
      this.attackNumber = 2})
      : super(size: Vector2.all(100.0), anchor: Anchor.center);

  void setCombatState(bool state) {
    if (state) {
      current = 3;
    } else {
      current = 1;
    }
    combatState = state;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    detectBox = await DetectionBox(type);
    add(detectBox);
    attackBox = AttackBox(type);
    // add(attackBox);
    add(RectangleHitbox());

    final running = await gameRef.images.load('$monsterAnimationPath.png');
    final attack =
        await gameRef.images.load('$monsterAnimationPath-attack.png');
    final runningAnimation = SpriteAnimation.fromFrameData(
      running,
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(128),
        stepTime: 0.2,
      ),
    );
    final attackAnimation = SpriteAnimation.fromFrameData(
      attack,
      SpriteAnimationData.sequenced(
        amount: attackNumber,
        textureSize: Vector2.all(128),
        stepTime: attackSpeed / attackNumber,
      ),
    );
    animations = {1: runningAnimation, 2: runningAnimation, 3: attackAnimation};
    current = 1;
    position = gameRef.size / 2;
    position.y = game.groundLevel.toDouble() + 5.0;
  }

  double attackTime = 0.0;
  @override
  void update(double delta) {
    super.update(delta);
    attackTime += delta;
    wander(delta);
    if (combatState == true) {
      direction = Vector2(0, 0);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Monster) {
      if (other.type != type) {
        combat();
      }
    } else if (other is AttackBox) {
      if (other.type != type) {
        hitPoint -= other.damage;
        other.removeAttackBox();
        if (hitPoint < 0) {
          this.removeFromParent();
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is DetectionBox) {
      exitCombat();
    }
  }

  void wander(double delta) {
    // Randomly change direction every second
    if (Random().nextInt(100) < 1) {
      final newX = Random().nextDouble() * 2 - 1;
      if (direction.x > 0 && newX < 0) {
        flipHorizontally();
      } else if (direction.x < 0 && newX > 0) {
        flipHorizontally();
      }
      direction = Vector2(newX, 0);
    }

    // Update position based on direction and speed
    position += direction * speed * delta;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      direction = Vector2(1, 0);
      flipHorizontally();
    } else if (position.x > gameRef.size.x) {
      // position = position.withX(gameRef.size.x);
      direction = Vector2(-1, 0);
      flipHorizontally();
    }
  }

  late asyncTimer.Timer timer;
  void combat() async {
    timer = asyncTimer.Timer.periodic(Duration(seconds: attackSpeed.toInt()),
        (timer) {
      add(attackBox);
      setCombatState(true);
      print(type);
      print(hitPoint);
    });
  }

  void exitCombat() {
    setCombatState(false);
    timer.cancel();
  }
}
