import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'next_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _float1;
  late Animation<double> _float2;
  late Animation<double> _float3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _float1 = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _float2 = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _float3 = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 🌸 Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
              ),
            ),
          ),

          // 🌕 Floating dots (animated)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                    top: 180 + _float1.value,
                    left: 50,
                    child: _buildCircle(
                      45,
                      Colors.purple.shade100.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: 230 - _float2.value,
                    right: 40,
                    child: _buildCircle(
                      60,
                      Colors.purple.shade200.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 260 + _float3.value,
                    left: 70,
                    child: _buildCircle(35, Colors.white.withOpacity(0.3)),
                  ),
                  Positioned(
                    top: 160 - _float1.value / 2,
                    left: 90,
                    child: _buildCircle(
                      15,
                      Colors.purple.shade100.withOpacity(0.25),
                    ),
                  ),
                  Positioned(
                    top: 260 + _float2.value / 3,
                    right: 90,
                    child: _buildCircle(
                      10,
                      Colors.purple.shade200.withOpacity(0.2),
                    ),
                  ),
                  Positioned(
                    bottom: 300 + _float3.value / 2,
                    left: 100,
                    child: _buildCircle(10, Colors.white.withOpacity(0.25)),
                  ),
                  Positioned(
                    bottom: 320 - _float1.value / 3,
                    right: 130,
                    child: _buildCircle(
                      14,
                      Colors.purple.shade100.withOpacity(0.2),
                    ),
                  ),
                ],
              );
            },
          ),

          // 🟣 Purple block under girl
          Positioned(
            top: MediaQuery.of(context).size.height * 0.39,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: const BoxDecoration(
                color: Color(0xFF7C4DFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
              ),
            ),
          ),

          // 💗 Pink wave under girl
          Positioned(
            top: MediaQuery.of(context).size.height * 0.50, // adjust as needed
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: PinkWaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(color: Color(0xFFFED4E7)),
              ),
            ),
          ),

          // 🧘 Girl illustration
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            child: Image.asset('assets/girl.png', height: 320),
          ),

          // ✨ Text and button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 240,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your calm space",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Track your mood, practice mindfulness, and find balance in your daily routine.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(WavePageRoute(page: const NextScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4C2F0),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 14,
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "Next",
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

  Widget _buildCircle(double size, Color color) => Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: 6,
          spreadRadius: 0.5,
        ),
      ],
    ),
  );
}

// 🌊 Wave transition (kept clean)
class WavePageRoute extends PageRouteBuilder {
  final Widget page;

  WavePageRoute({required this.page})
    : super(
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (animation.status == AnimationStatus.dismissed) {
            return child; // ✅ no pink streak before transition
          }

          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: curved,
                  builder: (context, _) {
                    final height = MediaQuery.of(context).size.height;
                    return ClipPath(
                      clipper: TransitionWaveClipper(curved.value),
                      child: Container(
                        color: const Color(0xFF7C4DFF),
                        height: height,
                      ),
                    );
                  },
                ),
              ),
              FadeTransition(opacity: curved, child: child),
            ],
          );
        },
      );
}

class TransitionWaveClipper extends CustomClipper<Path> {
  final double progress;
  TransitionWaveClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 80.0 * progress;
    final controlY = size.height * (1 - progress);
    path.moveTo(0, size.height);
    path.lineTo(0, controlY);
    path.quadraticBezierTo(
      size.width / 4,
      controlY - waveHeight,
      size.width / 2,
      controlY,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      controlY + waveHeight,
      size.width,
      controlY,
    );
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class PinkWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // start from top-left
    path.lineTo(0, size.height * 0.3);

    // first curve
    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.45);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.35);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // second curve
    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.25);
    final secondEndPoint = Offset(size.width, size.height * 0.4);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // complete bottom rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
