import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class ExercisePage extends StatefulWidget {
  bool hasBattle;
  final Function(bool) setHasBattle;
  ExercisePage({Key? key, required this.hasBattle, required this.setHasBattle})
      : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late String _status = '?';
  late int _steps = 0;
  late int prevStep = 0;
  bool firstInit = true;
  bool shouldSetPrev = false;
  bool firstBattle = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCount(StepCount event) {
    if (firstInit && shouldSetPrev) {
      setState(() {
        prevStep = event.steps;
      });
    }

    setState(() {
      firstInit = false;
      _steps = event.steps - prevStep;
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _status = 'Error';
    });
  }

  void setPrevStep() async {
    //reset step count if new day
    const String lastResetDateKey = 'last_reset_date';
    DateTime lastResetDate = DateTime.now();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final lastResetDateString = prefs.getString(lastResetDateKey);
    if (lastResetDateString != null) {
      lastResetDate = DateTime.parse(lastResetDateString);
    }
    final now = DateTime.now();
    if (lastResetDate.isBefore(DateTime(now.year, now.month, now.day))) {
      setState(() {
        shouldSetPrev = true;
      });
      lastResetDate = now;
      await prefs.setString(lastResetDateKey, lastResetDate.toIso8601String());
    }
  }

  void initPlatformState() async {
    var status = await Permission.activityRecognition.status;
    if (status.isDenied) {
      await Permission.activityRecognition.request();
    } else {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    setPrevStep();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Target: 5000',
              style: TextStyle(fontSize: 30),
            ),
            const Text(
              'Steps taken:',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              _steps.toString(),
              style: TextStyle(fontSize: 60),
            ),
            const Divider(
              height: 100,
              thickness: 0,
              color: Colors.white,
            ),
            (_steps > 6000)
                ? const Text(
                    'Target reached!',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow),
                  )
                : SizedBox(),
            (_steps > 6000 && firstBattle)
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // saveMonster();
                        setState(() {
                          firstBattle = false;
                        });
                        widget.setHasBattle(true);
                      },
                      child: const Text(
                        'Ready for battle!',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
