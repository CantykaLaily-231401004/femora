import 'package:flutter/material.dart';

class SymptomRecommendationsPopup extends StatelessWidget {
  final List<String> selectedSymptoms;

  const SymptomRecommendationsPopup({Key? key, required this.selectedSymptoms}) : super(key: key);

  Map<String, String> get recommendations => {
        'Nyeri perut/kram': '✅ Kompres air hangat untuk nyeri perut',
        'Sakit kepala/pusing': '✅ Minum air putih yang cukup',
        'Kelelahan': '✅ Istirahat setidaknya 15 menit',
        'Mood Swing': '✅ Lakukan aktivitas yang menenangkan',
        'Nyeri Punggung': '✅ Lakukan peregangan ringan',
        'Kembung': '✅ Hindari makanan tinggi garam',
      };

  @override
  Widget build(BuildContext context) {
    final applicableRecommendations = selectedSymptoms
        .map((symptom) => recommendations[symptom])
        .where((rec) => rec != null)
        .toList();

    return Container(
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
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 220), // Space for bottom buttons
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
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
                  const SizedBox(height: 24),
                  const Text(
                    'Berdasarkan kondisimu:',
                    style: TextStyle(
                      color: Color(0xFFF75270),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (applicableRecommendations.isNotEmpty)
                    ...applicableRecommendations.map(
                      (rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          rec!,
                          style: const TextStyle(
                            color: Color(0xFFF75270),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 32,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '🎵 ',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      'Putar Musik Relaksasi?',
                      style: TextStyle(
                        color: Color(0xFFF75270),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
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
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
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
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Color(0xFFF75270)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
