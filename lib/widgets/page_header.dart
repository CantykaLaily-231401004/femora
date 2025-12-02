
import 'package:femora/widgets/gradient_background.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String userName;

  const PageHeader({Key? key, required this.userName}) : super(key: key);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    }
    if (hour < 15) {
      return 'Selamat Siang';
    }
    if (hour < 18) {
      return 'Selamat Sore';
    }
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    // This widget now provides a full-screen gradient background with the greeting text on top.
    // It's designed to be placed as the first (bottom-most) layer in a Stack.
    return GradientBackground(
      height: MediaQuery.of(context).size.height,
      // No border radius needed for a full-screen background
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${_getGreeting()}',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.normal),
              ),
              Text(
                '$userName 👋',
                style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
