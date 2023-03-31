import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

Random random = new Random();
final allTraits = ['hidden', 'attack', 'recover', 'health'];
Widget renderIcon(String trait) {
  switch (trait) {
    case 'hidden':
      return const Icon(Icons.help_center);
    case 'attack':
      return const Icon(Icons.fitness_center);
    case 'recover':
      return const Icon(Icons.health_and_safety);
    case 'health':
      return const Icon(Icons.favorite_border);
    default:
      return const Icon(Icons.help_center);
  }
}

Widget renderTrait(
    {required void Function(String skill) onPress,
    double? size,
    bool? empty,
    String? traitValue}) {
  final trait = traitValue ?? allTraits[random.nextInt(4)];
  return Container(
    margin: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
        color: Color.fromARGB(255, 77, 73, 73),
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    child: IconButton(
      iconSize: size ?? 40,
      onPressed: () {
        onPress(trait);
      },
      icon: (empty != null) ? SizedBox() : renderIcon(trait),
    ),
  );
}

Column traitSelection(void Function(bool state) setShowTrait,
    void Function(String newTrait) addTrait) {
  void chooseTrait(String skill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setShowTrait(false);
    final trait = prefs.getStringList('trait') ?? [];
    trait.add(skill);
    addTrait(skill);
    prefs.setStringList('trait', trait);
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Level Up! Choose a skill',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      Container(
        color: const Color.fromARGB(200, 95, 81, 81),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            renderTrait(onPress: chooseTrait),
            renderTrait(onPress: chooseTrait),
            renderTrait(onPress: chooseTrait),
          ],
        ),
      ),
    ],
  );
}
