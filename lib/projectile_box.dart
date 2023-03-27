import 'dart:math';

import 'package:flutter/material.dart';

class ProjectileBox extends StatefulWidget {
  const ProjectileBox({super.key});

  @override
  State<ProjectileBox> createState() => _ProjectileBoxState();
}

class _ProjectileBoxState extends State<ProjectileBox>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0,
        upperBound: 1);
    animation = CurvedAnimation(parent: animationController, curve: SineCurve())
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: size.width,
          height: size.height / 2,
          color: Colors.blueGrey,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment:
                    Alignment(animationController.value, animation.value),
                child: Container(
                  height: 50,
                  width: 50,
                  color: Colors.white,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: (() {
                        animationController.forward();
                      }),
                      child: const Text("Rotate")))
            ],
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  @override
  double transformInternal(double t) {
    return sin((-2 * pi * t) * 0.5);
  }
}
