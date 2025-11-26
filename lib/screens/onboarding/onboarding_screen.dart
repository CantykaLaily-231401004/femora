import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/models/onboarding_content.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/screens/onboarding/widgets/onboarding_page.dart';
import 'package:femora/screens/onboarding/widgets/page_indicator.dart';
import 'package:femora/core/widgets/buttons/primary_button.dart';
import 'package:femora/config/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  // Data untuk setiap halaman onboarding
  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: 'Lacak Siklusmu dengan Mudah',
      description: 'Tetap pantau periode menstruasimu dengan prediksi dan pengingat yang akurat.',
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingContent(
      title: 'Pahami Tubuhmu Lebih Baik',
      description: 'Catat suasana hati, gejala, dan tingkat energi untuk mendapatkan wawasan yang dipersonalisasi.',
      imagePath: AppAssets.onboarding2,
    ),
    OnboardingContent(
      title: 'Pendamping Kesehatan Pribadimu',
      description: 'Dapatkan tips, pengingat, dan rekomendasi perawatan diri yang dirancang khusus untukmu.',
      imagePath: AppAssets.onboarding3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

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
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToSignUp();
    }
  }

  void _navigateToSignUp() {
    context.go(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Lewati (Skip)
            _buildSkipButton(),

            // Konten PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return OnboardingPage(content: _pages[index]);
                },
              ),
            ),

            // Indikator Halaman
            PageIndicator(
              currentPage: _currentPage,
              pageCount: _pages.length,
            ),

            SizedBox(height: SizeConfig.getHeight(2.5)),

            // Tombol Lanjutkan
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getWidth(5),
              ),
              child: PrimaryButton(
                text: 'Lanjutkan',
                onPressed: _nextPage,
                width: SizeConfig.getWidth(40),
                height: SizeConfig.getHeight(6.5),
              ),
            ),

            SizedBox(height: SizeConfig.getHeight(6)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToSignUp,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getWidth(6),
            vertical: SizeConfig.getHeight(2),
          ),
        ),
        child: Text(
          'Lewati',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: SizeConfig.getFontSize(16),
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
