import 'package:flame/game.dart';
import 'package:flame/src/components/core/component.dart';
import '../components/attackBox.dart';
import 'death_monster.dart';

class MutatedBat extends DeathMonster {
  MutatedBat(
      {required Vector2 position, required void Function() onMonsterDefeated})
      : super(
            monsterAnimationPath: 'Mutated_Bat',
            attackNumber: 6,
            position: position,
            attackRange: 320,
            onMonsterDefeated: onMonsterDefeated);

  @override
  Component getAttack(Component attackBox) {
    final attackBox = AttackBox(
        direction: direction,
        speed: 2,
        type: type,
        animationPath: 'darkBall',
        damage: 1);
    return super.getAttack(attackBox);
  }
}
