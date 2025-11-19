import 'package:femora/models/onboarding_content.dart';
import 'package:femora/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:femora/screens/onboarding/widgets/onboarding_page.dart';
import 'package:femora/screens/onboarding/widgets/page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data untuk setiap halaman onboarding
  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Lacak Siklusmu dengan Mudah',
      description: 'Tetap pantau periode menstruasimu dengan prediksi dan pengingat yang akurat.',
      imagePath: 'assets/images/onboarding1.png',
    ),
    OnboardingContent(
      title: 'Pahami Tubuhmu Lebih Baik',
      description: 'Catat suasana hati, gejala, dan tingkat energi untuk mendapatkan wawasan yang dipersonalisasi.',
      imagePath: 'assets/images/onboarding2.png',
    ),
    OnboardingContent(
      title: 'Pendamping Kesehatan Pribadimu',
      description: 'Dapatkan tips, pengingat, dan rekomendasi perawatan diri yang dirancang khusus untukmu.',
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Lewati (Skip)
            _buildTopBar(),

            // Konten PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(content: _pages[index]);
                },
              ),
            ),

            // Indikator Halaman
            PageIndicator(currentPage: _currentPage, pageCount: _pages.length),

            const SizedBox(height: 20),

            // Tombol Lanjutkan
            OnboardingNextButton(onPressed: _nextPage),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToNextScreen,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: const Text(
          'Lewati',
          style: TextStyle(
            color: Color(0xFFDC143C),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
