import 'package:femora/config/routes.dart';
import 'package:femora/logic/cycle_phase_logic.dart';
import 'package:femora/logic/prediction_logic.dart';
import 'package:femora/logic/menstruation_tracking_logic.dart';
import 'package:femora/models/cycle_data.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/cycle_phase_card.dart';
import 'package:femora/widgets/home_calendar_card.dart';
import 'package:femora/widgets/menstruation_question_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CycleDataService _cycleDataService = CycleDataService();
  final MenstruationTrackingLogic _trackingLogic = MenstruationTrackingLogic();
  
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  
  Map<DateTime, bool> _menstruationMarkers = {};
  CyclePrediction? _dynamicPrediction;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;

    _cycleDataService.dailyMoodNotifier.addListener(_onDataChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAllData();
    });
  }

  @override
  void dispose() {
    _cycleDataService.dailyMoodNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  // ✅ FIX: Alur data diperbaiki menjadi sekuensial dan atomik
  Future<void> _loadAllData() async {
    // 1. Muat data dasar (durasi siklus, dll)
    await _cycleDataService.loadUserData();
    if (!mounted) return;

    // 2. Muat data pendukung
    await _cycleDataService.loadMoodsForMonth(_focusedDay);
    final newMarkers = await _loadMenstruationMarkers(_focusedDay);

    // 3. Hitung prediksi baru berdasarkan data terbaru
    final newPrediction = await _updateDynamicPrediction();

    // 4. Panggil setState SATU KALI dengan semua data baru
    if (mounted) {
      setState(() {
        _menstruationMarkers = newMarkers;
        _dynamicPrediction = newPrediction;
      });
    }
  }

  // ✅ FIX: Fungsi sekarang mengembalikan nilai, tidak memanggil setState
  Future<CyclePrediction?> _updateDynamicPrediction() async {
    final initialCycleData = _cycleDataService.cycleDataNotifier.value;
    if (initialCycleData == null) return null;

    final mostRecentStart = await _trackingLogic.getMostRecentPeriodStartDate();
    final baseDate = mostRecentStart ?? initialCycleData.lastPeriodStart;

    return CyclePrediction(
      lastPeriodStart: baseDate,
      periodDuration: initialCycleData.periodDuration,
      minCycleLength: initialCycleData.minCycleLength,
      maxCycleLength: initialCycleData.maxCycleLength,
      isRegular: initialCycleData.isRegular,
    );
  }

  // ✅ FIX: Fungsi sekarang mengembalikan nilai, tidak memanggil setState
  Future<Map<DateTime, bool>> _loadMenstruationMarkers(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final markers = <DateTime, bool>{};
    for (var day = startOfMonth; day.isBefore(endOfMonth.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final isMens = await _trackingLogic.isMenstruationDay(day);
      if (isMens) {
        markers[DateTime(day.year, day.month, day.day)] = true;
      }
    }
    return markers;
  }

  String? _getMoodEmoji(DateTime date) {
    final moodText = _cycleDataService.getMoodForDay(date);
    if (moodText == 'Baik') return '😊';
    if (moodText == 'Buruk') return '😞';
    return null;
  }

  Widget? _buildMenstruationMarker(DateTime date) {
    final isMens = _menstruationMarkers[DateTime(date.year, date.month, date.day)] ?? false;
    if (isMens) {
      return Container(
        margin: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
      );
    }
    return null;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final isToday = DateTime.now().difference(selectedDay).inDays == 0 && DateTime.now().day == selectedDay.day;
    if (isToday && _cycleDataService.getMoodForDay(selectedDay) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu sudah melakukan check-in hari ini! 😊'), backgroundColor: Color(0xFFF75270)),
      );
      return;
    }

    if(isToday){
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const MenstruationQuestionPopup(),
      ).then((_) => _loadAllData());
    } else {
      context.push(AppRoutes.cycleEdit, extra: selectedDay);
    }
  }

  void _onEditCycle() => context.push(AppRoutes.cycleEdit, extra: DateTime.now());

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dynamicPrediction != null)
              HomeCalendarCard(
                focusedDay: _focusedDay,
                selectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                onEditCycle: _onEditCycle,
                prediction: _dynamicPrediction!,
                getMoodForDay: _getMoodEmoji,
                getMenstruationMarker: _buildMenstruationMarker,
              )
            else
              const SizedBox(height: 350, child: Center(child: CircularProgressIndicator(color: AppColors.primary))),

            const SizedBox(height: 25),
            
            if (_dynamicPrediction != null)
              CyclePhaseCard(
                data: CyclePhaseLogic.getDynamicPhaseData(_dynamicPrediction!, DateTime.now()),
              )
            else
              const Center(child: CircularProgressIndicator(color: AppColors.primary)),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
