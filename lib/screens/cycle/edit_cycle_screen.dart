import 'package:femora/logic/menstruation_tracking_logic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';

class EditCycleScreen extends StatefulWidget {
  final DateTime? initialDate;
  const EditCycleScreen({Key? key, this.initialDate}) : super(key: key);

  @override
  State<EditCycleScreen> createState() => _EditCycleScreenState();
}

class _EditCycleScreenState extends State<EditCycleScreen> {
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  final MenstruationTrackingLogic _trackingLogic = MenstruationTrackingLogic();

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate ?? DateTime.now();
  }

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
            const SizedBox(height: 20),
            Text(
              'Edit Siklus Menstruasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(24),
                color: AppColors.primary,
                height: 1.3,
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(2)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: _rangeSelectionMode,
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_rangeStart, selectedDay)) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _rangeStart = selectedDay;
                      _rangeEnd = null;
                      _rangeSelectionMode = RangeSelectionMode.toggledOn;
                    });
                  }
                },
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _rangeStart = start;
                    _rangeEnd = end;
                  });
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: SizeConfig.getFontSize(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.primary,
                    size: SizeConfig.getFontSize(24),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: SizeConfig.getFontSize(24),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  rangeHighlightColor: AppColors.primaryLight.withOpacity(0.3),
                  todayDecoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  rangeStartDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: SizeConfig.getFontSize(14),
                  ),
                  weekendTextStyle: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: SizeConfig.getFontSize(14),
                    color: AppColors.textSecondary,
                  ),
                  outsideTextStyle: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: SizeConfig.getFontSize(14),
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.getWidth(5), 20, SizeConfig.getWidth(5), 35),
              child: PrimaryButton(
                text: 'Simpan Perubahan',
                onPressed: () async {
                  if (_rangeStart != null) {
                    await _trackingLogic.updateManualPeriod(
                      startDate: _rangeStart!,
                      endDate: _rangeEnd,
                    );
                    context.pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}