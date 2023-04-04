import 'package:flutter/material.dart';
import 'GamePage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ExcercisePage/index.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var hasBattle = false;
  int _selectedIndex = 0;
  late var monsterData;
  var stepCount = 1;
  bool hasGameEnd = false;

  Widget renderPage() {
    if (_selectedIndex == 0) {
      return GamePage(
        hasBattle: hasBattle,
        setHasBattle: setHasBattle,
        setGameEnd: setGameEnd,
      );
    } else {
      return ExercisePage(
        hasBattle: hasBattle,
        setHasBattle: setHasBattle,
      );
    }
  }

  @override
  void dispose() {
    saveData(monsterData); // save the monster data
    super.dispose();
  }

  void setGameEnd() {
    setState(() {
      hasGameEnd = true;
    });
  }

  void setHasBattle(bool battle) {
    setState(() {
      hasBattle = battle;
    });
  }

  void saveData(String monsterData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('monster', monsterData);
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          useMaterial3: true),
      home: Scaffold(
        body: Container(
          child: !hasGameEnd
              ? renderPage()
              : const Text(
                  'game over',
                  style: TextStyle(fontSize: 100),
                ),
        ),
        bottomNavigationBar: (!hasBattle || _selectedIndex == 1)
            ? BottomNavigationBar(
                backgroundColor: const Color.fromARGB(0, 251, 251, 251),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: onItemTapped,
              )
            : null,
      ),
    );
  }
}
