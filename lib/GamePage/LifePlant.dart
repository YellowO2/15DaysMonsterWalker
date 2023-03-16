import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';
import 'monster.dart';
import './components/healthBar.dart';

class LifePlant extends SpriteAnimationComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  double _speed = 100; // pixels per second
  Vector2 _direction = Vector2(1, 0); // start moving right
  int hitPoint;
  String type = 'lifePlant';
  RectangleHitbox hitbox = RectangleHitbox(size: Vector2(20, 20));
  late HealthBar healthBar = HealthBar(health: hitPoint);

  LifePlant({this.hitPoint = 20, Vector2? position})
      : super(size: Vector2.all(50.0), position: position);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('lifePlant.png'),
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    position.y = game.groundLevel.toDouble();
    add(hitbox);
    add(healthBar);
  }

  @override
  void update(double delta) {
    super.update(delta);
    healthBar.health = hitPoint;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is AttackBox) {
      if (other.type == 'DeathMonster') {
        hitPoint -= other.damage;
        healthBar.update(hitPoint.toDouble());
        print('hurt' + hitPoint.toString());
        other.removeAttackBox();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (hitPoint < 15) {}
  }
}
