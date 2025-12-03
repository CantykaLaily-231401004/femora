import 'package:flutter/material.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/widgets/size_config.dart';

class CyclePhaseCard extends StatelessWidget {
  final CyclePhaseData data;

  const CyclePhaseCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    String getIconForPhase() {
      switch (data.title) {
        case 'Fase Menstruasi':
          return 'assets/images/fase_menstruasi.png';
        case 'Fase Folikular':
          return 'assets/images/fase_folikular.png';
        case 'Fase Ovulasi':
          return 'assets/images/fase_ovulasi.png';
        case 'Fase Luteal':
          return 'assets/images/fase_luteal.png';
        default:
          return 'assets/images/fase_folikular.png'; // Fallback icon
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF59A2D5), // Warna biru dari desain
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                getIconForPhase(),
                width: 48,
                height: 48,
              ),
              const SizedBox(width: 10),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ovulasi dalam ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '2 Hari', // Placeholder, ganti dengan data dinamis
                  style: const TextStyle(
                    color: Color(0xFF59A2D5),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Yang Terjadi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.whatHappens,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tips',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.tips,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
