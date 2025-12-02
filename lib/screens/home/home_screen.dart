
import 'package:femora/screens/education/education_screen.dart';
import 'package:femora/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/widgets/bottom_nav_bar.dart';
import 'package:femora/widgets/cycle_phase_card.dart';
import 'package:femora/widgets/home_calendar_card.dart';
import 'package:femora/widgets/page_header.dart'; // Import PageHeader
import 'package:femora/widgets/size_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Atur indeks awal ke tombol Beranda

  final List<Widget> _screens = [
    const EducationScreen(),
    const HomeContent(),
    const ProfileScreen(),
  ];

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.book_outlined, route: '/education'),
    BottomNavItem(icon: Icons.home_outlined, route: '/home'),
    BottomNavItem(icon: Icons.person_outline, route: '/profile'),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
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

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final CyclePhaseData _currentPhase = CyclePhaseData.follicular;
  bool _isCheckedInToday = false;

  void _onDateSelected(DateTime date) {
    // ... (kode dialog yang ada tetap sama)
  }

  void _onEditCycle() {
    print("Edit Cycle clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageHeader(userName: 'Ningning'), // Use PageHeader
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 120), // Adjust space to be below the header
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
      ],
    );
  }
}
