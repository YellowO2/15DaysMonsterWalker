import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

import 'LifeMonster.dart';
import 'monster.dart';

class DeathMonster extends Monster {
  DeathMonster() : super(type: 'DeathMonster');

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final attack = await gameRef.images.load('DeathMonster0-Attack.png');
    final runningAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('DeathMonster0-Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 2,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    final attackAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache('DeathMonster0-Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        textureSize: Vector2.all(128),
        stepTime: 0.12,
      ),
    );
    animations = {1: runningAnimation, 2: runningAnimation, 3: attackAnimation};
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
}
