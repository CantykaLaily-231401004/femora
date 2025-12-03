import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EditCycleScreen extends StatefulWidget {
  const EditCycleScreen({Key? key}) : super(key: key);

  @override
  _EditCycleScreenState createState() => _EditCycleScreenState();
}

class _EditCycleScreenState extends State<EditCycleScreen> {
  DateTime _focusedDayOct = DateTime(2025, 10, 1);
  DateTime? _selectedDayOct;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  DateTime _focusedDayNov = DateTime(2025, 11, 1);

  @override
  void initState() {
    super.initState();
    _selectedDayOct = _focusedDayOct;
    _rangeStart = DateTime(2025, 10, 7);
    _rangeEnd = DateTime(2025, 10, 11);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Siklus',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCalendar(true),
            const SizedBox(height: 20),
            _buildCalendar(false),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF75270),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(bool isOctober) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: isOctober ? _focusedDayOct : _focusedDayNov,
        firstDay: DateTime(2025, 1, 1),
        lastDay: DateTime(2025, 12, 31),
        locale: 'id_ID',
        calendarFormat: CalendarFormat.month,
        rangeSelectionMode: _rangeSelectionMode,
        selectedDayPredicate: (day) => isSameDay(_selectedDayOct, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDayOct, selectedDay)) {
            setState(() {
              _selectedDayOct = selectedDay;
              if (isOctober) {
                _focusedDayOct = focusedDay;
              } else {
                _focusedDayNov = focusedDay;
              }
              _rangeStart = null;
              _rangeEnd = null;
              _rangeSelectionMode = RangeSelectionMode.toggledOff;
            });
          }
        },
        onRangeSelected: (start, end, focusedDay) {
          setState(() {
            _selectedDayOct = null;
            if (isOctober) {
              _focusedDayOct = focusedDay;
            } else {
              _focusedDayNov = focusedDay;
            }
            _rangeStart = start;
            _rangeEnd = end;
            _rangeSelectionMode = RangeSelectionMode.toggledOn;
          });
        },
        headerStyle: const HeaderStyle(
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
          formatButtonVisible: false,
        ),
        calendarStyle: CalendarStyle(
          rangeHighlightColor: const Color(0xFFFFF3F4),
          rangeStartDecoration: const BoxDecoration(
            color: Color(0xFFF75270),
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: const BoxDecoration(
            color: Color(0xFFF75270),
            shape: BoxShape.circle,
          ),
          withinRangeDecoration: const BoxDecoration(
            color: Color(0xFFF75270),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent, // No special decoration for today
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, focusedDay) {
            if (isSameDay(day, DateTime(2025, 10, 20))) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    const Text('😊', style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }
            return null;
          },
          rangeStartBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF75270),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          rangeEndBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF75270),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
          withinRangeBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFF75270),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
