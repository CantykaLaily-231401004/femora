import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/setup_progress_indicator.dart';
import 'package:femora/widgets/size_config.dart';

class SetupLoadingScreen extends StatefulWidget {
  const SetupLoadingScreen({Key? key}) : super(key: key);

  @override
  State<SetupLoadingScreen> createState() => _SetupLoadingScreenState();
}

class _SetupLoadingScreenState extends State<SetupLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startLoadingAndNavigate();
  }

  void _startLoadingAndNavigate() async {
    // Simulate a network request or data processing
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to the home screen after loading is complete
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: SizeConfig.getHeight(4)),
            const SetupProgressIndicator(currentStep: 6, totalSteps: 6),
            const Spacer(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  SizedBox(height: SizeConfig.getHeight(3)),
                  Text(
                    'Menganalisis data Anda...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.getFontSize(18),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
