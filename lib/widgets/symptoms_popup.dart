import 'package:femora/models/daily_log_model.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/symptom_recommendations_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SymptomsPopup extends StatefulWidget {
  final String initialMood;
  final bool isMenstruating;

  // Tambahkan parameter agar data nyambung dari mood popup
  const SymptomsPopup({
    Key? key, 
    required this.initialMood,
    required this.isMenstruating,
  }) : super(key: key);

  @override
  _SymptomsPopupState createState() => _SymptomsPopupState();
}

class _SymptomsPopupState extends State<SymptomsPopup> {
  final Map<String, bool> _symptoms = {
    'Nyeri perut/kram': false,
    'Sakit kepala/pusing': false,
    'Kelelahan': false,
    'Mood Swing': false,
    'Nyeri Punggung': false,
    'Kembung': false,
  };

  void _showRecommendations() async {
    final selectedSymptoms = _symptoms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // --- LOGIKA PENYIMPANAN KE FIREBASE ---
    final service = CycleDataService();
    final userId = service.userId;

    if (userId != null) {
      final now = DateTime.now();
      final dateId = DateFormat('yyyyMMdd').format(now);
      final id = '${userId}_$dateId';

      final log = DailyLogModel(
        id: id,
        userId: userId,
        date: now,
        mood: widget.initialMood, // Ambil dari yang dilempar mood popup
        symptoms: selectedSymptoms,
        isMenstruation: widget.isMenstruating,
      );

      await service.saveDailyLog(log);
    }
    // --------------------------------------

    if (mounted) {
      Navigator.of(context).pop();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SymptomRecommendationsPopup(selectedSymptoms: selectedSymptoms);
        },
      );
    }
  }

  Widget _buildSymptomItem(String title) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFF75270),
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
      value: _symptoms[title],
      onChanged: (bool? value) {
        setState(() {
          _symptoms[title] = value!;
        });
      },
      dense: true,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -4),
      activeColor: const Color(0xFFF75270),
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      side: const BorderSide(color: Color(0xFFF75270), width: 1.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFDEBD0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 48, 40, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Gejala yang Dirasakan?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF75270),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _symptoms.keys.map((symptom) => _buildSymptomItem(symptom)).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _showRecommendations,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF75270),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}