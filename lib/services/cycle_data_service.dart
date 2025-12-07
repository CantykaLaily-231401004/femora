import 'package:femora/models/cycle_data.dart';
import 'package:flutter/foundation.dart';

// Singleton service to store user cycle data during the app's runtime.
class CycleDataService {
  static final CycleDataService _instance = CycleDataService._internal();
  factory CycleDataService() {
    return _instance;
  }
  CycleDataService._internal();

  // Notifiers for cycle data and user name
  final ValueNotifier<CycleData?> cycleDataNotifier = ValueNotifier(null);
  final ValueNotifier<String?> userNameNotifier = ValueNotifier(null);

  // New notifier to store daily mood (Date -> Emoticon)
  final ValueNotifier<Map<DateTime, String>> dailyMoodNotifier = ValueNotifier({});
  final ValueNotifier<Map<DateTime, List<String>>> dailySymptomsNotifier = ValueNotifier({});

  // Temporary data for the setup flow
  String? _tempFullName;
  DateTime? _tempBirthDate;
  int? _tempWeight;
  int? _tempPeriodDuration;
  int? _tempMinCycleLength;
  int? _tempMaxCycleLength;
  bool? _tempIsRegular;
  DateTime? _tempLastPeriodStart;

  // --- Methods for the setup flow ---
  void setFullName(String name) => _tempFullName = name;
  void setBirthDate(DateTime date) => _tempBirthDate = date;
  void setWeight(int weight) => _tempWeight = weight;
  void setPeriodDuration(int duration) => _tempPeriodDuration = duration;
  void setCycleLength({required int min, required int max, required bool isRegular}) {
    _tempMinCycleLength = min;
    _tempMaxCycleLength = max;
    _tempIsRegular = isRegular;
  }
  void setLastPeriodStart(DateTime date) => _tempLastPeriodStart = date;

  // Called at the end of the setup flow to "commit" the data
  void finalizeData() {
    if (_tempLastPeriodStart != null &&
        _tempPeriodDuration != null &&
        _tempMinCycleLength != null &&
        _tempMaxCycleLength != null &&
        _tempIsRegular != null) {
      cycleDataNotifier.value = CycleData(
        lastPeriodStart: _tempLastPeriodStart!,
        periodDuration: _tempPeriodDuration!,
        minCycleLength: _tempMinCycleLength!,
        maxCycleLength: _tempMaxCycleLength!,
        isRegular: _tempIsRegular!,
      );
    }
    
    if (_tempFullName != null) {
      userNameNotifier.value = _tempFullName;
    }
    
    _clearTempData();
  }

  void _clearTempData() {
    _tempFullName = null;
    _tempBirthDate = null;
    _tempWeight = null;
    _tempPeriodDuration = null;
    _tempMinCycleLength = null;
    _tempMaxCycleLength = null;
    _tempIsRegular = null;
    _tempLastPeriodStart = null;
  }

  // --- Methods for Daily Check-in ---
  void setMoodForDay(DateTime day, String mood) {
    final currentMoods = Map<DateTime, String>.from(dailyMoodNotifier.value);
    // Normalize the date to remove time information
    final normalizedDay = DateTime(day.year, day.month, day.day);
    currentMoods[normalizedDay] = mood;
    dailyMoodNotifier.value = currentMoods;
  }

  String? getMoodForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return dailyMoodNotifier.value[normalizedDay];
  }

  void setSymptomsForDay(DateTime day, List<String> symptoms) {
    final currentSymptoms = Map<DateTime, List<String>>.from(dailySymptomsNotifier.value);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    currentSymptoms[normalizedDay] = symptoms;
    dailySymptomsNotifier.value = currentSymptoms;
  }
}
