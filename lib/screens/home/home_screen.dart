import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/widgets/bottom_nav_bar.dart';
import 'package:femora/widgets/cycle_phase_card.dart';
import 'package:femora/widgets/home_calendar_card.dart';
import 'package:femora/widgets/home_header.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CyclePhaseData _currentPhase = CyclePhaseData.follicular;
  bool _isCheckedInToday = false;
  int _currentIndex = 1; // Atur indeks awal ke tombol Beranda

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.book_outlined, route: '/insights'), // Sesuaikan dengan ikon dan rute Anda
    BottomNavItem(icon: Icons.home_outlined, route: '/home'),
    BottomNavItem(icon: Icons.person_outline, route: '/profile'),
  ];

  void _onDateSelected(DateTime date) {
    _showMenstruationCheckDialog(context);
  }

  void _onEditCycle() {
    print("Edit Cycle clicked");
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // TODO: Terapkan navigasi menggunakan GoRouter atau Navigator
    // Contoh: context.go(_navItems[index].route);
  }

  void _showMenstruationCheckDialog(BuildContext context) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _showMoodCheckDialog(BuildContext context, bool isMenstruating) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _handleMoodSelection(BuildContext context, bool isMenstruating, bool isMoodGood) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _showRecommendationDialog(BuildContext context, {required String title, required String subTitle, required String message, Widget? imagePlaceholder}) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _showSymptomsCheckDialog(BuildContext context) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _showSymptomRecommendationDialog(BuildContext context) {
    // ... (kode dialog yang ada tetap sama)
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const HomeHeader(
                      userName: 'Ningning',
                      userImageUrl: "https://placehold.co/24x24", 
                    ),

                    const SizedBox(height: 24),

                    HomeCalendarCard(
                      onDateSelected: _onDateSelected,
                      isCheckedIn: _isCheckedInToday,
                      onEditCycle: _onEditCycle,
                    ),

                    const SizedBox(height: 15),

                    CyclePhaseCard(data: _currentPhase),

                    const SizedBox(height: 100), 
                  ],
                ), 
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onNavBarTapped,
                items: _navItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
