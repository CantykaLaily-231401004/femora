import 'package:flutter/material.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/core/widgets/calendar/custom_calendar.dart';
import 'package:femora/config/constants.dart';

class HomeCalendarCard extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final bool isCheckedIn;
  final VoidCallback onEditCycle;

  const HomeCalendarCard({
    Key? key,
    required this.onDateSelected,
    required this.onEditCycle,
    this.isCheckedIn = false,
  }) : super(key: key);

  @override
  State<HomeCalendarCard> createState() => _HomeCalendarCardState();
}

class _HomeCalendarCardState extends State<HomeCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 29.40,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCalendar(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            },
            isTodayCheckedIn: widget.isCheckedIn,
          ),
          const SizedBox(height: 15),
          // Legend and Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Legend
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLegendItem(const Color(0xFFF75270), 'Menstruasi'),
                    const SizedBox(width: 8),
                    _buildLegendItem(const Color(0x6BFFB5A5), 'Prediksi'),
                    const SizedBox(width: 8),
                    _buildLegendItem(null, 'Mood'),
                  ],
                ),
              ),
              // Edit Button
              GestureDetector(
                onTap: widget.onEditCycle,
                child: const Text(
                  'Edit Siklus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color? color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (color != null)
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
