import 'package:femora/config/routes.dart';
import 'package:femora/logic/cycle_phase_logic.dart';
import 'package:femora/logic/prediction_logic.dart';
import 'package:femora/logic/menstruation_tracking_logic.dart';
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
  bool? _isCurrentlyMenstruating; // Status menstruasi hari ini

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;

    // Listen to data changes
    _cycleDataService.dailyMoodNotifier.addListener(_onDataChanged);
    _cycleDataService.cycleDataNotifier.addListener(_onDataChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAllData();
    });
  }

  @override
  void dispose() {
    _cycleDataService.dailyMoodNotifier.removeListener(_onDataChanged);
    _cycleDataService.cycleDataNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      debugPrint('🔄 Data changed, reloading...');
      _loadAllData();
    }
  }

  Future<void> _loadAllData() async {
    debugPrint('📥 Loading all data...');
    
    await _cycleDataService.loadUserData();
    if (!mounted) return;

    final isMenstruating = await _trackingLogic.isCurrentlyMenstruating();
    final newMarkers = await _loadMenstruationMarkers(_focusedDay);
    await _cycleDataService.loadMoodsForMonth(_focusedDay);
    final newPrediction = await _updateDynamicPrediction();

    if (mounted) {
      setState(() {
        _isCurrentlyMenstruating = isMenstruating;
        _menstruationMarkers = newMarkers;
        _dynamicPrediction = newPrediction;
      });
      
      debugPrint('✅ All data loaded successfully');
    }
  }

  Future<CyclePrediction?> _updateDynamicPrediction() async {
    final userId = _cycleDataService.userId;
    if (userId == null) return null;

    final initialCycleData = _cycleDataService.cycleDataNotifier.value;
    if (initialCycleData == null) return null;

    try {
      final prediction = await CyclePrediction.fromHistoricalData(
        userId: userId,
        defaultPeriodDuration: initialCycleData.periodDuration,
        defaultMinCycle: initialCycleData.minCycleLength,
        defaultMaxCycle: initialCycleData.maxCycleLength,
        defaultIsRegular: initialCycleData.isRegular,
      );

      debugPrint('🔮 Prediction updated');
      return prediction;
    } catch (e) {
      debugPrint('❌ Error updating prediction: $e');
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
  }

  Future<Map<DateTime, bool>> _loadMenstruationMarkers(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    final markers = <DateTime, bool>{};
    
    for (var day = startOfMonth; 
         day.isBefore(endOfMonth.add(const Duration(days: 1))); 
         day = day.add(const Duration(days: 1))) {
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
        decoration: const BoxDecoration(
          color: AppColors.primary, 
          shape: BoxShape.circle
        ),
      );
    }
    return null;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final isToday = DateTime.now().difference(selectedDay).inDays == 0 && 
                    DateTime.now().day == selectedDay.day;
    
    if (isToday && _cycleDataService.getMoodForDay(selectedDay) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kamu sudah melakukan check-in hari ini! 😊'), 
          backgroundColor: Color(0xFFF75270)
        ),
      );
      return;
    }

    if (isToday) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const MenstruationQuestionPopup(),
      ).then((_) {
        debugPrint('🔄 Checkin completed, reloading data...');
        _loadAllData();
      });
    } else {
      context.push(AppRoutes.cycleEdit, extra: selectedDay).then((_) {
        debugPrint('🔄 Cycle edited, reloading data...');
        _loadAllData();
      });
    }
  }
  
  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
    // Load data for the new month
    _cycleDataService.loadMoodsForMonth(focusedDay);
    _loadMenstruationMarkers(focusedDay).then((newMarkers) {
      if(mounted) {
        setState(() {
          _menstruationMarkers = newMarkers;
        });
      }
    });
  }

  void _onEditCycle() {
    context.push(AppRoutes.cycleEdit, extra: DateTime.now()).then((_) {
      debugPrint('🔄 Cycle edited, reloading data...');
      _loadAllData();
    });
  }

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
                onPageChanged: _onPageChanged,
                onEditCycle: _onEditCycle,
                prediction: _dynamicPrediction!,
                getMoodForDay: _getMoodEmoji,
                getMenstruationMarker: _buildMenstruationMarker,
              )
            else
              const SizedBox(
                height: 350,
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              ),
            const SizedBox(height: 25),
            if (_dynamicPrediction != null)
              CyclePhaseCard(
                data: CyclePhaseLogic.getDynamicPhaseData(
                  _dynamicPrediction!,
                  DateTime.now(),
                  isCurrentlyMenstruating: _isCurrentlyMenstruating,
                ),
              )
            else
              const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
