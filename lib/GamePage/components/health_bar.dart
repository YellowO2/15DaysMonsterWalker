import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class HealthBar extends RectangleComponent {
  var health;
  final int maxHealth;
  final Paint? healthBarColor;

  final paintColor = BasicPalette.lightGray.paint();
  late final rectangle = RectangleComponent(
      size: Vector2(health.toDouble(), 10.0),
      position: Vector2(0, 0),
      paint: healthBarColor ?? paintColor,
      priority: 10);
  late final healthBarScale = 100 / maxHealth;

  HealthBar(
      {required this.health,
      this.maxHealth = 10,
      height = 10,
      this.healthBarColor})
      : super(
            paint: BasicPalette.gray.paint(),
            size: Vector2(maxHealth * (100 / maxHealth), 10),
            position: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(rectangle);
  }

  @override
  void update(double dt) {
    super.update(dt);
    rectangle.size = Vector2(health * healthBarScale, 10);
  }
}
