import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/core/widgets/buttons/custom_back_button.dart';
import 'package:femora/core/widgets/buttons/primary_button.dart';
import 'package:femora/core/widgets/buttons/secondary_button.dart';
import 'package:femora/core/widgets/common/gradient_background.dart';
import 'package:femora/screens/auth/widgets/auth_header.dart';
import 'package:femora/screens/auth/widgets/social_login_button.dart';
import 'package:femora/screens/auth/widgets/auth_footer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isGoogleLoading = false;
  bool _isSignUpLoading = false;

  void _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    
    // TODO: Implementasi Google Sign In
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isGoogleLoading = false);
      // Navigate to home atau tampilkan error
    }
  }

  void _handleSignUp() async {
    setState(() => _isSignUpLoading = true);
    
    // Navigasi ke halaman form daftar
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() => _isSignUpLoading = false);
      context.push(AppRoutes.register);
    }
  }

  void _handleSignIn() {
    context.push(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Gradient Background
          Positioned(
            left: 0,
            top: 0,
            child: GradientBackground(
              height: SizeConfig.getHeight(60),
              child: const SizedBox(),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(5),
                ),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.getHeight(7)),

                    // Back Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomBackButton(
                        onPressed: () => context.pop(),
                      ),
                    ),

                    SizedBox(height: SizeConfig.getHeight(2.5)),

                    // White Card Container
                    _buildAuthCard(),

                    SizedBox(height: SizeConfig.getHeight(4)),

                    // Footer Links
                    const AuthFooter(),
                    
                    SizedBox(height: SizeConfig.getHeight(2.5)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getWidth(4),
        vertical: SizeConfig.getHeight(2.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          const AuthHeader(
            title: 'Daftar',
            subtitle: 'Waktunya mengakses akunmu',
          ),

          SizedBox(height: SizeConfig.getHeight(2.5)),

          // Google Sign In Button
          SocialLoginButton(
            text: 'Lanjutkan dengan Google',
            iconPath: AppAssets.googleIcon,
            onPressed: _handleGoogleSignIn,
            isLoading: _isGoogleLoading,
          ),

          SizedBox(height: SizeConfig.getHeight(4)),

          // Daftar Button
          PrimaryButton(
            text: 'Daftar',
            onPressed: _handleSignUp,
            isLoading: _isSignUpLoading,
          ),

          SizedBox(height: SizeConfig.getHeight(2)),

          // Masuk Button
          SecondaryButton(
            text: 'Masuk',
            onPressed: _handleSignIn,
          ),
        ],
      ),
    );
  }
}
