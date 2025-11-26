import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';
import 'package:table_calendar/table_calendar.dart';

class LastPeriodScreen extends StatefulWidget {
  const LastPeriodScreen({Key? key}) : super(key: key);

  @override
  State<LastPeriodScreen> createState() => _LastPeriodScreenState();
}

class _LastPeriodScreenState extends State<LastPeriodScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // Gradient Background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 494,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF75270),
                      Color(0xFFFDEBD0),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
              
                      // Progress Indicator 3/5 (Approximating since design has 5/5 on last)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new, size: 24),
                            ),
                          ),
                          const Spacer(),
                          _buildProgressStep(isActive: false),
                          const SizedBox(width: 3),
                          _buildProgressStep(isActive: false),
                          const SizedBox(width: 3),
                          _buildProgressStep(isActive: true),
                          const SizedBox(width: 3),
                          _buildProgressStep(isActive: false),
                          const SizedBox(width: 3),
                          _buildProgressStep(isActive: false),
                          const SizedBox(width: 10),
                          const Text(
                            '3 / 5',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              
                      const SizedBox(height: 30),
              
                      const Text(
                        'Masukkan Tanggal Mulai Menstruasi Terakhir Anda?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFDC143C),
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                      ),
              
                      const SizedBox(height: 30),
              
                      // Calendar Container
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 29.40,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          currentDay: DateTime.now(),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          calendarStyle: const CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: Color(0xFFF75270),
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Color(0xFFFF8699), // Lighter shade for today
                              shape: BoxShape.circle,
                            ),
                            defaultTextStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 40),
              
                      // Selesai Button
                      GestureDetector(
                        onTap: () {
                          if (_selectedDay != null) {
                            context.push(AppRoutes.setupLoading);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pilih tanggal terlebih dahulu')),
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF75270),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Text(
                            'Selesai',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              height: 1.20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep({required bool isActive}) {
    return Container(
      width: 30,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDC143C) : const Color(0xFFFFF3F4),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
