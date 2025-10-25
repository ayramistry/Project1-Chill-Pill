import 'package:flutter/material.dart';
import '../data/quotes.dart';

class AffirmationScreen extends StatefulWidget {
  const AffirmationScreen({Key? key}) : super(key: key);

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen> {
  int _index = 0;

  void _nextQuote() {
    setState(() {
      _index = (_index + 1) % quotes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Affirmations")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "“${quotes[_index]}”",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _nextQuote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[200],
                ),
                child: const Text("Show Another"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
