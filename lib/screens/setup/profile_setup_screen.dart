import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/setup_progress_indicator.dart';
import 'package:femora/widgets/size_config.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _selectedDay = 15;
  int _selectedMonth = 4;
  int _selectedYear = 2005;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  final List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];
  final List<int> _years = List.generate(100, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _yearController = FixedExtentScrollController(initialItem: _years.indexOf(_selectedYear));
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  List<int> _getDaysInMonth(int year, int month) {
    return List.generate(DateTime(year, month + 1, 0).day, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);

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
            const SetupProgressIndicator(currentStep: 1, totalSteps: 5),
            const SizedBox(height: 20),
            Text(
              'Beritahu Kami\nTanggal Lahir Anda',
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
                children: [
                  _buildPicker(
                    items: _months,
                    selectedItem: _months[_selectedMonth - 1],
                    width: SizeConfig.getWidth(30),
                    controller: _monthController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedMonth = (index % _months.length) + 1;
                        final newDaysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
                        if (_selectedDay > newDaysInMonth.length) {
                          _selectedDay = newDaysInMonth.length;
                          if (_dayController.hasClients) {
                            _dayController.jumpToItem(_selectedDay - 1);
                          }
                        }
                      });
                    },
                  ),
                  _buildPicker(
                    items: daysInMonth,
                    selectedItem: _selectedDay,
                    controller: _dayController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedDay = daysInMonth[index % daysInMonth.length];
                      });
                    },
                  ),
                  _buildPicker(
                    items: _years,
                    selectedItem: _selectedYear,
                    width: SizeConfig.getWidth(30),
                    controller: _yearController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedYear = _years[index % _years.length];
                        final newDaysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
                        if (_selectedDay > newDaysInMonth.length) {
                          _selectedDay = newDaysInMonth.length;
                          if (_dayController.hasClients) {
                            _dayController.jumpToItem(_selectedDay - 1);
                          }
                        }
                      });
                    },
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
                  final birthDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
                  CycleDataService().setBirthDate(birthDate);
                  context.push('/weight');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({
    required List<dynamic> items,
    required dynamic selectedItem,
    required FixedExtentScrollController controller,
    required Function(int) onSelectedItemChanged,
    double? width,
  }) {
    return SizedBox(
      width: width ?? SizeConfig.getWidth(25),
      height: SizeConfig.getHeight(30),
      child: CupertinoPicker(
        looping: true,
        scrollController: controller,
        itemExtent: 50,
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map((item) {
          final isSelected = (item == selectedItem);
          return Center(
            child: Text(
              '$item',
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.7),
                fontSize: isSelected ? 24 : 20,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
