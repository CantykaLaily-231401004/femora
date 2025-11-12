import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentScreen = 0;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  void _startSplashSequence() async {
    // Screen 1: Tampil selama 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _currentScreen = 1;
      });
    }

    // Screen 2: Tampil selama 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _currentScreen = 2;
      });
    }

    // Screen 3: Tampil selama 2 detik, lalu navigasi
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 1:
        return _buildSecondSplash();
      case 2:
        return _buildThirdSplash();
      default:
        return _buildFirstSplash();
    }
  }

  // Splash 1: Hanya gradient background
  Widget _buildFirstSplash() {
    return Container(
      key: const ValueKey('splash1'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7CAC9), Color(0xFFF75270)],
        ),
      ),
    );
  }

  // Splash 2: Logo + tagline dengan gradient background
  Widget _buildSecondSplash() {
    return Container(
      key: const ValueKey('splash2'),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7CAC9), Color(0xFFF75270)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo_White.png', // Pastikan path ini benar
                width: 250,
              ),
              const SizedBox(height: 24),
              const Text(
                'Perawatan Pribadi untuk Setiap Siklus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Splash 3: Logo + tagline dengan white background
  Widget _buildThirdSplash() {
    return Container(
      key: const ValueKey('splash3'),
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Logo_Red.png', // Pastikan path ini benar
                width: 250,
              ),
              const SizedBox(height: 24),
              const Text(
                'Perawatan Pribadi untuk Setiap Siklus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF75270),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
