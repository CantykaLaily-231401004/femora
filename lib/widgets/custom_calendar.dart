import 'package:femora/logic/prediction_logic.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final CalendarFormat calendarFormat;
  final Function(CalendarFormat)? onFormatChanged;
  final bool isTodayCheckedIn;
  final String? locale;
  final CyclePrediction? prediction;
  final String? Function(DateTime) getMoodForDay;
  final Widget? Function(DateTime)? getMenstruationMarker;

  const CustomCalendar({
    Key? key,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    this.calendarFormat = CalendarFormat.month,
    this.onFormatChanged,
    this.isTodayCheckedIn = false,
    this.locale,
    this.prediction,
    required this.getMoodForDay,
    this.getMenstruationMarker,
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
        locale: locale,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        onFormatChanged: onFormatChanged,
        selectedDayPredicate: (day) => isSameDay(DateTime.now(), day),
        availableGestures: AvailableGestures.horizontalSwipe,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final mood = getMoodForDay(day);
            if (mood != null) {
              return Positioned(
                right: 1,
                bottom: 1,
                child: Text(mood, style: const TextStyle(fontSize: 12)),
              );
            }
            return null;
          },
          prioritizedBuilder: (context, day, focusedDay) {
            final actualMenstruationMarker = getMenstruationMarker?.call(day);
            if (actualMenstruationMarker != null) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  actualMenstruationMarker,
                  Text('${day.day}', style: const TextStyle(color: Colors.white)),
                ],
              );
            }

            if (prediction != null) {
              final lastPeriodEnd = prediction!.lastPeriodStart.add(Duration(days: prediction!.periodDuration - 1));
              if (!day.isBefore(prediction!.lastPeriodStart) && !day.isAfter(lastPeriodEnd)) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (prediction!.predictedPeriodStart != null && prediction!.predictedPeriodEnd != null) {
                if (!day.isBefore(prediction!.predictedPeriodStart!) && !day.isAfter(prediction!.predictedPeriodEnd!)) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black87),
                    ),
                  );
                }
              }
            }

            if (isSameDay(day, DateTime.now())) {
              return Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
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
          selectedDecoration: const BoxDecoration(),
          todayDecoration: const BoxDecoration(),
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
