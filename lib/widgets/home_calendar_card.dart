import 'package:femora/logic/prediction_logic.dart';
import 'package:flutter/material.dart';
import 'package:femora/widgets/custom_calendar.dart';

class HomeCalendarCard extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final VoidCallback onEditCycle;
  final CyclePrediction prediction;
  final String? Function(DateTime) getMoodForDay;
  // ✅ Parameter baru untuk marker menstruasi
  final Widget? Function(DateTime)? getMenstruationMarker;

  const HomeCalendarCard({
    Key? key,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    required this.onEditCycle,
    required this.prediction,
    required this.getMoodForDay,
    this.getMenstruationMarker, // Tambahkan di konstruktor
  }) : super(key: key);

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
            locale: 'id_ID',
            focusedDay: focusedDay,
            selectedDay: selectedDay,
            onDaySelected: onDaySelected,
            prediction: prediction,
            getMoodForDay: getMoodForDay,
            // ✅ Teruskan ke CustomCalendar
            getMenstruationMarker: getMenstruationMarker,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLegendItem(const Color(0xFFF75270), 'Menstruasi'),
                    const SizedBox(width: 8),
                    _buildLegendItem(const Color(0x6BFFB5A5), 'Prediksi'),
                    const SizedBox(width: 8),
                    _buildLegendItem(null, 'Mood', isMood: true),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onEditCycle,
                child: const Text(
                  'Edit Siklus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFF75270),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color? color, String label, {bool isMood = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMood)
          const Text('😊', style: TextStyle(fontSize: 10))
        else if (color != null)
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B6B6B),
            fontSize: 10,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
