import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/screens/home_widgets/cycle_phase_card.dart';
import 'package:femora/screens/home_widgets/home_calendar_card.dart';
import 'package:femora/screens/home_widgets/home_header.dart';
import 'package:femora/screens/home_widgets/home_nav_bar.dart';
import 'package:femora/core/utils/size_config.dart';
import 'package:femora/core/widgets/common/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Simulasi data fase yang dinamis
  final CyclePhaseData _currentPhase = CyclePhaseData.follicular;
  bool _isCheckedInToday = false; // State to track check-in

  void _onDateSelected(DateTime date) {
    // Only show popup if today is selected or maybe any day (requirement says "tanggal mana aja")
    // But usually check-in is for today. For now, let's allow any day as per request.
    _showMenstruationCheckDialog(context);
  }

  void _onEditCycle() {
    // TODO: Navigate to edit cycle screen or show edit cycle dialog
    // For now we just print a message
    print("Edit Cycle clicked");
  }

  // 1. Tanya Menstruasi
  void _showMenstruationCheckDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 476,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 476,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFDEBD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 65,
                child: Text(
                  'Apakah Kamu \nSedang Menstruasi?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFFF75270), size: 30),
                ),
              ),
              // Image Placeholder (Emoticon)
              Positioned(
                left: 130,
                top: 157,
                child: Container(
                  width: 128,
                  height: 128,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(), // Image Placeholder
                  child: Stack(
                    children: [
                      Positioned(
                        left: 14.93,
                        top: 40.53,
                        child: Container(
                          width: 6.40,
                          height: 6.40,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEED172),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                        ),
                      ),
                      // Add Image widget here later
                    ],
                  ),
                ),
              ),
              // Button: Tidak
              Positioned(
                left: 36,
                right: 36,
                top: 367,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showMoodCheckDialog(context, false);
                  },
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tidak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
              // Button: Iya
              Positioned(
                left: 34,
                right: 34,
                top: 305,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showMoodCheckDialog(context, true);
                  },
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF75270),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Iya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2. Tanya Mood
  void _showMoodCheckDialog(BuildContext context, bool isMenstruating) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 476,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 476,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFDEBD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 65,
                child: Text(
                  'Bagaimana \nperasaanmu hari ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFFF75270), size: 30),
                ),
              ),
              // Button: Buruk
              Positioned(
                left: 36,
                right: 36,
                top: 367,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _handleMoodSelection(context, isMenstruating, false); // Mood Bad
                  },
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Buruk',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
              // Button: Baik
              Positioned(
                left: 34,
                right: 34,
                top: 305,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _handleMoodSelection(context, isMenstruating, true); // Mood Good
                  },
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF75270),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Baik',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleMoodSelection(BuildContext context, bool isMenstruating, bool isMoodGood) {
    // Set checked in to true after completing the mood selection
    setState(() {
      _isCheckedInToday = true;
    });

    if (isMoodGood) {
      if (isMenstruating) {
        // 3. Baik + Menstruasi
        _showRecommendationDialog(
          context,
          title: 'Rekomendasi',
          subTitle: 'Horeee!',
          message: 'Lagi menstruasi tapi tetap ceria! ✨\nJangan lupa minum air hangat ya! 💧',
          imagePlaceholder: Positioned(
            left: 132,
            top: 166,
            child: Container(
              width: 129,
              height: 129,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(), // Image placeholder
              child: Stack(
                children: [
                  Positioned(
                    left: 15.05,
                    top: 40.85,
                    child: Container(
                      width: 6.45,
                      height: 6.45,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEED172),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // 4. Baik + Tidak Menstruasi
        _showRecommendationDialog(
          context,
          title: 'Rekomendasi',
          subTitle: 'Keren!',
          message: 'Harimu luar biasa! 🎉\nSebarkan energi positifmu✨',
        );
      }
    } else {
      if (isMenstruating) {
        // 5. Buruk + Menstruasi (Check Gejala)
        _showSymptomsCheckDialog(context);
      } else {
        // 6. Buruk + Tidak Menstruasi
        _showRecommendationDialog(
          context,
          title: 'Rekomendasi',
          subTitle: 'Lagi nggak menstruasi, \ntapi lagi down ya?',
          message: 'Tetap semangat! 💪 \nKamu pasti bisa!',
        );
      }
    }
  }

  void _showRecommendationDialog(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String message,
    Widget? imagePlaceholder,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 476,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 476,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFDEBD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 65,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 101,
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                top: 325,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFFF75270), size: 30),
                ),
              ),
              if (imagePlaceholder != null) imagePlaceholder,
            ],
          ),
        );
      },
    );
  }

  // 5. Form Gejala
  void _showSymptomsCheckDialog(BuildContext context) {
    final List<String> symptoms = [
      'Nyeri perut/kram',
      'Sakit kepala/pusing',
      'Kelelahan',
      'Mood Swing',
      'Nyeri Punggung',
      'Kembung',
    ];
    final Set<String> selectedSymptoms = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 476,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 476,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFFDEBD0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 65,
                    child: Text(
                      'Gejala yang Dirasakan?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFFF75270), size: 30),
                    ),
                  ),
                  Positioned(
                    left: 86,
                    right: 20,
                    top: 165,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: symptoms.map((symptom) {
                        final isSelected = selectedSymptoms.contains(symptom);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedSymptoms.remove(symptom);
                              } else {
                                selectedSymptoms.add(symptom);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: ShapeDecoration(
                                    color: isSelected ? const Color(0xFFF75270) : null,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        width: 1.30,
                                        color: Color(0xFFF75270),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  symptom,
                                  style: const TextStyle(
                                    color: Color(0xFFF75270),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    right: 36,
                    top: 361,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showSymptomRecommendationDialog(context);
                      },
                      child: Container(
                        height: 52,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF75270),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Simpan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Hasil Rekomendasi Gejala
  void _showSymptomRecommendationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 476,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 476,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFDEBD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                top: 65,
                child: Text(
                  'Rekomendasi Untukmu 💖',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFFF75270), size: 30),
                ),
              ),
              const Positioned(
                left: 61,
                right: 20,
                top: 104,
                child: Text(
                  'Berdasarkan kondisimu:     \n✅ Kompres air hangat \n     untuk nyeri perut  \n✅ Minum air putih 8 gelas\n✅ Istirahat 15 menit\n      │ │                             \n 🎵 Putar Musik Relaksasi? ',
                  style: TextStyle(
                    color: Color(0xFFF75270),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Button: Iya (Putar Musik)
              Positioned(
                left: 36,
                right: 36,
                top: 326,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Play Music logic
                  },
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF75270),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Iya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
              // Button: Tidak (Tutup)
              Positioned(
                left: 36,
                right: 36,
                top: 388,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 52,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tidak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Gradient Background Top
           Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientBackground(
              height: 494,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(),
            ),
          ),

          // Main Content Scrollable
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Header (Greetings & Profile)
                    const HomeHeader(
                      userName: 'Ningning',
                      userImageUrl: "https://placehold.co/24x24",
                    ),

                    const SizedBox(height: 24),

                    // Calendar Card
                    HomeCalendarCard(
                      onDateSelected: _onDateSelected,
                      isCheckedIn: _isCheckedInToday, // Pass check-in state
                      onEditCycle: _onEditCycle, // Pass edit cycle callback
                    ),

                    const SizedBox(height: 15),

                    // Cycle Phase Card (Dynamic)
                    CyclePhaseCard(data: _currentPhase),

                    const SizedBox(height: 100), // Space for floating nav bar
                  ],
                ),
              ),
            ),
          ),

          // Floating Bottom Navigation Bar
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: HomeNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}
