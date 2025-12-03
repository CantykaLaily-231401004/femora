import 'package:flutter/material.dart';

class RecommendationPopup extends StatelessWidget {
  final String header;
  final String message;

  const RecommendationPopup({
    Key? key,
    required this.header,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFDEBD0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 64.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rekomendasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF75270),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              header,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF75270),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 120),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFF75270),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
