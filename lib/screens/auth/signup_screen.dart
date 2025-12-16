import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/auth_header.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/secondary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/social_login_button.dart';
import 'package:provider/provider.dart';
import 'package:femora/provider/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  void _handleGoogleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    bool ok = await auth.loginWithGoogle();

    if (ok) {
      if (!mounted) return;
      context.go('/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.errorMessage)));
    }
  }

  void _showPolicyDialog(String title, List<Widget> content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: content),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          GradientBackground(
            height: SizeConfig.getHeight(45),
            child: const SizedBox(),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: CustomBackButton(onPressed: () => context.pop()),
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(4)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getWidth(4),
                      vertical: SizeConfig.getHeight(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AuthHeader(
                          title: 'Daftar',
                          subtitle: 'Waktunya mengakses akunmu',
                          titleColor: AppColors.primary,
                        ),
                        SizedBox(height: SizeConfig.getHeight(3)),
                        SocialLoginButton(
                          text: 'Lanjutkan dengan Google',
                          iconPath: AppAssets.googleIcon,
                          onPressed: _handleGoogleLogin,
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        PrimaryButton(
                          text: 'Daftar',
                          onPressed: () => context.push('/register'),
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        SecondaryButton(
                          text: 'Masuk',
                          onPressed: () => context.push('/login'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, SizeConfig.getHeight(2)),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: SizeConfig.getFontSize(12),
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                      children: [
                        const TextSpan(text: 'Dengan melanjutkan, Anda menyetujui\n'),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: const TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {
                              _showPolicyDialog('Kebijakan Privasi', _privacyPolicyContent(context));
                            },
                        ),
                        const TextSpan(text: ' dan '),
                        TextSpan(
                          text: 'Syarat & Ketentuan',
                          style: const TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {
                              _showPolicyDialog('Syarat & Ketentuan', _termsAndConditionsContent(context));
                            },
                        ),
                         const TextSpan(text: ' kami'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _privacyPolicyContent(BuildContext context) => [
    _buildSection('Pendahuluan', 'Selamat datang di Femora. Kami menghargai privasi Anda dan berkomitmen melindungi data pribadi Anda. Kebijakan ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan membagikan informasi Anda.'),
    _buildSection('Informasi yang Kami Kumpulkan', 'Kami mengumpulkan informasi yang Anda berikan langsung (nama, email, info siklus) dan informasi teknis perangkat Anda.'),
    _buildSection('Penggunaan Informasi', 'Informasi Anda digunakan untuk personalisasi, prediksi siklus, notifikasi, dan meningkatkan layanan kami.'),
    _buildSection('Keamanan Data', 'Kami menerapkan langkah-langkah keamanan yang wajar untuk melindungi informasi Anda, namun tidak ada metode yang 100% aman.'),
  ];

  List<Widget> _termsAndConditionsContent(BuildContext context) => [
    _buildSection('Penerimaan Persyaratan', 'Dengan menggunakan aplikasi Femora, Anda setuju untuk terikat oleh Syarat & Ketentuan ini. Jika Anda tidak setuju, jangan gunakan aplikasi ini.'),
    _buildSection('Penggunaan Aplikasi', 'Anda setuju untuk menggunakan aplikasi hanya untuk tujuan yang sah dan tidak melanggar hak orang lain. Anda bertanggung jawab penuh atas informasi yang Anda masukkan.'),
    _buildSection('Batasan Tanggung Jawab', 'Aplikasi ini disediakan \'sebagaimana adanya\'. Kami tidak menjamin keakuratan prediksi atau informasi yang diberikan. Aplikasi ini tidak boleh digunakan sebagai pengganti nasihat medis profesional.'),
  ];

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(content, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
