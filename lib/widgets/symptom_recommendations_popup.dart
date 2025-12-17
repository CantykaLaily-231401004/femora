import 'package:femora/widgets/music_player_popup.dart';
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

  void _handleMusicChoice(BuildContext context, bool playMusic) {
    Navigator.of(context).pop(); // Close the recommendations popup

    if (playMusic) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return const MusicPlayerPopup();
        },
      );
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicableRecommendations = selectedSymptoms
        .map((symptom) => recommendations[symptom])
        .where((rec) => rec != null)
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFDEBD0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 48, 32, 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Rekomendasi Untukmu 💖',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFF75270), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Berdasarkan kondisimu:',
                  style: TextStyle(color: Color(0xFFF75270), fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                if (applicableRecommendations.isNotEmpty)
                  ...applicableRecommendations.map(
                    (rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(rec!, style: const TextStyle(color: Color(0xFFF75270), fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w400)),
                    ),
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Tidak ada gejala spesifik, \nikuti rekomendasi umum ya!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFF75270), fontSize: 18, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 32,
            child: Column(
              children: [
                const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('🎵 ', style: TextStyle(fontSize: 24)), Text('Putar Musik Relaksasi?', style: TextStyle(color: Color(0xFFF75270), fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w500))]),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => _handleMusicChoice(context, true), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF75270), minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))), child: const Text('Iya', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: () => _handleMusicChoice(context, false), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))), child: const Text('Tidak', style: TextStyle(color: Color(0xFFF75270), fontSize: 18, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(icon: const Icon(Icons.close, color: Color(0xFFF75270)), onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst)),
          ),
        ],
      ),
    );
  }
}