import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart'; // for WavePageRoute transition
import 'affirmation_screen.dart';
import 'mood_tracker_screen.dart';
import 'journal_screen.dart';

class CalmHomePage extends StatelessWidget {
  const CalmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.favorite,
        'title': 'Mood Tracker',
        'page': const MoodTrackerScreen(),
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Mindfulness',
        'page': const PlaceholderPage(title: 'Mindfulness'),
      },
      {
        'icon': Icons.wb_sunny,
        'title': 'Affirmations',
        'page': const AffirmationScreen(),
      },
      {
        'icon': Icons.bookmark,
        'title': 'Journal',
        'page': const JournalScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'CalmSpace',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final item = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  WavePageRoute(page: item['page']),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade100.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], color: const Color(0xFF7C4DFF), size: 40),
                    const SizedBox(height: 14),
                    Text(
                      item['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Temporary placeholder until you make the real Mindfulness page
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7C4DFF),
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title — Coming Soon!',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
