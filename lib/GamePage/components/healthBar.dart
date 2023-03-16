import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class HealthBar extends RectangleComponent {
  var health;
  final int maxHealth;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final paintColor = BasicPalette.red.paint();
  late final rectangle = RectangleComponent(
      size: Vector2(health.toDouble(), 10.0),
      position: Vector2(0, 0),
      paint: paintColor,
      priority: 10);

  HealthBar({
    required this.health,
    this.maxHealth = 10,
    this.height = 10,
    this.backgroundColor = Colors.grey,
    this.foregroundColor = Colors.green,
  }) : super(size: Vector2(maxHealth.toDouble(), 10), position: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(rectangle);
  }

  @override
  void update(double delta) {
    super.update(delta);
    rectangle.size = Vector2(health.toDouble(), 10);
    print('health c' + health.toString());
  }
}
