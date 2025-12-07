import 'package:flutter/material.dart';

class RecommendationPopup extends StatelessWidget {
  final String header;
  final String message;
  final String? imageName;

  const RecommendationPopup({
    Key? key,
    required this.header,
    required this.message,
    this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 476,
      decoration: const BoxDecoration(
        color: Color(0xFFFDEBD0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 3),
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
                const SizedBox(height: 8),
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
                const Spacer(flex: 2),
                if (imageName != null)
                  Image.asset(
                    'assets/images/$imageName',
                    height: 128,
                  ),
                const Spacer(flex: 2),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFF75270)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
