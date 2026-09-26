import 'dart:ui';
import 'package:flutter/material.dart';
import 'pengaturan.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double ketebalanMinimal;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.radius = 32,
    this.ketebalanMinimal = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: preferensiKetebalan,
      builder: (context, nilai, _) {
        return _bangunKartu(nilai < ketebalanMinimal ? ketebalanMinimal : nilai);
      },
    );
  }

  Widget _bangunKartu(double nilai) {
    final sigma = nilai * 30;

    final isiKaca = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.30),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: radius,
            right: radius,
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.85),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: sigma > 0
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: isiKaca,
                )
              : isiKaca,
        ),
      ),
    );
  }
}