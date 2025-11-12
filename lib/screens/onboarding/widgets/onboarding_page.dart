import 'package:femora/models/onboarding_content.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Illustration
          Container(
            width: 294,
            height: 294,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(content.imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFDC143C),
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            child: Text(
              content.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFDC143C),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.44,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
