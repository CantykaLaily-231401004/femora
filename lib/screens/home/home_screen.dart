import 'package:femora/config/routes.dart'; 
import 'package:femora/logic/cycle_phase_logic.dart';
import 'package:femora/logic/prediction_logic.dart';
import 'package:femora/models/cycle_data.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/cycle_phase_card.dart';
import 'package:femora/widgets/home_calendar_card.dart';
import 'package:femora/widgets/menstruation_question_popup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CycleDataService _cycleDataService = CycleDataService();
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;

    _cycleDataService.dailyMoodNotifier.addListener(_onDataChanged);
    _cycleDataService.cycleDataNotifier.addListener(_onDataChanged);

    // Load data fresh dari server saat masuk
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _cycleDataService.loadUserData();
      if (mounted) {
        await _cycleDataService.loadMoodsForMonth(now);
      }
    });
  }

  @override
  void dispose() {
    _cycleDataService.dailyMoodNotifier.removeListener(_onDataChanged);
    _cycleDataService.cycleDataNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  String? _getMoodEmoji(DateTime date) {
    final moodText = _cycleDataService.getMoodForDay(date);
    if (moodText == 'Baik') return '😊';
    if (moodText == 'Buruk') return '😞';
    return null; 
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final isToday = DateTime.now().difference(selectedDay).inDays == 0 && 
                    DateTime.now().day == selectedDay.day;

    if (isToday) {
      // LOGIC FIX: Cek database local dulu
      final existingMood = _cycleDataService.getMoodForDay(selectedDay);
      
      if (existingMood != null) {
        // JIKA SUDAH ADA DATA, TAMPILKAN SNACKBAR & JANGAN BUKA POPUP
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamu sudah melakukan check-in hari ini! 😊'),
            backgroundColor: Color(0xFFF75270),
          ),
        );
        return; // STOP DI SINI
      }

      // Jika belum ada data, baru buka popup
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        useRootNavigator: true, 
        backgroundColor: Colors.transparent,
        builder: (context) => const MenstruationQuestionPopup(),
      ).then((_) {
        // Refresh data setelah popup ditutup
        _cycleDataService.loadMoodsForMonth(_focusedDay);
      });
    } else {
      // Jika klik tanggal lain (bukan hari ini), buka edit screen history
      context.push(AppRoutes.cycleEdit, extra: selectedDay);
    }
  }

  void _onEditCycle() {
    context.push(AppRoutes.cycleEdit, extra: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final cycleData = _cycleDataService.cycleDataNotifier.value;

    final CyclePrediction prediction;
    if (cycleData != null) {
      prediction = CyclePrediction(
        lastPeriodStart: cycleData.lastPeriodStart,
        periodDuration: cycleData.periodDuration,
        minCycleLength: cycleData.minCycleLength,
        maxCycleLength: cycleData.maxCycleLength,
        isRegular: cycleData.isRegular,
      );
    } else {
      prediction = CyclePrediction(
        lastPeriodStart: DateTime.now().subtract(const Duration(days: 28)),
        periodDuration: 5,
        minCycleLength: 28,
        maxCycleLength: 28,
        isRegular: true,
      );
    }

    final currentPhase = CyclePhaseLogic.getCurrentPhase(prediction, DateTime.now());

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            HomeCalendarCard(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: _onDaySelected,
              onEditCycle: _onEditCycle,
              prediction: prediction,
              getMoodForDay: _getMoodEmoji, 
            ),
            const SizedBox(height: 15),
            CyclePhaseCard(data: currentPhase),
            const SizedBox(height: 120), 
          ],
        ),
      ),
    );
  }
}