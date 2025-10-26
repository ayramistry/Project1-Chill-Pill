import 'package:flutter/material.dart';

// ✅ Make sure these imports all match your actual file names & folders
import 'screens/home_screen.dart';
import 'screens/affirmation_screen.dart';
import 'screens/mood_tracker_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/breathing_screen.dart';

void main() {
  runApp(const CalmSpaceApp());
}

class CalmSpaceApp extends StatefulWidget {
  const CalmSpaceApp({Key? key}) : super(key: key);

  @override
  _CalmSpaceAppState createState() => _CalmSpaceAppState();
}

class _CalmSpaceAppState extends State<CalmSpaceApp> {
  int _selectedIndex = 0;

  // 🌸 All your app screens in order
  final List<Widget> _screens = const [
    HomeScreen(),
    AffirmationScreen(),
    MoodTrackerScreen(),
    JournalScreen(),
    BreathingScreen(), // 🫁 guided breathing tab
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalmSpace',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Impact', // Apply Impact to all text
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFE6E6FA), // lavender base
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          backgroundColor: const Color(0xFFEDE7F6), // light purple
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny),
              label: 'Affirm',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Mood'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
            BottomNavigationBarItem(
              icon: Icon(Icons.air),
              label: 'Breathing', // 🫁 new breathing tab
            ),
          ],
        ),
      ),
    );
  }
}
