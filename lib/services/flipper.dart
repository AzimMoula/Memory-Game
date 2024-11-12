import 'dart:math';
import 'package:flutter/material.dart';

class Flipper extends StatefulWidget {
  const Flipper({
    super.key,
    required this.front,
    required this.back,
    this.reverse = false,
    this.flippable = true,
  });

  final Widget front;
  final Widget back;
  final bool reverse;
  final bool flippable;

  @override
  State<Flipper> createState() => FlipperState();
}

class FlipperState extends State<Flipper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double p;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    p = widget.reverse ? -pi : pi;
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flippable ? flipCard : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double rotationAngle = _animation.value * p;
          bool showFront =
              widget.reverse ? rotationAngle >= p / 2 : rotationAngle <= p / 2;

          return Stack(
            children: [
              // Back side with additional 180-degree rotation to prevent mirroring
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotationAngle + (showFront ? 0 : pi)),
                child: showFront ? const SizedBox.shrink() : _buildBack(),
              ),
              // Front side
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(rotationAngle),
                child: showFront ? _buildFront() : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return widget.front;
  }

  Widget _buildBack() {
    return widget.back;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
