import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/quotes.dart';

class AffirmationScreen extends StatefulWidget {
  const AffirmationScreen({Key? key}) : super(key: key);

  @override
  State<AffirmationScreen> createState() => _AffirmationScreenState();
}

class _AffirmationScreenState extends State<AffirmationScreen>
    with TickerProviderStateMixin {
  int _index = 0;
  late AnimationController _bgController;
  late AnimationController _floatController;

  void _nextQuote() {
    setState(() {
      _index = (_index + 1) % quotes.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgController, _floatController]),
        builder: (context, _) {
          final color1 = Color.lerp(
              const Color(0xFFF8EFFF), const Color(0xFFFED4E7), _bgController.value)!;
          final color2 = Color.lerp(
              const Color(0xFFFDE1EB), const Color(0xFFE3D7FF), _bgController.value)!;

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color1, color2],
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
                top: 120 + math.sin(_floatController.value * math.pi) * 15,
                left: 50,
                child: _glowOrb(70, Colors.purple.shade100.withOpacity(0.25)),
              ),
              Positioned(
                top: 300 - math.sin(_floatController.value * math.pi) * 20,
                right: 40,
                child: _glowOrb(90, Colors.pink.shade100.withOpacity(0.3)),
              ),
              Positioned(
                bottom: 180 + math.sin(_floatController.value * math.pi) * 25,
                left: 80,
                child: _glowOrb(60, Colors.white.withOpacity(0.25)),
              ),

         
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 800),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(scale: anim, child: child),
                          ),
                          child: Text(
                            "“${quotes[_index]}”",
                            key: ValueKey<int>(_index),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),


                        ElevatedButton(
                          onPressed: _nextQuote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C4DFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Show Another ✨",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
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


  Widget _glowOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}
