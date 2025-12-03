import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class SetupProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SetupProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the indicator
        children: [
          // Progress bars
          Expanded(
            child: Row(
              children: List.generate(totalSteps, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8, // Made the indicator thicker
                    decoration: BoxDecoration(
                      color: index < currentStep
                          ? AppColors.primary
                          : AppColors.primaryLight.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(width: SizeConfig.getWidth(2)), // Reduced the space
          // Step text
          Text(
            '$currentStep/$totalSteps',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.getFontSize(14),
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
