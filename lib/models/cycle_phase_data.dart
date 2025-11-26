import 'package:flutter/material.dart';

enum CyclePhase {
  menstruation,
  follicular,
  ovulation,
  luteal,
}

class CyclePhaseData {
  final CyclePhase phase;
  final String title;
  final String subtitle; // e.g. "Menstruasi dalam", "Ovulasi dalam"
  final String remainingTime; // e.g. "8 Hari", "5 Hari"
  final String descriptionTitle; // e.g. "Fase Luteal"
  final String whatHappens;
  final String tips;
  final Color primaryColor;
  final Color secondaryColor; // for text highlights
  final Color backgroundColor;
  final String iconUrl;

  CyclePhaseData({
    required this.phase,
    required this.title,
    required this.subtitle,
    required this.remainingTime,
    required this.descriptionTitle,
    required this.whatHappens,
    required this.tips,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    this.iconUrl = "https://placehold.co/35x35", // Default placeholder
  });

  static CyclePhaseData get follicular => CyclePhaseData(
    phase: CyclePhase.follicular,
    title: "Fase Folikular",
    subtitle: "Ovulasi dalam",
    remainingTime: "2 Hari",
    descriptionTitle: "Fase Folikular",
    whatHappens: "Energi meningkat, suasana hati membaik, kulit menjadi lebih cerah",
    tips: "Waktu yang tepat untuk olahraga intens dan memulai proyek baru",
    primaryColor: const Color(0xFF0F8DE1),
    secondaryColor: const Color(0xFF00385D),
    backgroundColor: const Color(0xBF0F8DE1), // Opacity handled in usage if needed, or use correct hex
  );

  static CyclePhaseData get ovulation => CyclePhaseData(
    phase: CyclePhase.ovulation,
    title: "Fase Ovulasi",
    subtitle: "Luteal dalam",
    remainingTime: "2 Hari",
    descriptionTitle: "Fase Ovulasi",
    whatHappens: "Energi puncak dan masa paling subur",
    tips: "Gunakan energi tinggi untuk kegiatan penting",
    primaryColor: const Color(0xFFFFAC28),
    secondaryColor: const Color(0xFFC67900),
    backgroundColor: const Color(0xFFFFAC28),
  );

  static CyclePhaseData get luteal => CyclePhaseData(
    phase: CyclePhase.luteal,
    title: "Fase Luteal",
    subtitle: "Menstruasi dalam",
    remainingTime: "8 Hari",
    descriptionTitle: "Fase Luteal",
    whatHappens: "Perubahan suasana hati, perut kembung, dan PMS (Sindrom Pra-Menstruasi)",
    tips: "Lakukan peregangan ringan, batasi kafein dan makanan asin, serta kelola stres dengan baik",
    primaryColor: const Color(0xFFFFB3BA),
    secondaryColor: const Color(0xFFFF3043),
    backgroundColor: const Color(0xFFFFB3BA),
  );
  
   static CyclePhaseData get menstruation => CyclePhaseData(
    phase: CyclePhase.menstruation,
    title: "Fase Menstruasi",
    subtitle: "Folikular dalam",
    remainingTime: "3 Hari",
    descriptionTitle: "Fase Menstruasi",
    whatHappens: "Perdarahan, kram perut, dan energi rendah",
    tips: "Istirahat yang cukup, kompres hangat untuk meredakan kram, dan minum banyak air",
    primaryColor: const Color(0xFFF75270),
    secondaryColor: const Color(0xFFDC143C),
    backgroundColor: const Color(0xFFF75270),
  );
}
