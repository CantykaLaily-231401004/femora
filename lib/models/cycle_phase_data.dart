import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';

enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
}

class CyclePhaseData {
  final CyclePhase phase;
  final String title;
  final String subtitle; // e.g., "Ovulasi dalam"
  final String remainingTime; // e.g., "2 Hari"
  final String descriptionTitle;
  final String whatHappens;
  final String tips;
  final Color primaryColor;
  final Color secondaryColor;
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

  CyclePhaseData copyWith({
    String? subtitle,
    String? remainingTime,
  }) {
    return CyclePhaseData(
      phase: phase,
      title: title,
      subtitle: subtitle ?? this.subtitle,
      remainingTime: remainingTime ?? this.remainingTime,
      descriptionTitle: descriptionTitle,
      whatHappens: whatHappens,
      tips: tips,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: backgroundColor,
      iconUrl: iconUrl,
    );
  }

  // --- Static templates for each phase ---

  static CyclePhaseData get menstrual => CyclePhaseData(
        phase: CyclePhase.menstrual,
        title: "Fase Menstruasi",
        subtitle: "Folikular dalam",
        remainingTime: "X Hari",
        descriptionTitle: "Yang Terjadi",
        whatHappens: "Dinding rahim meluruh, menyebabkan pendarahan. Tingkat estrogen dan progesteron sedang rendah.",
        tips: "Perbanyak istirahat, konsumsi makanan kaya zat besi, dan gunakan kompres hangat untuk meredakan kram.",
        primaryColor: const Color(0xFFF75270),
        secondaryColor: const Color(0xFFDC143C),
        backgroundColor: const Color(0xFFF75270), // Updated color
        iconUrl: AppAssets.faseMenstruasi,
      );

  static CyclePhaseData get follicular => CyclePhaseData(
        phase: CyclePhase.follicular,
        title: "Fase Folikular",
        subtitle: "Ovulasi dalam",
        remainingTime: "X Hari",
        descriptionTitle: "Yang Terjadi",
        whatHappens: "Tingkat estrogen mulai meningkat, membuat energimu kembali. Suasana hati membaik dan kulit lebih cerah.",
        tips: "Waktu yang tepat untuk berolahraga lebih intens, merencanakan kegiatan sosial, dan memulai proyek baru.",
        primaryColor: const Color(0xFF0F8DE1),
        secondaryColor: const Color(0xFF00385D),
        backgroundColor: const Color(0xBF62C0FF), // Updated color with transparency
        iconUrl: AppAssets.faseFolikular,
      );

  static CyclePhaseData get ovulation => CyclePhaseData(
        phase: CyclePhase.ovulation,
        title: "Fase Ovulasi",
        subtitle: "Luteal dalam",
        remainingTime: "X Hari",
        descriptionTitle: "Yang Terjadi",
        whatHappens: "Puncak energi dan masa paling subur. Sel telur dilepaskan dari ovarium.",
        tips: "Jika berencana hamil, ini waktu terbaik. Energi sedang di puncak, cocok untuk aktivitas fisik yang berat.",
        primaryColor: const Color(0xFFFFAC28),
        secondaryColor: const Color(0xFFC67900),
        backgroundColor: const Color(0xFFFFAC29), // Updated color
        iconUrl: AppAssets.faseOvulasi,
      );

  static CyclePhaseData get luteal => CyclePhaseData(
        phase: CyclePhase.luteal,
        title: "Fase Luteal",
        subtitle: "Menstruasi dalam",
        remainingTime: "X Hari",
        descriptionTitle: "Yang Terjadi",
        whatHappens: "Tubuh mempersiapkan kemungkinan kehamilan. Jika tidak terjadi, Anda mungkin mengalami gejala PMS.",
        tips: "Lakukan olahraga ringan seperti yoga atau jalan santai. Konsumsi makanan yang bisa mengurangi kembung.",
        primaryColor: const Color(0xFFFFB3BA),
        secondaryColor: const Color(0xFFFF3043),
        backgroundColor: const Color(0xFFFFB3BA), // Updated color
        iconUrl: AppAssets.faseLuteal,
      );
}
