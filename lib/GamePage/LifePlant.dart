import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

class LifePlant extends SpriteAnimationComponent
    with HasGameRef<MonsterGame>, CollisionCallbacks {
  double _speed = 100; // pixels per second
  Vector2 _direction = Vector2(1, 0); // start moving right
  int hitPoint;

  LifePlant({this.hitPoint = 10, Vector2? position})
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
    add(
      RectangleHitbox(size: Vector2(20, 20)),
    );
  }

  @override
  void update(double delta) {
    super.update(delta);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    print(other);
  }
}
