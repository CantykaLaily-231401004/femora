import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';

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
    return TextField(
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF808080),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(color: Color(0xFFF1F1F1), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(color: Color(0xFFF1F1F1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );
  }
}
