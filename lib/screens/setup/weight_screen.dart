import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/setup_progress_indicator.dart';
import 'package:femora/widgets/size_config.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  int _selectedWeight = 53;
  final int _minWeight = 10;
  final int _maxWeight = 150;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: CustomBackButton(onPressed: () => context.pop()),
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(2)),
            const SetupProgressIndicator(currentStep: 2, totalSteps: 5),
            const SizedBox(height: 20),
            Text(
              'Beritahu Kami\nBerat Badan Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(28),
                color: AppColors.primary,
                height: 1.3,
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(5)),
            SizedBox(
              height: SizeConfig.getHeight(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.getWidth(30),
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: _selectedWeight - _minWeight,
                      ),
                      itemExtent: 50,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedWeight = index + _minWeight;
                        });
                      },
                      children: List<Widget>.generate(_maxWeight - _minWeight + 1, (int index) {
                        final int currentWeight = index + _minWeight;
                        return Center(
                          child: Text(
                            '$currentWeight',
                            style: TextStyle(
                              color: _selectedWeight == currentWeight
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: _selectedWeight == currentWeight ? 32 : 26,
                              fontWeight: _selectedWeight == currentWeight
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(width: SizeConfig.getWidth(2)),
                  Text(
                    'Kg',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: SizeConfig.getFontSize(22),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.getWidth(5), 20, SizeConfig.getWidth(5), 35),
              child: PrimaryButton(
                text: 'Lanjutkan',
                onPressed: () {
                  context.push(AppRoutes.periodDuration);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
