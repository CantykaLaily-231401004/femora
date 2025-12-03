import 'package:femora/config/constants.dart';
import 'package:femora/logic/cycle_phase_logic.dart';
import 'package:femora/logic/prediction_logic.dart';
import 'package:femora/models/cycle_data.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/bottom_nav_bar.dart';
import 'package:femora/widgets/cycle_phase_card.dart';
import 'package:femora/widgets/home_calendar_card.dart';
import 'package:femora/widgets/home_header.dart';
import 'package:femora/widgets/menstruation_question_popup.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;
  final CycleDataService _cycleDataService = CycleDataService();

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.book_outlined, route: '/insights'),
    BottomNavItem(icon: Icons.home_outlined, route: '/home'),
    BottomNavItem(icon: Icons.person_outline, route: '/profile'),
  ];

  void _onNavBarTapped(int index) {
    if (_currentIndex != index) {
      context.go(_navItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return ValueListenableBuilder<CycleData?>(
      valueListenable: _cycleDataService.cycleDataNotifier,
      builder: (context, cycleData, child) {
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

        return ValueListenableBuilder<String?>(
          valueListenable: _cycleDataService.userNameNotifier,
          builder: (context, userName, child) {
            return _HomeScreenContent(
              prediction: prediction,
              userName: userName,
              navItems: _navItems,
              currentIndex: _currentIndex,
              onNavBarTapped: _onNavBarTapped,
              cycleDataService: _cycleDataService,
              currentPhase: currentPhase,
            );
          },
        );
      },
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final CyclePrediction prediction;
  final String? userName;
  final List<BottomNavItem> navItems;
  final int currentIndex;
  final Function(int) onNavBarTapped;
  final CycleDataService cycleDataService;
  final CyclePhaseData currentPhase;

  const _HomeScreenContent({
    required this.prediction,
    this.userName,
    required this.navItems,
    required this.currentIndex,
    required this.onNavBarTapped,
    required this.cycleDataService,
    required this.currentPhase,
  });

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = now;
    _selectedDay = now;
    widget.cycleDataService.dailyMoodNotifier.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    widget.cycleDataService.dailyMoodNotifier.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    if (widget.cycleDataService.getMoodForDay(normalizedToday) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily check-in sudah dilakukan hari ini.')),
      );
      return;
    }

    setState(() {
      _focusedDay = focusedDay;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const MenstruationQuestionPopup(),
    );
  }

  void _onEditCycle() {
    context.go('/profile/edit_cycle');
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = widget.userName?.split(' ').first ?? 'Femora';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientBackground(
              height: SizeConfig.getHeight(40),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      HomeHeader(
                        userName: firstName,
                        userImageUrl: "https://placehold.co/24x24",
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          HomeCalendarCard(
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            onDaySelected: _onDaySelected,
                            onEditCycle: _onEditCycle,
                            prediction: widget.prediction,
                            getMoodForDay: widget.cycleDataService.getMoodForDay,
                          ),
                          const SizedBox(height: 15),
                          CyclePhaseCard(data: widget.currentPhase),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(
                currentIndex: widget.currentIndex,
                onTap: (index) => widget.onNavBarTapped(index),
                items: widget.navItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
