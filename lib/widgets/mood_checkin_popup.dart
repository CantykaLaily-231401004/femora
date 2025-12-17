import 'package:femora/models/daily_log_model.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/symptom_recommendations_popup.dart';
import 'package:femora/widgets/symptoms_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodCheckinPopup extends StatelessWidget {
  final bool isMenstruating;

  const MoodCheckinPopup({
    Key? key,
    required this.isMenstruating,
  }) : super(key: key);

  void _handleMoodSelection(BuildContext context, bool isHappy) async {
    final cycleDataService = CycleDataService();
    final String mood = isHappy ? 'Baik' : 'Buruk';

    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 50));

    if (isMenstruating && !isHappy) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (newContext) => SymptomsPopup(
          initialMood: mood,
          isMenstruating: isMenstruating,
        ),
      );
    } else {
      final userId = cycleDataService.userId;
      if (userId != null) {
        final now = DateTime.now();
        final dateId = DateFormat('yyyyMMdd').format(now);
        final id = '${userId}_$dateId';

        final log = DailyLogModel(
          id: id,
          userId: userId,
          date: now,
          mood: mood,
          symptoms: [],
          isMenstruation: isMenstruating,
        );

        await cycleDataService.saveDailyLog(log);
      }
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (newContext) => const SymptomRecommendationsPopup(selectedSymptoms: []), // Pass empty list
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        height: 476,
        decoration: const BoxDecoration(
          color: Color(0xFFFDEBD0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bagaimana \nperasaanmu hari ini?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF75270),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => _handleMoodSelection(context, true),
                    child: Image.asset(
                      'assets/images/happy_emoji.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _handleMoodSelection(context, false),
                    child: Image.asset(
                      'assets/images/sad_emoji.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _handleMoodSelection(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF75270),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'Baik',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _handleMoodSelection(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: const Text(
                      'Buruk',
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}