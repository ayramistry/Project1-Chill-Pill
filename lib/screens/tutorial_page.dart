import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calm_home_page.dart';
import 'home_screen.dart'; // for the WavePageRoute animation

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      body: SafeArea(
        child: Stack(
          children: [
            // ⬅️ Back Button (top-left)
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF7C4DFF),
                  size: 26,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // go back to name screen
                },
              ),
            ),

            // 🌸 Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // 🧘 Title
                  Text(
                    "How CalmSpace Works 🌿",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 📖 Description
                  Text(
                    "Here’s a quick guide to help you get started! Each day you’ll explore small, mindful moments — "
                    "like checking in on your mood, writing short reflections, or reading affirmations that boost your peace of mind.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🪷 Feature list
                  Expanded(
                    child: ListView(
                      children: [
                        _buildFeatureTile(
                          icon: Icons.favorite,
                          title: "Mood Tracker",
                          desc: "Check in daily and reflect on how you feel.",
                        ),
                        _buildFeatureTile(
                          icon: Icons.self_improvement,
                          title: "Mindfulness",
                          desc: "Follow guided breathing and calm activities.",
                        ),
                        _buildFeatureTile(
                          icon: Icons.wb_sunny,
                          title: "Affirmations",
                          desc: "Read a positive quote every day to stay inspired.",
                        ),
                        _buildFeatureTile(
                          icon: Icons.bookmark,
                          title: "Journal",
                          desc: "Write your thoughts and track your growth.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🚀 Continue Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        WavePageRoute(page: const CalmHomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 16,
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "Let’s Begin",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade100.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple.shade400, size: 32),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          desc,
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
