import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class MovingPath extends StatefulWidget {
  const MovingPath({super.key});

  @override
  State<MovingPath> createState() => _MovingPathState();
}

class _MovingPathState extends State<MovingPath> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotateController;
  late Animation _rotateAnimation;
  late Animation _animation;
  late Path _path;

  @override
  void initState() {
    super.initState();

    //controller for parabola
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animation = Tween(begin: 0.0, end: (1.0)).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    //controller for rotation
    _rotateController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _rotateAnimation =
        Tween(begin: 0.0, end: 12.5664).animate(_rotateController)
          ..addListener(() {
            setState(() {});
          });

    _path = drawPath();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 4,
            child: CustomPaint(
              painter: PathPainter(_path),
            ),
          ),
          Positioned(
            top: calculate(_animation.value).dy,
            left: calculate(_animation.value).dx,
            child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      width: 50,
                      height: 50,
                    ),
                  );
                }),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: (() {
                    _rotateController.repeat();
                    _controller.repeat();
                  }),
                  child: const Text("Rotate")))
        ],
      ),
    );
  }

  Path drawPath() {
    Size size = const Size(500, 500);
    Path path = Path();
    path.moveTo(100, 50);
    path.quadraticBezierTo(size.width / 2, 0, 400, 500);
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }
}

class PathPainter extends CustomPainter {
  Path path;

  PathPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
