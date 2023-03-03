import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

class DeathMonster extends SpriteAnimationComponent
    with HasGameRef<MonsterGame> {
  double _speed = 100; // pixels per second
  Vector2 _direction = Vector2(1, 0); // start moving right

  DeathMonster() : super(size: Vector2.all(50.0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('monsterNull.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    position = gameRef.size / 2;
  }

  @override
  void update(double delta) {
    super.update(delta);
    wander(delta);
  }

  void wander(double delta) {
    // Randomly change direction every second
    if (Random().nextInt(100) < 1) {
      _direction = Vector2(Random().nextDouble() * 2 - 1, 0);
    }

    // Update position based on direction and speed
    position += _direction * _speed * delta;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      _direction = Vector2(1, 0);
    } else if (position.x > gameRef.size.x) {
      // position = position.withX(gameRef.size.x);
      _direction = Vector2(-1, 0);
    }
  }

  void Combat(double delta) {
    // Randomly change direction every second
    if (Random().nextInt(100) < 1) {
      _direction = Vector2(Random().nextDouble() * 2 - 1, 0);
    }

    // Update position based on direction and speed
    position += _direction * _speed * delta;

    // Reverse direction if monster reaches screen edge
    if (position.x < 0) {
      _direction = Vector2(1, 0);
    } else if (position.x > gameRef.size.x) {
      // position = position.withX(gameRef.size.x);
      _direction = Vector2(-1, 0);
    }
  }
}
