import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/recommendation_popup.dart';
import 'package:femora/widgets/symptoms_popup.dart';
import 'package:flutter/material.dart';

class MoodCheckinPopup extends StatelessWidget {
  final bool isMenstruating;

  const MoodCheckinPopup({
    Key? key,
    required this.isMenstruating,
  }) : super(key: key);

  void _handleMoodSelection(BuildContext context, bool isHappy) {
    final cycleDataService = CycleDataService();
    final emoticon = isHappy ? '😊' : '😢';
    // Always use today's date for daily check-in
    cycleDataService.setMoodForDay(DateTime.now(), emoticon);

    Navigator.of(context).pop(); // Close the mood popup

    if (isMenstruating && !isHappy) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          // Pass today's date to the symptoms popup
          return SymptomsPopup(selectedDay: DateTime.now());
        },
      );
      return;
    }

    String header;
    String message;
    String? imageName;

    if (isMenstruating) {
      header = 'Horeee!';
      message = 'Lagi menstruasi tapi tetap ceria! ✨\nJangan lupa minum air hangat ya! 💧';
      imageName = 'fase_menstruasi.png';
    } else {
      if (isHappy) {
        header = 'Keren!';
        message = 'Harimu luar biasa! 🎉\nSebarkan energi positifmu✨';
        imageName = 'happy_emoji.png';
      } else {
        header = 'Lagi nggak menstruasi, \ntapi lagi down ya?';
        message = 'Tetap semangat! 💪 \nKamu pasti bisa!';
        imageName = 'sad_emoji.png';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return RecommendationPopup(
          header: header,
          message: message,
          imageName: imageName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
