import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/logic/prediction_logic.dart';

class CyclePhaseLogic {
  static CyclePhaseData getDynamicPhaseData(CyclePrediction prediction, DateTime today) {
    final todayNormalized = DateTime(today.year, today.month, today.day);

    final lastPeriodStart = prediction.lastPeriodStart;
    final periodLength = prediction.periodDuration;
    final cycleLength = (prediction.minCycleLength + prediction.maxCycleLength) ~/ 2;

    if (cycleLength <= 0 || periodLength <= 0) {
      return CyclePhaseData.follicular.copyWith(subtitle: "Data siklus tidak lengkap", remainingTime: "-");
    }

    // 1. Calculation based on your provided formula
    const lutealLength = 14;
    final ovulationDay = cycleLength - lutealLength;
    final currentDayInCycle = todayNormalized.difference(lastPeriodStart).inDays + 1;

    // Handle cases where the cycle hasn't started yet (last period is in the future)
    if (currentDayInCycle <= 0) {
       int daysUntilStart = currentDayInCycle.abs();
       return CyclePhaseData.luteal.copyWith(subtitle: "Menstruasi dalam", remainingTime: "$daysUntilStart hari");
    }

    // 2. Define phase boundaries with a more realistic fertile window
    final menstrualEnd = periodLength;
    final ovulationStart = ovulationDay - 2; // Expanded 5-day fertile window
    final ovulationEnd = ovulationDay + 2;
    final follicularEnd = ovulationStart - 1;

    // 3. Determine the current phase and calculate the countdown to the *next* phase
    if (currentDayInCycle <= menstrualEnd) {
      // Current: Menstrual -> Next: Follicular
      int daysToNextPhase = menstrualEnd - currentDayInCycle + 1;
      return CyclePhaseData.menstrual.copyWith(
        subtitle: "Folikular dalam  ", // CORRECTED: Always points to the next phase
        remainingTime: "$daysToNextPhase hari",
      );
    } else if (currentDayInCycle <= follicularEnd) {
      // Current: Follicular -> Next: Ovulation
      int daysToNextPhase = ovulationStart - currentDayInCycle;
      return CyclePhaseData.follicular.copyWith(
        subtitle: "Ovulasi dalam  ",
        remainingTime: "${daysToNextPhase >= 0 ? daysToNextPhase : 0} hari",
      );
    } else if (currentDayInCycle <= ovulationEnd) {
      // Current: Ovulation -> Next: Luteal
      int daysToNextPhase = ovulationEnd - currentDayInCycle + 1;
      return CyclePhaseData.ovulation.copyWith(
        subtitle: "Luteal dalam  ",
        remainingTime: "${daysToNextPhase >= 0 ? daysToNextPhase : 0} hari",
      );
    } else {
      // Current: Luteal -> Next: Menstrual
      int daysToNextPhase = cycleLength - currentDayInCycle + 1;
      return CyclePhaseData.luteal.copyWith(
        subtitle: "Menstruasi dalam  ",
        remainingTime: "${daysToNextPhase >= 0 ? daysToNextPhase : 0} hari",
      );
    }
  }
}
