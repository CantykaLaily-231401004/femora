import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordField({
    Key? key,
    required this.controller,
    this.hintText = 'Kata Sandi',
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF808080),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          icon: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );
  }
}
