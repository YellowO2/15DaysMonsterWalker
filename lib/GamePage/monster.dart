import 'dart:math';
import 'dart:async' as asyncTimer;

import 'package:flame/components.dart';
import 'game.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class DetectionBox extends RectangleHitbox {
  final String type;

  DetectionBox(this.type)
      : super(size: Vector2(400, 50), position: Vector2(-150, 0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    collisionType = CollisionType.passive;
  }
}

class AttackRangeBox extends RectangleHitbox {
  final String type;
  AttackRangeBox({required this.type, Vector2? attackRange})
      : super(size: attackRange ?? Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(50, 50);
    collisionType = CollisionType.passive;
  }
}

class AttackBox extends PositionComponent {
  AttackBox(this.type);
  final String type;
  final int damage = 1;
  RectangleHitbox hitBox =
      RectangleHitbox(size: Vector2(50, 20), position: Vector2(50, 50))
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
  bool isLeft = false;
  int hitPoint = 10;
  late DetectionBox detectBox = DetectionBox(type);
  RectangleHitbox hitbox = RectangleHitbox(size: Vector2(100, 100));
  double attackSpeed;
  int attackNumber;
  final String monsterAnimationPath;
  bool withinAttackRange = false;
  Vector2? attackRange;
  late AttackRangeBox attackRangeBox =
      AttackRangeBox(type: type, attackRange: attackRange);
  final List<String> enemyInRange = [];
  final Map priorityMap = {
    'lifePlant': 1,
    'lifeMonster': 0,
  };

  Monster(
      {required this.type,
      required this.monsterAnimationPath,
      this.attackSpeed = 2,
      this.attackNumber = 2,
      this.attackRange,
      Vector2? position})
      : super(
            size: Vector2.all(100.0),
            anchor: Anchor.center,
            position: position);

  void setCombatState(bool state) {
    if (state) {
      current = 3;
    } else {
      current = 1;
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(detectBox);
    add(hitbox);
    add(attackRangeBox);

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
    // position = gameRef.size / 2;
    position.y = game.groundLevel.toDouble() + 5.0;
  }

  @override
  void update(double delta) {
    super.update(delta);
    wander(delta);
    if (direction.x < 0) {
      if (!isLeft) {
        flipHorizontally();
        isLeft = true;
      }
    } else {
      if (isLeft) {
        flipHorizontally();
        isLeft = false;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is Monster) {
      combat(other);
    } else if (other is AttackBox) {
      if (other.type != type) {
        hitPoint -= other.damage;
        // print('$type,$hitPoint');
        other.removeAttackBox();
        if (hitPoint < 0) {
          removeFromParent();
        }
      }
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Monster && other.type != type) {
      if (withinAttackRange) {
        // direction = Vector2(0, 0);
        print('witin at range');
        speed = 0.5;
      }
      direction = (other.position - position).normalized();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    //change this in the future (like the iscombat flag to be a list in future)
    if (other is Monster) {
      if (other.type != type) {
        if (attackRangeBox.collidingWith(other.hitbox)) {
          print('ran');
          exitCombat();
        }
      }
    }
  }

  void wander(double delta) {
    if (!withinAttackRange) {
      if (Random().nextInt(100) < 1) {
        final newX = Random().nextDouble() * 2 - 1;
        direction = Vector2(newX, 0);
      }
    }

    position += direction * speed * delta;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      direction = Vector2(1, 0);
    } else if (position.x > gameRef.size.x) {
      // position = position.withX(gameRef.size.x);
      direction = Vector2(-1, 0);
    }
  }

  late asyncTimer.Timer timer;
  void combat(other) async {
    var shouldAttack = true;
    if (other.type != type) {
      enemyInRange.forEach((enemy) {
        if (priorityMap[enemy] > priorityMap[other.type]) {
          print('change to flase');
          shouldAttack = false;
        }
      });
      enemyInRange.add(other.type);
      if (attackRangeBox.collidingWith(other.hitbox) &&
          !withinAttackRange &&
          shouldAttack) {
        print('attack');
        withinAttackRange = true;
        setCombatState(true);
        timer = asyncTimer.Timer.periodic(
            Duration(seconds: attackSpeed.toInt()), (timer) {
          final attackBox = AttackBox(type);
          add(attackBox);
        });
      }
    }
  }

  void exitCombat() {
    setCombatState(false);
    timer.cancel();
  }
}
