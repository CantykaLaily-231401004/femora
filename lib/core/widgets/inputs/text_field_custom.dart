import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF808080),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          icon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null,
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );
  }
}
