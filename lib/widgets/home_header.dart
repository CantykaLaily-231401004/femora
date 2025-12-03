import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userImageUrl;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Selamat Pagi',
              style: TextStyle(
                color: AppColors.white,
                fontSize: SizeConfig.getFontSize(16),
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(0.5)),
            Row(
              children: [
                Text(
                  userName, // Menggunakan nama dari properti
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: SizeConfig.getFontSize(24),
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(width: SizeConfig.getWidth(2)),
                const Text(
                  '👋',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(userImageUrl),
        ),
      ],
    );
  }
}
