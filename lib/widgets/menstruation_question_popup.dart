import 'package:femora/widgets/mood_checkin_popup.dart';
import 'package:flutter/material.dart';

class MenstruationQuestionPopup extends StatelessWidget {
  const MenstruationQuestionPopup({Key? key}) : super(key: key);

  void _showMoodCheckinPopup(BuildContext context, bool isMenstruating) {
    Navigator.of(context).pop(); // Close the current popup
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MoodCheckinPopup(isMenstruating: isMenstruating);
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
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Apakah Kamu \nSedang Menstruasi?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF75270),
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/fase_menstruasi.png',
              height: 128,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _showMoodCheckinPopup(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF75270),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text(
                'Iya',
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
              onPressed: () => _showMoodCheckinPopup(context, false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text(
                'Tidak',
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
      ),
    );
  }
}
