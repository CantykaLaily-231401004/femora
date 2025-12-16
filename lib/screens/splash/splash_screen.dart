import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    // Screen 1: Gradient only
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() => _currentScreen = 1);

    // Screen 2: Logo + tagline (gradient bg)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _currentScreen = 2);

    // Screen 3: Logo + tagline (white bg)
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Check authentication status and navigate
    await _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // User belum login -> ke onboarding
        if (mounted) context.go(AppRoutes.onboarding);
        return;
      }

      // User sudah login, cek apakah sudah setup
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      if (!userDoc.exists) {
        // Document tidak ada -> user baru dari Google Sign In
        // Redirect ke profile setup
        context.go(AppRoutes.profileSetup);
        return;
      }

      final userData = userDoc.data();
      final cycleData = userData?['cycleData'];

      if (cycleData == null) {
        // User sudah login tapi belum setup cycle data
        context.go(AppRoutes.profileSetup);
      } else {
        // User sudah login dan sudah setup
        context.go(AppRoutes.home);
      }
    } catch (e) {
      debugPrint('Error checking auth: $e');
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppDurations.slow,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 1:
        return _SplashScreenTwo(key: const ValueKey('splash2'));
      case 2:
        return _SplashScreenThree(key: const ValueKey('splash3'));
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
    return const FullGradientBackground(
      colors: [
        Color(0xFFF7CAC9),
        Color(0xFFF75270),
      ],
      child: SizedBox.expand(),
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
        Color(0xFFF7CAC9),
        Color(0xFFF75270),
      ],
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.logoWhite,
                width: SizeConfig.getWidth(67),
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
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
              Image.asset(
                AppAssets.logoRed,
                width: SizeConfig.getWidth(67),
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
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