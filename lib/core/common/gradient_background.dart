import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final double height;

  const GradientBackground({
    Key? key,
    this.height = 494,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF75270),
            Color(0xFFFDEBD0),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
    );
  }
}
