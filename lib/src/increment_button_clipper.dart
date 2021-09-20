import 'package:flutter/material.dart';

class IncrementButtonClipper extends CustomClipper<RRect> {
  const IncrementButtonClipper({
    required this.animation,
    required this.borderRadius,
  }) : super(reclip: animation);

  final Animation<double> animation;
  final BorderRadius borderRadius;

  @override
  RRect getClip(Size size) {
    return borderRadius.toRRect(
      Rect.fromLTRB(
        size.width * animation.value,
        0.0,
        size.width,
        size.height,
      ),
    );
  }

  @override
  bool shouldReclip(IncrementButtonClipper oldClipper) => true;
}
