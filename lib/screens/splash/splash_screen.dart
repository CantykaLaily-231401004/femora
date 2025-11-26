import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/core/widgets/common/gradient_background.dart';

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

  Future<void> _startSplashSequence() async {
    // Screen 1: Gradient only - 1.5 detik
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    
    setState(() => _currentScreen = 1);

    // Screen 2: Logo + tagline (gradient bg) - 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    setState(() => _currentScreen = 2);

    // Screen 3: Logo + tagline (white bg) - 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    // Navigate to onboarding
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppDurations.slow,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 1:
        return const _SplashScreenTwo(key: ValueKey('splash2'));
      case 2:
        return const _SplashScreenThree(key: ValueKey('splash3'));
      default:
        return const _SplashScreenOne(key: ValueKey('splash1'));
    }
  }
}

/// Splash 1: Gradient background saja
class _SplashScreenOne extends StatelessWidget {
  const _SplashScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullGradientBackground(
      colors: const [
        AppColors.primaryLight,
        AppColors.primary,
      ],
      child: const SizedBox.expand(),
    );
  }
}

/// Splash 2: Logo + tagline dengan gradient background
class _SplashScreenTwo extends StatelessWidget {
  const _SplashScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return FullGradientBackground(
      colors: const [
        AppColors.primaryLight,
        AppColors.primary,
      ],
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                AppAssets.logoWhite,
                width: SizeConfig.getWidth(67),
              ),
              
              SizedBox(height: SizeConfig.getHeight(3)),
              
              // Tagline
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(10),
                ),
                child: Text(
                  'Perawatan Pribadi untuk Setiap Siklus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.getFontSize(16),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Splash 3: Logo + tagline dengan white background
class _SplashScreenThree extends StatelessWidget {
  const _SplashScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                AppAssets.logoRed,
                width: SizeConfig.getWidth(67),
              ),
              
              SizedBox(height: SizeConfig.getHeight(3)),
              
              // Tagline
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(10),
                ),
                child: Text(
                  'Perawatan Pribadi untuk Setiap Siklus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: SizeConfig.getFontSize(16),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
