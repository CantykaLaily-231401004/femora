import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userImageUrl;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Hi, Selamat Pagi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 7),
            // TODO: Ganti dengan gambar tangan melambai
            const Text('👋', style: TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }
}
