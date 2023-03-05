import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

class DetectionBox extends PositionComponent {
  final String type;
  final Function onCollide;
  DetectionBox(this.type, this.onCollide);

  Future<void> onLoad() async {
    add(RectangleHitbox(size: Vector2(100, 100))
      ..collisionType = CollisionType.passive);
  }
}

class AttackBox extends PositionComponent {
  AttackBox(this.type);
  double size_x = 0;
  final String type;
  final int damage = 1;
  RectangleHitbox hitBox =
      RectangleHitbox(size: Vector2(20, 20), anchor: Anchor.bottomCenter)
        ..collisionType = CollisionType.passive;
  void changeSize(double newSize) {
    hitBox.size = Vector2(newSize, 20);
  }

  Future<void> onLoad() async {
    add(hitBox);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}

class Monster extends SpriteAnimationGroupComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  final String type;
  double _speed = 100; // pixels per second
  Vector2 _direction = Vector2(1, 0); // start moving right
  bool combatState = false;
  int hitPoint = 10;

  Monster({required this.type})
      : super(size: Vector2.all(100.0), anchor: Anchor.center);
  void setCombatState(bool state) {
    if (state) {
      current = 3;
    } else {
      current = 1;
    }
    combatState = state;
  }

  // bool hasDirectionChanged = true;
  late DetectionBox detectBox;
  late AttackBox attackBox;
  double _attackSpeed = 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //load sprites
    AttackBox attackBox = AttackBox(type);
    detectBox = DetectionBox(type, setCombatState);
    add(detectBox);
    add(attackBox);

    final running = await game.images.fromCache('monsterNull.png');
    final attack = await gameRef.images.load('monsterNull.png');
    final runningAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('monsterNull.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    final attackAnimation = SpriteAnimation.fromFrameData(
      attack,
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: Vector2.all(128),
        stepTime: 0.2,
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
    attackTime += delta;
    super.update(delta);
    wander(delta);
    if (combatState == true) {
      Combat(attackTime);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    print('collide');
    if (other is DetectionBox) {
      print('detect');
      if (other.type != type) {
        other.onCollide(true);
      }
    } else if (other is AttackBox) {
      if (other.type != type) {
        hitPoint -= other.damage;
        print('hp');
        print(hitPoint);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is DetectionBox) {
      other.onCollide(false);
    }
  }

  void wander(double delta) {
    // Randomly change direction every second
    if (Random().nextInt(100) < 1) {
      _direction = Vector2(Random().nextDouble() * 2 - 1, 0);
      flipHorizontally();
    }

    // Update position based on direction and speed
    position += _direction * _speed * delta;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      _direction = Vector2(1, 0);
      flipHorizontally();
    } else if (position.x > gameRef.size.x) {
      // position = position.withX(gameRef.size.x);
      _direction = Vector2(-1, 0);
      flipHorizontally();
    }
  }

  void Combat(double attackTime) {
    _direction = Vector2(0, 0);
    if (attackTime > _attackSpeed) {
      attackBox.changeSize(200);
      // attackBox.size = Vector2(0, 0);
      attackTime = 0;
    }
  }
  //   void Combat() {

  //   Async.Timer _attackTimer = Async.Timer.periodic(Duration(milliseconds: 500), (timer) {
  //     // Toggle the size of the attack hitbox
  //     attackBox.size = attackBox.size.x == 0 ? Vector2(200, 100) : Vector2(0, 0);
  //   });

  // }
}
