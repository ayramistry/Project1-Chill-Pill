import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/mood_entry.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen>
    with TickerProviderStateMixin {
  final List<MoodEntry> _moodEntries = [];
  String? _selectedMood;
  final List<String> moods = ["😊", "😐", "😞", "😤", "🥰"];

  late AnimationController _floatController;
  late Animation<double> _float1, _float2, _float3;

  @override
  void initState() {
    super.initState();
    _loadSavedMoods();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _float1 = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _float2 = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
    _float3 = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  // ✅ Load saved moods from SharedPreferences
  Future<void> _loadSavedMoods() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('mood_entries');
    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _moodEntries.addAll(
          decoded.map((e) => MoodEntry(
            mood: e['mood'],
            date: DateTime.parse(e['date']),
          )),
        );
      });
    }
  }

  // ✅ Save moods to SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      _moodEntries
          .map((e) => {
                'mood': e.mood,
                'date': e.date.toIso8601String(),
              })
          .toList(),
    );
    await prefs.setString('mood_entries', encoded);
  }

  void _saveMood() {
    if (_selectedMood == null) return;

    setState(() {
      _moodEntries.add(MoodEntry(mood: _selectedMood!, date: DateTime.now()));
    });

    _saveToPrefs(); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🌸 Mood saved!"),
        backgroundColor: Color(0xFF7C4DFF),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Stack(
            children: [
              // 🌸 Background gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF7C4DFF),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              Positioned(
                top: 150 + _float1.value,
                left: 40,
                child: _buildCircle(60, Colors.purple.shade100.withOpacity(0.3)),
              ),
              Positioned(
                top: 280 - _float2.value,
                right: 50,
                child: _buildCircle(80, Colors.pink.shade100.withOpacity(0.3)),
              ),
              Positioned(
                bottom: 180 + _float3.value,
                left: 80,
                child: _buildCircle(50, Colors.white.withOpacity(0.25)),
              ),

              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "How are you feeling today?",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 🥰 Mood choices
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: moods.map((emoji) {
                            final isSelected = _selectedMood == emoji;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedMood = emoji);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? const Color(0xFF7C4DFF)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    emoji,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 40),

                        ElevatedButton(
                          onPressed: _saveMood,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C4DFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Save Mood ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Expanded(
                          child: _moodEntries.isEmpty
                              ? const Text(
                                  "No moods logged yet 🌸",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _moodEntries.length,
                                  itemBuilder: (context, index) {
                                    final entry = _moodEntries[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 6),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.purple.shade100
                                                .withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: const Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            entry.mood,
                                            style:
                                                const TextStyle(fontSize: 28),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            "${entry.date.month}/${entry.date.day}/${entry.date.year}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
