import 'package:femora/services/cycle_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

// Widget untuk menampilkan sapaan dinamis di halaman utama.
class HomeHeader extends StatelessWidget {
  final ValueNotifier<String?> userNameNotifier;

  const HomeHeader({
    Key? key,
    required this.userNameNotifier,
  }) : super(key: key);

  // Fungsi untuk mendapatkan sapaan berdasarkan waktu
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 10) {
      // Pagi dari jam 4-9
      return 'Selamat Pagi';
    }
    if (hour >= 10 && hour < 15) {
      // Siang dari jam 10-14
      return 'Selamat Siang';
    }
    if (hour >= 15 && hour < 18) {
      // Sore dari jam 15-17
      return 'Selamat Sore';
    }
    return 'Selamat Malam'; // Malam dari jam 18-3
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final greeting = _getGreeting();
    final currentUser = FirebaseAuth.instance.currentUser;

    return ValueListenableBuilder<String?>(
      valueListenable: userNameNotifier,
      builder: (context, userName, child) {
        final displayName = (userName != null && userName.isNotEmpty
                ? userName
                : currentUser?.displayName?.split(' ').first) ??
            'Femora User';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $greeting',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.getFontSize(16),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(0.5)),
                Text(
                  '$displayName 👋',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.getFontSize(24),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
