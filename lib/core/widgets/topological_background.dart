import 'package:flutter/material.dart';
import '../painters/topological_painter.dart';

class TopologicalBackground extends StatefulWidget {
  final Widget child;
  const TopologicalBackground({super.key, required this.child});

  @override
  State<TopologicalBackground> createState() => _TopologicalBackgroundState();
}

class _TopologicalBackgroundState extends State<TopologicalBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A1A), Color(0xFF1A1A2E)],
            ),
          ),
        ),
        // Animated topological lines
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => RepaintBoundary(
            child: CustomPaint(
              painter: TopologicalPainter(animationValue: _controller.value * 6.28),
              child: const SizedBox.expand(),
            ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}
