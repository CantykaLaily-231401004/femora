import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/models/onboarding_content.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/config/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

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
    context.push(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Latar belakang oval dekoratif
          Positioned(
            bottom: -SizeConfig.getHeight(10),
            left: -SizeConfig.getWidth(20),
            right: -SizeConfig.getWidth(20),
            child: Opacity(
              opacity: 0.20,
              child: Container(
                height: SizeConfig.getHeight(35),
                decoration: const ShapeDecoration(
                  color: Color(0xFFF7CAC9),
                  shape: OvalBorder(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildSkipButton(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final content = _pages[index];
                      return Column(
                        children: [
                          const Spacer(flex: 2),
                          // Gambar
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Image.asset(
                                content.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                          // Judul
                          Text(
                            content.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFDC143C),
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(2)),
                          // Deskripsi
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(10)),
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
                           const Spacer(flex: 3), // Spacer untuk mendorong ke atas dari kontrol bawah
                        ],
                      );
                    },
                  ),
                ),
                // Bagian bawah yang statis
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: SizeConfig.getWidth(5),
                  ),
                  child: Column(
                    children: [
                       _buildPageIndicator(),
                        SizedBox(height: SizeConfig.getHeight(4)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(4)),
                          child: PrimaryButton(
                            text: _currentPage == _pages.length - 1 ? 'Mulai Sekarang' : 'Lanjutkan',
                            onPressed: _nextPage,
                          ),
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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
            color: const Color(0xFFDC143C),
            fontSize: SizeConfig.getFontSize(16),
            fontFamily: AppTextStyles.fontFamily,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.48,
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return AnimatedContainer(
          duration: AppDurations.normal,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? const Color(0xFFDC143C)
                : const Color(0xFFF7CAC9),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
