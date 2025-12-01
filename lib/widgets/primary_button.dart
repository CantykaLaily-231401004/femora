import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final bool isLoading;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.color,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: onPressed != null ? (color ?? AppColors.primary) : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w600,
                  height: 1.20,
                ),
              ),
      ),
    );
  }
}
