import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final List<MoodEntry> _moodEntries = [];
  String? _selectedMood;

  final List<String> moods = ["😊", "😐", "😞", "😤", "🥰"];

  void _saveMood() {
    if (_selectedMood == null) return;

    setState(() {
      _moodEntries.add(MoodEntry(mood: _selectedMood!, date: DateTime.now()));
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Mood saved temporarily!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "How are you feeling today?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 15,
              children: moods.map((emoji) {
                return ChoiceChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 24)),
                  selected: _selectedMood == emoji,
                  onSelected: (selected) {
                    setState(() {
                      _selectedMood = selected ? emoji : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveMood,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200],
              ),
              child: const Text("Save Mood"),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _moodEntries.length,
                itemBuilder: (context, index) {
                  final entry = _moodEntries[index];
                  return ListTile(
                    leading: Text(
                      entry.mood,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      "${entry.date.month}/${entry.date.day}/${entry.date.year}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
