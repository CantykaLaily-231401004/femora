import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    Key? key,
    required this.currentPage,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.getWidth(1.3),
          ),
          width: currentPage == index 
              ? SizeConfig.getWidth(7.5) 
              : SizeConfig.getWidth(1.6),
          height: SizeConfig.getHeight(0.75),
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.primaryDark
                : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
