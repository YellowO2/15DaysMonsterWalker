import 'package:flutter/material.dart';
import 'GamePage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: const Center(
        child: Text('This is the exercise page'),
      ),
    );
  }
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const GamePage(),
    const ExercisePage()
  ];
  late var monsterData;

  @override
  void dispose() {
    saveData(monsterData); // save the monster data
    super.dispose();
  }

  // Future<String> getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String monster = await prefs.getString('monster') ?? 'no monster';
  //   return monster;
  // }

  void saveData(String monsterData) async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('monster', monsterData);
  }

  // void loadMonster() async {
  //   SharedPreferences.setMockInitialValues({});
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String monster = prefs.getString('monster') ?? 'no monster';
  //   print(monster);
  // }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    // loadMonster();

    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
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
        ),
      ),
    );
  }
}
