import 'dart:math';
import 'dart:async' as async_timer;

import 'package:flame/components.dart';
import 'game.dart';
import 'package:flame/collisions.dart';
import 'components/attackBox.dart';
import 'components/health_bar.dart';

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
  AttackRangeBox({required this.type, required Vector2 attackRange})
      : super(size: attackRange);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(50, 50);
    collisionType = CollisionType.passive;
  }
}

class Monster extends SpriteAnimationGroupComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  late List<String>? traits = [];
  int level;
  final String type;
  double speed = 40; // pixels per second
  Vector2 direction = Vector2(1, 0); // start moving right
  bool isLeft = false;
  int hitPoint;
  late DetectionBox detectBox = DetectionBox(type);
  RectangleHitbox hitbox = RectangleHitbox(size: Vector2(100, 100));
  double attackSpeed;
  int attackNumber;
  final String monsterAnimationPath;
  int withinAttackRange = 0;
  Vector2? attackRange;
  late AttackRangeBox attackRangeBox =
      AttackRangeBox(type: type, attackRange: attackRange ?? Vector2(60, 50));
  late HealthBar healthBar = HealthBar(maxHealth: hitPoint, health: hitPoint);
  bool recover = false;
  int damage;

  Monster({
    required this.type,
    required this.level,
    required this.monsterAnimationPath,
    this.attackSpeed = 2,
    this.attackNumber = 2,
    this.attackRange,
    this.hitPoint = 10,
    this.traits,
    this.damage = 1,
    Vector2? position,
  }) : super(
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
    add(healthBar);

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
    loadTraits();
  }

  @override
  void update(double dt) {
    super.update(dt);
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
        if (recover) {
          if (Random().nextDouble() > 0.80) {
            hitPoint += 1;
          }
        }
        other.removeAttackBox();
        if (hitPoint < 0) {
          onDefeat();
        }
      }
    }
  }

  void onDefeat() {
    removeFromParent();
  }

  void loadTraits() {
    if (traits != null) {
      for (String trait in traits!) {
        switch (trait) {
          case 'hidden':
            break;
          case 'attack':
            damage += 1;
            break;
          case 'recover':
            recover = true;
            break;
          case 'health':
            hitPoint += 3;
            break;
          case 'speed':
            break;
          case 'dodge':
            break;
          case 'attack time':
            break;

          default:
            break;
        }
      }
    }
  }

  void addTrait(String trait) {
    switch (trait) {
      case 'hidden':
        break;
      case 'attack':
        break;
      case 'recover':
        break;
      case 'health':
        hitPoint += 100;
        break;
      default:
        break;
    }
    traits = [trait, ...traits!];
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Monster && other.type != type) {
      if (withinAttackRange > 0) {
        speed = 0.5;
      }
      final difference = (other.center - center).normalized();
      direction.x = difference.x;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Monster) {
      if (other.type != type) {
        exitCombat();
      }
    }
  }

  void wander(double dt) {
    if (withinAttackRange <= 0) {
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
      if (attackRangeBox.collidingWith(other.hitbox)) {
        withinAttackRange += 1;
        if (withinAttackRange == 1) {
          //if first time enemy enter
          setCombatState(true);
          timer = async_timer.Timer.periodic(
              Duration(seconds: attackSpeed.toInt()), (timer) {
            final attackBox =
                AttackBox(type: type, direction: direction, damage: damage);
            add(getAttack(attackBox));
          });
        }
      }
    }
  }

  Component getAttack(Component attackBox) {
    return attackBox;
  }

  void exitCombat() {
    withinAttackRange -= 1;
    if (withinAttackRange == 0) {
      setCombatState(false);
      timer.cancel();
      speed = 100;
    } else if (withinAttackRange < 0) {
      withinAttackRange = 0;
    }
  }

  Map<String, dynamic> toJson() {
    return {'level': level};
  }
}
