import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/setup_progress_indicator.dart';
import 'package:femora/widgets/size_config.dart';

class CycleLengthScreen extends StatefulWidget {
  const CycleLengthScreen({Key? key}) : super(key: key);

  @override
  State<CycleLengthScreen> createState() => _CycleLengthScreenState();
}

class _CycleLengthScreenState extends State<CycleLengthScreen> {
  bool _isRegular = true;
  int _startCycle = 23;
  int _endCycle = 27;

  final int _minCycle = 15;
  final int _maxCycle = 45;

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
            const SetupProgressIndicator(currentStep: 4, totalSteps: 5),
            const SizedBox(height: 20),
            Text(
              'Masukkan Panjang\nSiklus Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(28),
                color: AppColors.primary,
                height: 1.3,
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Teratur', _isRegular),
                SizedBox(width: SizeConfig.getWidth(3)),
                _buildToggleButton('Tidak Teratur', !_isRegular),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPicker(
                  initialItem: _startCycle - _minCycle,
                  onSelectedItemChanged: (index) {
                    setState(() => _startCycle = index + _minCycle);
                  },
                ),
                const Text("-", style: TextStyle(fontSize: 24, color: AppColors.textSecondary)),
                _buildPicker(
                  initialItem: _endCycle - _minCycle,
                  onSelectedItemChanged: (index) {
                    setState(() => _endCycle = index + _minCycle);
                  },
                ),
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
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.getWidth(5), 20, SizeConfig.getWidth(5), 35),
              child: PrimaryButton(
                text: 'Lanjutkan',
                onPressed: () {
                  CycleDataService().setCycleLength(
                    min: _startCycle,
                    max: _isRegular ? _startCycle : _endCycle,
                    isRegular: _isRegular,
                  );
                  context.push('/last-period');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({
    required int initialItem,
    required Function(int) onSelectedItemChanged,
  }) {
    return SizedBox(
      width: SizeConfig.getWidth(30),
      height: SizeConfig.getHeight(30),
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        itemExtent: 50,
        onSelectedItemChanged: onSelectedItemChanged,
        children: List<Widget>.generate(_maxCycle - _minCycle + 1, (int index) {
          final int currentDay = index + _minCycle;
          return Center(
            child: Text(
              '$currentDay',
              style: TextStyle(
                color: (currentDay == _startCycle || currentDay == _endCycle)
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: (currentDay == _startCycle || currentDay == _endCycle) ? 28 : 24,
                fontWeight: (currentDay == _startCycle || currentDay == _endCycle)
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRegular = text == 'Teratur';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getWidth(8),
          vertical: SizeConfig.getHeight(1.5),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: isSelected ? null : Border.all(color: AppColors.borderColor),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getFontSize(16),
          ),
        ),
      ),
    );
  }
}
