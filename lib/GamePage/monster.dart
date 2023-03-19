import 'dart:math';
import 'dart:async' as async_timer;

import 'package:flame/components.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

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

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(hitBox);
  }

  void removeAttackBox() {
    removeFromParent();
  }
}

class Monster extends SpriteAnimationGroupComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  int level;
  final String type;
  double speed = 100; // pixels per second
  Vector2 direction = Vector2(1, 0); // start moving right
  bool isLeft = false;
  int hitPoint;
  late DetectionBox detectBox = DetectionBox(type);
  RectangleHitbox hitbox = RectangleHitbox(size: Vector2(100, 100));
  double attackSpeed;
  int attackNumber;
  final String monsterAnimationPath;
  bool withinAttackRange = false;
  Vector2? attackRange;
  late AttackRangeBox attackRangeBox =
      AttackRangeBox(type: type, attackRange: attackRange);
  // final List<String> enemyInRange = [];
  // final Map priorityMap = {
  //   'lifePlant': 1,
  //   'lifeMonster': 0,
  // };

  Monster(
      {required this.type,
      required this.level,
      required this.monsterAnimationPath,
      this.attackSpeed = 2,
      this.attackNumber = 2,
      this.attackRange,
      this.hitPoint = 10,
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
    position.y = game.groundLevel.toDouble() + 5.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    level += 1;
    wander(dt);
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
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Monster && other.type != type) {
      if (withinAttackRange) {
        print('witin at range');
        speed = 0.5;
      }
      direction = (other.center - center).normalized();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    //change this in the future (like the iscombat flag to be a list in future)
    if (other is Monster) {
      if (other.type != type) {
        exitCombat();
      }
    }
  }

  void wander(double dt) {
    if (!withinAttackRange) {
      if (Random().nextInt(100) < 1) {
        final newX = Random().nextDouble() * 2 - 1;
        direction = Vector2(newX, 0);
      }
    }

    position += direction * speed * dt;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      direction = Vector2(1, 0);
    } else if (position.x > gameRef.size.x) {
      direction = Vector2(-1, 0);
    }
  }

  late async_timer.Timer timer;
  void combat(other) async {
    // var shouldAttack = true;
    if (other.type != type) {
      // enemyInRange.forEach((enemy) {
      //   if (priorityMap[enemy] > priorityMap[other.type]) {
      //     print('change to flase');
      //     shouldAttack = false;
      //   }
      // });
      // enemyInRange.add(other.type);
      if (attackRangeBox.collidingWith(other.hitbox) && !withinAttackRange) {
        withinAttackRange = true;
        setCombatState(true);
        timer = async_timer.Timer.periodic(
            Duration(seconds: attackSpeed.toInt()), (timer) {
          final attackBox = AttackBox(type);
          add(attackBox);
        });
      }
    }
  }

  void exitCombat() {
    print('exit combatr');
    setCombatState(false);
    withinAttackRange = false;
    timer.cancel();
    speed = 100;
  }

  String toJson() {
    return {'level': level}.toString();
  }
}
