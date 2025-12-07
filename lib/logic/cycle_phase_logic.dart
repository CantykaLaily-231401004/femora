import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/logic/prediction_logic.dart';

class CyclePhaseLogic {
  static CyclePhaseData getCurrentPhase(CyclePrediction prediction, DateTime today) {
    const int lutealLength = 14;

    final todayNormalized = DateTime(today.year, today.month, today.day);

    // Ensure there is a next predicted start date
    if (prediction.predictedPeriodStart == null) {
      // Default or error case if prediction is not possible
      return CyclePhaseData.follicular; 
    }

    final cycleLength = prediction.predictedPeriodStart!.difference(prediction.lastPeriodStart).inDays;
    if (cycleLength <= 0) return CyclePhaseData.follicular; // Avoid division by zero or negative lengths

    final ovulationDayIndex = cycleLength - lutealLength;
    final ovulationDate = prediction.lastPeriodStart.add(Duration(days: ovulationDayIndex - 1));

    // Define phase date ranges
    final menstruationStart = prediction.lastPeriodStart;
    final menstruationEnd = menstruationStart.add(Duration(days: prediction.periodDuration - 1));
    final follicularEnd = ovulationDate;
    final ovulationWindowStart = ovulationDate.subtract(const Duration(days: 2));
    final ovulationWindowEnd = ovulationDate.add(const Duration(days: 1));
    final lutealStart = ovulationDate.add(const Duration(days: 1));
    final lutealEnd = prediction.predictedPeriodStart!.subtract(const Duration(days: 1));

    // Determine the current phase based on today's date
    if (!todayNormalized.isBefore(menstruationStart) && !todayNormalized.isAfter(menstruationEnd)) {
      return CyclePhaseData.menstrual;
    }
    if (!todayNormalized.isBefore(ovulationWindowStart) && !todayNormalized.isAfter(ovulationWindowEnd)) {
      return CyclePhaseData.ovulation;
    }
    if (!todayNormalized.isBefore(lutealStart) && !todayNormalized.isAfter(lutealEnd)) {
      return CyclePhaseData.luteal;
    }
    if (!todayNormalized.isBefore(prediction.lastPeriodStart) && !todayNormalized.isAfter(follicularEnd)) {
      return CyclePhaseData.follicular;
    }

    // Default case if today falls outside all defined phases
    return CyclePhaseData.follicular;
  }
}
