import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'package:flame/collisions.dart';

import 'monster.dart';

class LifeMonster extends Monster {
  LifeMonster() : super(type: 'LifeMonster');

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
