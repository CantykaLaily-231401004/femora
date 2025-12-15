import 'package:femora/models/daily_log_model.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/recommendation_popup.dart';
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
    
    Navigator.of(context).pop(); // Tutup popup mood

    // Skenario 1: Menstruasi & Sedih -> Lanjut tanya Gejala
    if (isMenstruating && !isHappy) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          // Oper data mood ke popup gejala biar sekalian disimpan nanti
          return SymptomsPopup(
            initialMood: mood,
            isMenstruating: isMenstruating,
          );
        },
      );
      return;
    }

    // Skenario 2: Happy atau Tidak Menstruasi -> Simpan Langsung
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
        symptoms: [], // Kosong karena tidak isi gejala
        isMenstruation: isMenstruating,
      );

      await cycleDataService.saveDailyLog(log);
    }

    // Tampilkan Rekomendasi
    String header;
    String message;
    String? imageName;

    if (isMenstruating) {
      header = 'Horeee!';
      message = 'Lagi menstruasi tapi tetap ceria! ✨\nJangan lupa minum air hangat ya! 💧';
      imageName = 'fase_menstruasi.png'; // Pastikan nama file aset sesuai
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

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
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