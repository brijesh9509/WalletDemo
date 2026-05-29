import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:brijesh_patel/core/theme.dart';

class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double rotation;
  double rotationSpeed;
  Color color;
  double width;
  double height;
  double opacity;
  bool isActive;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.width,
    required this.height,
    required this.opacity,
    this.isActive = true,
  });

  factory ConfettiParticle.random(math.Random rng, Size screenSize, {Offset? startPosition}) {
    final color = AppColors
        .confettiColors[rng.nextInt(AppColors.confettiColors.length)];
    return ConfettiParticle(
      x: startPosition?.dx ?? (screenSize.width * 0.5 + rng.nextDouble() * 60 - 30),
      y: startPosition?.dy ?? (screenSize.height * 0.15),
      vx: (rng.nextDouble() - 0.5) * 16,
      vy: -(rng.nextDouble() * 20 + 10),
      rotation: rng.nextDouble() * math.pi * 2,
      rotationSpeed: (rng.nextDouble() - 0.5) * 0.4,
      color: color,
      width: rng.nextDouble() * 10 + 6,
      height: rng.nextDouble() * 6 + 4,
      opacity: 1.0,
    );
  }

  void update(double gravity, Size screenSize) {
    x += vx;
    y += vy;
    vy += gravity;
    vx *= 0.99;
    rotation += rotationSpeed;
    if (y > screenSize.height + 100) {
      isActive = false;
    }
  }
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  const ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      if (!p.isActive) continue;
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.width,
            height: p.height,
          ),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;
}
