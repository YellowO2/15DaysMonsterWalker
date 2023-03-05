import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

class LifePlant extends SpriteAnimationComponent with HasGameRef<MonsterGame> {
  double _speed = 100; // pixels per second
  Vector2 _direction = Vector2(1, 0); // start moving right

  LifePlant() : super(size: Vector2.all(50.0));

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
    position = gameRef.size / 2;
    position.y = game.groundLevel.toDouble();
  }

  @override
  void update(double delta) {
    super.update(delta);
  }
}
