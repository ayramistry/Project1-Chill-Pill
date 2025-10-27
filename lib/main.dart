import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CalmSpaceApp());
}

class CalmSpaceApp extends StatelessWidget {
  const CalmSpaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CalmSpace',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Impact',
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFE6E6FA),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),


      home: const HomeScreen(),
    );
  }
}
