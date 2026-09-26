import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A1F),
            Color(0xFF1A0B33),
            Color(0xFF05060F),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -60,
            left: -40,
            child: _Blob(color: Color(0xFF7B5CFF), size: 340),
          ),
          const Positioned(
            top: 120,
            right: -80,
            child: _Blob(color: Color(0xFFFF3D7F), size: 320),
          ),
          const Positioned(
            top: 380,
            left: -60,
            child: _Blob(color: Color(0xFF00E6C0), size: 300),
          ),
          const Positioned(
            bottom: -60,
            right: 20,
            child: _Blob(color: Color(0xFFFFB020), size: 280),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;

  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.75),
            color.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}
