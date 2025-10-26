import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ✅ Import your real feature pages
import 'breathing_screen.dart';
import 'journal_screen.dart';
import 'affirmation_screen.dart';
import 'mood_tracker_screen.dart';
import 'home_screen.dart'; // 👈 added import for navigation back to main home

//
// 🌸 1️⃣ Name input screen
//
class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goToFeaturesPage() {
    if (_nameController.text.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FeaturesOverviewScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌸 Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ⬅️ Back Button to Home
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF7C4DFF),
                  size: 26,
                ),
                onPressed: () {
                  // 👇 Go all the way back to HomeScreen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ),

          // 💬 Input section
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello there!",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "What should we call you?",
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFDE1EB),
                      hintText: "Enter your name",
                      hintStyle: GoogleFonts.nunito(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFF7A4C3),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFF7A4C3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _goToFeaturesPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7A4C3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// 🌷 2️⃣ Personalized features overview
//
class FeaturesOverviewScreen extends StatelessWidget {
  final String userName;
  const FeaturesOverviewScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        'title': 'Breathing',
        'icon': Icons.air,
        'color': const Color(0xFF7C4DFF),
        'page': const BreathingScreen(),
      },
      {
        'title': 'Affirmations',
        'icon': Icons.wb_sunny_rounded,
        'color': const Color(0xFFE27429),
        'page': const AffirmationScreen(),
      },
      {
        'title': 'Journal',
        'icon': Icons.book_rounded,
        'color': const Color(0xFF9E9EE8),
        'page': const JournalScreen(),
      },
      {
        'title': 'Mood',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFF7CB06D),
        'page': const MoodTrackerScreen(),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 🌸 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🌿 Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Hello $userName!",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "What do you want to work on today?",
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 35),

                // 🩷 Grid of features
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.05, // fit 4 on one page
                          ),
                      itemBuilder: (context, index) {
                        final feature = features[index];
                        return _FeatureCard(
                          title: feature['title'],
                          icon: feature['icon'],
                          color: feature['color'],
                          page: feature['page'],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// 💗 Feature Card Widget
//
class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget page;

  const _FeatureCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDE1EB),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFF7A4C3), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.shade100.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
