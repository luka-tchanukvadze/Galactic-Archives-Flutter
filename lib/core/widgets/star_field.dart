import 'dart:math';

import 'package:flutter/material.dart';

// Explicit animation: an AnimationController drives the twinkle, so the
// stars slowly fade in and out instead of sitting still.
class StarField extends StatefulWidget {
  const StarField({super.key, this.starCount = 140});

  final int starCount;

  @override
  State<StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<StarField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    // fixed seed so the star layout stays the same between rebuilds.
    final random = Random(42);
    _stars = List.generate(
      widget.starCount,
      (_) => _Star(
        dx: random.nextDouble(),
        dy: random.nextDouble(),
        radius: random.nextDouble() * 1.4 + 0.3,
        phase: random.nextDouble() * pi * 2,
        baseOpacity: random.nextDouble() * 0.5 + 0.3,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) =>
            CustomPaint(painter: _StarPainter(_stars, _controller.value)),
      ),
    );
  }
}

class _Star {
  const _Star({
    required this.dx,
    required this.dy,
    required this.radius,
    required this.phase,
    required this.baseOpacity,
  });

  final double dx;
  final double dy;
  final double radius;
  final double phase;
  final double baseOpacity;
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.stars, this.t);

  final List<_Star> stars;
  final double t; // 0..1 from the controller

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      // wobble the opacity around its base value to fake a twinkle.
      final twinkle = (sin(t * 2 * pi + star.phase) + 1) / 2;
      final opacity = (star.baseOpacity * (0.5 + 0.5 * twinkle)).clamp(
        0.0,
        1.0,
      );
      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(star.dx * size.width, star.dy * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => oldDelegate.t != t;
}
