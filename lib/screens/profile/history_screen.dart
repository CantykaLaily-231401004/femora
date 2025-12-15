import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:femora/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/models/daily_log_model.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:table_calendar/table_calendar.dart'; 

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // Statistics Variables
  Map<String, int> _symptomCounts = {};
  Map<String, int> _moodCounts = {'Baik': 0, 'Buruk': 0};
  int _totalPeriodDays = 0;
  int _avgCycleLength = 28;

  // Kalender Data
  Map<DateTime, List<dynamic>> _calendarEvents = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadStatisticsAndEvents();
  }

  Future<void> _loadStatisticsAndEvents() async {
    if (_userId == null) return;

    try {
      final snapshot = await _firestore
          .collection('daily_logs')
          .where('userId', isEqualTo: _userId)
          .get();

      Map<String, int> tempSymptom = {
        'Mood Swing': 0,
        'Kembung': 0,
        'Nyeri Punggung': 0,
        'Kelelahan': 0,
        'Nyeri perut/kram': 0, 
        'Sakit kepala/pusing': 0,
      };
      Map<String, int> tempMood = {'Baik': 0, 'Buruk': 0};
      int menstruationDays = 0;
      Map<DateTime, List<dynamic>> events = {};

      for (var doc in snapshot.docs) {
        final log = DailyLogModel.fromFirestore(doc);
        final dateKey = DateTime(log.date.year, log.date.month, log.date.day);

        // Tandai kalender jika ada data
        events[dateKey] = ['Data'];

        // Hitung Gejala
        for (var symptom in log.symptoms) {
          if (tempSymptom.containsKey(symptom)) {
            tempSymptom[symptom] = (tempSymptom[symptom] ?? 0) + 1;
          } else {
             // Fallback jika nama gejala di DB sedikit berbeda
             tempSymptom[symptom] = 1;
          }
        }

        // Hitung Mood
        if (tempMood.containsKey(log.mood)) {
          tempMood[log.mood] = (tempMood[log.mood] ?? 0) + 1;
        }

        if (log.isMenstruation) {
          menstruationDays++;
        }
      }

      if (mounted) {
        setState(() {
          _symptomCounts = tempSymptom;
          _moodCounts = tempMood;
          _totalPeriodDays = menstruationDays;
          _calendarEvents = events;
        });
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    // Buka Edit Cycle Screen
    context.push(AppRoutes.cycleEdit, extra: selectedDay).then((_) {
      _loadStatisticsAndEvents(); // Refresh data saat kembali
    });
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(20),
                color: Colors.black,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleDataCard(BuildContext context, {
    required IconData icon, 
    required Color color, 
    required String value, 
    required String label
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.getFontSize(16),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.getFontSize(14),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem({
    required String iconPath,
    required String label,
    required String count,
    double width = 120, 
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          SizedBox(
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 48,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported, color: AppColors.primary, size: 30),
                  ),
                ),
                if (count != '0')
                  Positioned(
                    top: -2,
                    right: 28,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                      child: Center(
                        child: Text(
                          count,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.getFontSize(12),
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableItem({
    required Widget iconWidget, 
    required String label,
    required String count,
    double width = 85, 
    Color? backgroundColor,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          SizedBox(
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 48, 
                  height: 48,
                  decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: iconWidget),
                ),
                if (count != '0')
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                      child: Center(
                        child: Text(
                          count,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.getFontSize(12),
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onPressed: () => context.pop()),
          Image.asset(AppAssets.logoRed, width: 70), 
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // List gejala FIX (6 Ikon)
    final symptomData = [
      {'label': 'Mood Swing', 'count': '${_symptomCounts['Mood Swing'] ?? 0}', 'path': AppAssets.moodSwing},
      {'label': 'Kembung', 'count': '${_symptomCounts['Kembung'] ?? 0}', 'path': AppAssets.kembung},
      {'label': 'Nyeri Punggung', 'count': '${_symptomCounts['Nyeri Punggung'] ?? 0}', 'path': AppAssets.nyeriPunggung},
      {'label': 'Kelelahan', 'count': '${_symptomCounts['Kelelahan'] ?? 0}', 'path': AppAssets.kelelahan},
      {'label': 'Nyeri perut/\nkram', 'count': '${_symptomCounts['Nyeri perut/kram'] ?? 0}', 'path': AppAssets.nyeriPerut},
      {'label': 'Sakit kepala/\npusing', 'count': '${_symptomCounts['Sakit kepala/pusing'] ?? 0}', 'path': AppAssets.sakitKepala},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 224, 224),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context),
            SizedBox(height: SizeConfig.getHeight(1)),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Data', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Container(height: 1, color: AppColors.primary),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FIX: SIKLUSKU DIKEMBALIKAN
                    _buildSectionHeader('Siklusku', 
                        onTap: () => context.push(AppRoutes.cycleHistoryDetail)), 

                    // Kalender Riwayat
                    _buildSectionHeader('Kalender Riwayat'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2023, 1, 1),
                        lastDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: _onDaySelected,
                        eventLoader: (day) => _calendarEvents[DateTime(day.year, day.month, day.day)] ?? [],
                        calendarStyle: const CalendarStyle(
                          markerDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _buildCycleDataCard(
                          context,
                          icon: Icons.water_drop_outlined,
                          color: AppColors.primary,
                          value: '$_totalPeriodDays hari',
                          label: 'Masa Menstruasi',
                        ),
                        _buildCycleDataCard(
                          context,
                          icon: Icons.calendar_today_outlined,
                          color: const Color(0xFF6B6B6B),
                          value: '$_avgCycleLength hari',
                          label: 'Siklus Menstruasi',
                        ),
                      ],
                    ),

                    _buildSectionHeader('Gejala'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: symptomData.map((symptom) {
                          return _buildAssetItem(
                            iconPath: symptom['path']!, 
                            label: symptom['label']!, 
                            count: symptom['count']!,
                            width: 120,
                          );
                        }).toList(),
                      ),
                    ),
                    
                    _buildSectionHeader('Suasana Hati'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScrollableItem(
                            iconWidget: const Text('😊', style: TextStyle(fontSize: 28)),
                            label: 'Baik', 
                            count: '${_moodCounts['Baik']}', 
                            backgroundColor: AppColors.primaryLight, 
                            width: SizeConfig.getWidth(35)
                          ),
                          _buildScrollableItem(
                            iconWidget: const Text('😞', style: TextStyle(fontSize: 28)),
                            label: 'Buruk', 
                            count: '${_moodCounts['Buruk']}', 
                            backgroundColor: AppColors.primaryLight, 
                            width: SizeConfig.getWidth(35)
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}