import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final CalendarFormat calendarFormat;
  final Function(CalendarFormat)? onFormatChanged;
  final bool isTodayCheckedIn;

  const CustomCalendar({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    this.calendarFormat = CalendarFormat.month,
    this.onFormatChanged,
    this.isTodayCheckedIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
      padding: EdgeInsets.all(SizeConfig.getWidth(4)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(selectedDay, day);
        },
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (isSameDay(date, DateTime.now()) && isTodayCheckedIn) {
              return Positioned(
                bottom: 4, // Adjust position
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // You can add a background color if needed
                  ),
                  child: const Text(
                    '😊', // Placeholder emoticon
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            }
            return null;
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
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
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
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
    );
  }
}
