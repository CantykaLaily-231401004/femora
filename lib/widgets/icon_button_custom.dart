import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;
  final double size;

  const CustomIconButton({
    Key? key,
    required this.iconPath,
    required this.onPressed,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xFFF1F1F1),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          iconPath,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
