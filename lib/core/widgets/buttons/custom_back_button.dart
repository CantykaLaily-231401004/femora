import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomBackButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}
