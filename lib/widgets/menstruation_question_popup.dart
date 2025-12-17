import 'package:femora/widgets/mood_checkin_popup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import logic class
import 'package:femora/logic/menstruation_tracking_logic.dart';

class MenstruationQuestionPopup extends StatefulWidget {
  const MenstruationQuestionPopup({Key? key}) : super(key: key);

  @override
  State<MenstruationQuestionPopup> createState() => _MenstruationQuestionPopupState();
}

class _MenstruationQuestionPopupState extends State<MenstruationQuestionPopup> {
  bool _isLoading = false;

  Future<void> _handleMenstruationResponse(bool isMenstruating) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // ✅ PANGGIL LOGIC PELACAKAN MENSTRUASI
      final trackingLogic = MenstruationTrackingLogic();
      
      await trackingLogic.updateMenstruationStatus(
        checkInDate: DateTime.now(),
        isMenstruating: isMenstruating,
      );

      if (!mounted) return;

      // Tutup popup saat ini
      Navigator.of(context).pop();

      // Lanjut ke popup mood
      await Future.delayed(const Duration(milliseconds: 50));
      
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

    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      
      // Tampilkan error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Error',
            style: TextStyle(
              color: Color(0xFFF75270),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Gagal menyimpan status menstruasi:\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFF75270)),
              ),
            ),
          ],
        ),
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
        child: Stack(
          children: [
            Padding(
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
                  
                  // Tombol Iya
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleMenstruationResponse(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF75270),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
                  
                  // Tombol Tidak
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _handleMenstruationResponse(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      disabledBackgroundColor: Colors.grey.shade200,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFFF75270),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
            
            // Loading Overlay
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFF75270),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
