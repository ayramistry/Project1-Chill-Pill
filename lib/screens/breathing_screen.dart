import 'package:flutter/material.dart';
import 'dart:math' as math;

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({Key? key}) : super(key: key);

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatController;
  late Animation<double> _float1, _float2, _float3;
  late Animation<double> _scaleAnimation;
  late List<_BreathPhase> _phases;
  int _currentPhase = 0;
  String _phaseText = "Breathe In...";
  int _countdown = 4;

  @override
  void initState() {
    super.initState();

    // Floating dots controller
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

    // Breathing phases (4-7-8)
    _phases = [
      _BreathPhase("Breathe In...", 4, 0.9, 1.15), // expand
      _BreathPhase("Hold...", 7, 1.15, 1.15), // pause
      _BreathPhase("Breathe Out...", 8, 1.15, 0.9), // contract
    ];

    _setupController();
    _startPhase();
  }

  void _setupController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _phases[_currentPhase].duration),
    );

    final phase = _phases[_currentPhase];
    _scaleAnimation = Tween<double>(
      begin: phase.startScale,
      end: phase.endScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _startPhase() {
    final phase = _phases[_currentPhase];
    setState(() {
      _phaseText = phase.text;
      _countdown = phase.duration;
    });

    _setupController();
    _controller.forward(from: 0);

    Future.doWhile(() async {
      if (_countdown <= 0) return false;
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _countdown--);
      return _countdown > 0;
    }).then((_) {
      _currentPhase = (_currentPhase + 1) % _phases.length;
      _startPhase();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
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
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFED4E7), Color(0xFFF8EFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 🌕 Floating dots background
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

                // 🌸 Breathing Circle & Text
                Center(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, _) {
                      final scale = _scaleAnimation.value;

                      final glowColor = Color.lerp(
                        const Color(0xFF7CB06D),
                        const Color(0xFFE27429),
                        (math.sin(_controller.value * math.pi) + 1) / 2,
                      )!;

                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withOpacity(0.5),
                                blurRadius: 40,
                                spreadRadius: 12,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: _GradientCirclePainter(),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _phaseText,
                                    style: const TextStyle(
                                      fontFamily: 'Impact',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$_countdown',
                                    style: const TextStyle(
                                      fontFamily: 'Impact',
                                      fontSize: 24,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 🌈 Ombré breathing circle (green → purple → orange)
class _GradientCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFF7CB06D), // green inner
          Color(0xFF9E9EE8), // purple middle
          Color(0xFFE27429), // orange edge
        ],
        stops: [0.2, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius - 4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _BreathPhase {
  final String text;
  final int duration;
  final double startScale;
  final double endScale;

  _BreathPhase(this.text, this.duration, this.startScale, this.endScale);
}
