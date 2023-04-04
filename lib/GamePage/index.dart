import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:lifemon/GamePage/game.dart';
import 'dart:math';
import 'UI/traitSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GamePage extends StatefulWidget {
  GamePage(
      {required this.hasBattle,
      required this.setHasBattle,
      required this.setGameEnd});
  final bool hasBattle;
  final Function(bool) setHasBattle;
  final Function() setGameEnd;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late MonsterGame _game;
  bool hasBattleStart = false;
  bool showTraitChoice = false;
  late int level = 1;
  late List<String> traits = [];
  late int currentDate = 1;

  @override
  void initState() {
    super.initState();
    _game = MonsterGame(widget.setHasBattle, levelUp, widget.setGameEnd);
    setGame();
  }

  void setGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? monsterData = prefs.getString('monster');
    final trait = prefs.getStringList('trait') ?? [];
    //set start day
    DateTime startDate = DateTime.now();
    final startDateString = prefs.getString('startDate');
    if (startDateString == null) {
      await prefs.setString('startDate', DateTime.now().toString());
    } else {
      startDate = DateTime.parse(startDateString);
    }
    setState(() {
      currentDate = DateTime.now().difference(startDate).inDays;
    });

    if (monsterData != null && monsterData != '') {
      final Map<String, dynamic> monster = jsonDecode(monsterData);
      setState(() {
        level = monster['level'];
      });
    }
    setState(() {
      traits = trait;
    });
  }

  void levelUp() {
    setState(() {
      showTraitChoice = true;
    });
    setState(() {
      level += 1;
    });
  }

  void addTrait(String newTrait) {
    traits = [newTrait, ...traits];
    _game.addTrait(newTrait);
  }

  void setShowTrait(bool state) {
    setState(() {
      showTraitChoice = state;
    });
  }

  List<Widget> renderCurrentTraits() {
    return traits
        .map((trait) =>
            renderTrait(onPress: onTraitClicked, size: 20, traitValue: trait))
        .toList();
  }

  void onTraitClicked(String trait) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1084 * 1.5,
              height: 232 * 1.5,
              child: GameWidget(game: _game),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              //trait choose
              child: showTraitChoice
                  ? traitSelection(setShowTrait, addTrait)
                  : null,
            ),
          ),
          Text(
            'Day $currentDate',
            style: const TextStyle(fontSize: 30, color: Colors.black38),
          )
        ]),
        Text(
          'Level: $level',
          style: const TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 120, 120),
          ),
        ),
        const Text(
          'Traits',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 120, 120),
          ),
        ),
        Container(
          color: const Color.fromARGB(200, 95, 81, 81),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [...renderCurrentTraits()],
          ),
        ),
        // Container(
        //   height: 200,
        //   color: Colors.grey,
        //   child: ListView(
        //     children: const [
        //       Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Text(
        //           'Hello World. This is a longer text that should wrap to multiple lines if it is too long to fit on one line.',
        //           style: TextStyle(
        //             fontSize: 15.0,
        //             color: Colors.black,
        //           ),
        //           softWrap: true,
        //         ),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Text(
        //           'Hello World. This is a longer text that should wrap to multiple lines if it is too long to fit on one line.',
        //           style: TextStyle(
        //             fontSize: 15.0,
        //             color: Colors.black,
        //           ),
        //           softWrap: true,
        //         ),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: Text(
        //           'Hello World. This is a longer text that should wrap to multiple lines if it is too long to fit on one line.',
        //           style: TextStyle(
        //             fontSize: 15.0,
        //             color: Colors.black,
        //           ),
        //           softWrap: true,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //yux remove this
        TextButton(
          onPressed: () {
            _game.spawnMonsters();
            setState(() {
              hasBattleStart = true;
            });
          },
          child: Text('Start battle!'),
        ),
        widget.hasBattle && !hasBattleStart
            ? TextButton(
                onPressed: () {
                  _game.spawnMonsters();
                  setState(() {
                    hasBattleStart = true;
                  });
                },
                child: Text('Start battle!'),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
