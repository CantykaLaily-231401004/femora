import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/setup_progress_indicator.dart';
import 'package:femora/widgets/size_config.dart';

class PeriodDurationScreen extends StatefulWidget {
  const PeriodDurationScreen({Key? key}) : super(key: key);

  @override
  State<PeriodDurationScreen> createState() => _PeriodDurationScreenState();
}

class _PeriodDurationScreenState extends State<PeriodDurationScreen> {
  int _selectedDuration = 3;
  final int _minDuration = 1;
  final int _maxDuration = 30;

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
            const SetupProgressIndicator(currentStep: 3, totalSteps: 5),
            const SizedBox(height: 20),
            Text(
              'Durasi Menstruasi\nAnda',
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
                        initialItem: _selectedDuration - _minDuration,
                      ),
                      itemExtent: 50,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedDuration = index + _minDuration;
                        });
                      },
                      children: List<Widget>.generate(_maxDuration - _minDuration + 1, (int index) {
                        final int currentDuration = index + _minDuration;
                        return Center(
                          child: Text(
                            '$currentDuration',
                            style: TextStyle(
                              color: _selectedDuration == currentDuration
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: _selectedDuration == currentDuration ? 32 : 26,
                              fontWeight: _selectedDuration == currentDuration
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
                    'Hari',
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
                  context.push(AppRoutes.cycleLength);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
