import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/affirmation_screen.dart';
import 'screens/mood_tracker_screen.dart';
import 'screens/journal_screen.dart';

void main() {
  runApp(MindfulnessApp());
}

class MindfulnessApp extends StatefulWidget {
  @override
  _MindfulnessAppState createState() => _MindfulnessAppState();
}

class _MindfulnessAppState extends State<MindfulnessApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AffirmationScreen(),
    MoodTrackerScreen(),
    JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalmSpace',
      theme: ThemeData(
        primaryColor: Colors.purple[100],
        scaffoldBackgroundColor: Color(0xFFE6E6FA),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              label: 'Affirm',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Mood'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          ],
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
