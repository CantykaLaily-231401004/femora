import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/logic/prediction_logic.dart';

class CyclePhaseLogic {
  /// Menghitung fase siklus dinamis berdasarkan prediksi dan data aktual
  static CyclePhaseData getDynamicPhaseData(
    CyclePrediction prediction, 
    DateTime today,
    {bool? isCurrentlyMenstruating}
  ) {
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final lastPeriodStart = prediction.lastPeriodStart;
    final periodLength = prediction.periodDuration;
    
    // Gunakan rata-rata historis jika ada, jika tidak gunakan input setup
    final cycleLength = prediction.averageCycleFromHistory > 0 
        ? prediction.averageCycleFromHistory 
        : (prediction.minCycleLength + prediction.maxCycleLength) ~/ 2;

    if (cycleLength <= 0 || periodLength <= 0) {
      return CyclePhaseData.follicular.copyWith(
        subtitle: "Data siklus tidak lengkap", 
        remainingTime: "-"
      );
    }

    // PRIORITAS TERTINGGI: Jika sedang menstruasi HARI INI (dari daily checkin)
    if (isCurrentlyMenstruating == true) {
      // Hitung sisa hari menstruasi berdasarkan durasi default
      final daysRemaining = periodLength - 1; // Hari ini adalah hari ke-1
      return CyclePhaseData.menstrual.copyWith(
        subtitle: "Folikular dalam",
        remainingTime: "$daysRemaining hari",
      );
    }

    // Hitung hari dalam siklus
    final currentDayInCycle = todayNormalized.difference(lastPeriodStart).inDays + 1;

    // Handle jika tanggal periode belum tiba
    if (currentDayInCycle <= 0) {
      int daysUntilStart = currentDayInCycle.abs();
      return CyclePhaseData.luteal.copyWith(
        subtitle: "Menstruasi dalam", 
        remainingTime: "$daysUntilStart hari"
      );
    }

    // Define fase boundaries
    const lutealLength = 14;
    final ovulationDay = cycleLength - lutealLength;
    final menstrualEnd = periodLength;
    final ovulationStart = ovulationDay - 2;
    final ovulationEnd = ovulationDay + 2;
    final follicularEnd = ovulationStart - 1;

    // CEK: Apakah masih dalam periode menstruasi?
    if (currentDayInCycle <= menstrualEnd) {
      int daysToNextPhase = menstrualEnd - currentDayInCycle + 1;
      return CyclePhaseData.menstrual.copyWith(
        subtitle: "Folikular dalam",
        remainingTime: "$daysToNextPhase hari",
      );
    } 
    // CEK: Apakah dalam fase folikular?
    else if (currentDayInCycle <= follicularEnd) {
      int daysToNextPhase = ovulationStart - currentDayInCycle;
      return CyclePhaseData.follicular.copyWith(
        subtitle: "Ovulasi dalam",
        remainingTime: "${daysToNextPhase >= 0 ? daysToNextPhase : 0} hari",
      );
    } 
    // CEK: Apakah dalam fase ovulasi?
    else if (currentDayInCycle <= ovulationEnd) {
      int daysToNextPhase = ovulationEnd - currentDayInCycle + 1;
      return CyclePhaseData.ovulation.copyWith(
        subtitle: "Luteal dalam",
        remainingTime: "${daysToNextPhase >= 0 ? daysToNextPhase : 0} hari",
      );
    } 
    // CEK: Fase luteal
    else {
      int daysToNextPhase = cycleLength - currentDayInCycle + 1;
      
      // Jika sudah melewati siklus normal, tandai sebagai "terlambat"
      if (daysToNextPhase < 0) {
        return CyclePhaseData.luteal.copyWith(
          subtitle: "Menstruasi",
          remainingTime: "Terlambat ${daysToNextPhase.abs()} hari",
        );
      }
      
      return CyclePhaseData.luteal.copyWith(
        subtitle: "Menstruasi dalam",
        remainingTime: "$daysToNextPhase hari",
      );
    }
  }

  /// Prediksi fase untuk tanggal tertentu (untuk kalender)
  static CyclePhase predictPhaseForDate(
    DateTime date,
    CyclePrediction prediction,
  ) {
    final dateNormalized = DateTime(date.year, date.month, date.day);
    final lastPeriodStart = prediction.lastPeriodStart;
    final periodLength = prediction.periodDuration;
    final cycleLength = prediction.averageCycleFromHistory > 0 
        ? prediction.averageCycleFromHistory 
        : (prediction.minCycleLength + prediction.maxCycleLength) ~/ 2;

    final currentDayInCycle = dateNormalized.difference(lastPeriodStart).inDays + 1;

    const lutealLength = 14;
    final ovulationDay = cycleLength - lutealLength;
    final menstrualEnd = periodLength;
    final ovulationStart = ovulationDay - 2;
    final ovulationEnd = ovulationDay + 2;
    final follicularEnd = ovulationStart - 1;

    if (currentDayInCycle <= 0 || currentDayInCycle > cycleLength) {
      return CyclePhase.luteal; // Default jika di luar range
    }

    if (currentDayInCycle <= menstrualEnd) {
      return CyclePhase.menstrual;
    } else if (currentDayInCycle <= follicularEnd) {
      return CyclePhase.follicular;
    } else if (currentDayInCycle <= ovulationEnd) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }
}
