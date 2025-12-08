import 'dart:convert';

import 'package:femora/models/cycle_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final ValueNotifier<DateTime?> birthDateNotifier = ValueNotifier(null);
  final ValueNotifier<int?> weightNotifier = ValueNotifier(null);
  final ValueNotifier<String?> phoneNumberNotifier = ValueNotifier(null);

  // New notifier to store daily mood (Date -> Emoticon)
  final ValueNotifier<Map<DateTime, String>> dailyMoodNotifier = ValueNotifier({});
  final ValueNotifier<Map<DateTime, List<String>>> dailySymptomsNotifier = ValueNotifier({});

  // Temporary data for the setup flow
  String? _tempFullName;
  DateTime? _tempBirthDate;
  int? _tempWeight;
  String? _tempPhoneNumber;
  int? _tempPeriodDuration;
  int? _tempMinCycleLength;
  int? _tempMaxCycleLength;
  bool? _tempIsRegular;
  DateTime? _tempLastPeriodStart;

  // --- Methods for the setup flow ---
  void setFullName(String name) => _tempFullName = name;
  void setBirthDate(DateTime date) => _tempBirthDate = date;
  void setWeight(int weight) => _tempWeight = weight;
  void setPhoneNumber(String phoneNumber) => _tempPhoneNumber = phoneNumber;
  void setPeriodDuration(int duration) => _tempPeriodDuration = duration;
  void setCycleLength({required int min, required int max, required bool isRegular}) {
    _tempMinCycleLength = min;
    _tempMaxCycleLength = max;
    _tempIsRegular = isRegular;
  }
  void setLastPeriodStart(DateTime date) => _tempLastPeriodStart = date;

  // Called at the end of the setup flow to "commit" the data
  void finalizeData() {
    if (_tempFullName != null) {
      userNameNotifier.value = _tempFullName;
    }
    if (_tempBirthDate != null) {
      birthDateNotifier.value = _tempBirthDate;
    }
    if (_tempWeight != null) {
      weightNotifier.value = _tempWeight;
    }
    if (_tempPhoneNumber != null) {
      phoneNumberNotifier.value = _tempPhoneNumber;
    }

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

    _clearTempData();
    saveDataToPrefs();
  }

  void _clearTempData() {
    _tempFullName = null;
    _tempBirthDate = null;
    _tempWeight = null;
    _tempPhoneNumber = null;
    _tempPeriodDuration = null;
    _tempMinCycleLength = null;
    _tempMaxCycleLength = null;
    _tempIsRegular = null;
    _tempLastPeriodStart = null;
  }

  void updateUserName(String newName) {
    userNameNotifier.value = newName;
    saveDataToPrefs();
  }

  void updateBirthDate(DateTime newDate) {
    birthDateNotifier.value = newDate;
    saveDataToPrefs();
  }

  void updateWeight(int newWeight) {
    weightNotifier.value = newWeight;
    saveDataToPrefs();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    phoneNumberNotifier.value = newPhoneNumber;
    saveDataToPrefs();
  }

  // --- Methods for Daily Check-in ---
  void setMoodForDay(DateTime day, String mood) {
    final currentMoods = Map<DateTime, String>.from(dailyMoodNotifier.value);
    final normalizedDay = DateTime(day.year, day.month, day.day);
    currentMoods[normalizedDay] = mood;
    dailyMoodNotifier.value = currentMoods;
    saveDataToPrefs();
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
    saveDataToPrefs();
  }

  // ---
  // Persistence with SharedPreferences
  // ---

  static const String _userNameKey = 'userName';
  static const String _cycleDataKey = 'cycleData';
  static const String _dailyMoodKey = 'dailyMood';
  static const String _dailySymptomsKey = 'dailySymptoms';
  static const String _birthDateKey = 'birthDate';
  static const String _weightKey = 'weight';
  static const String _phoneNumberKey = 'phoneNumber';

  Future<void> saveDataToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (userNameNotifier.value != null) {
      prefs.setString(_userNameKey, userNameNotifier.value!);
    }
    if (birthDateNotifier.value != null) {
      prefs.setString(_birthDateKey, birthDateNotifier.value!.toIso8601String());
    }
    if (weightNotifier.value != null) {
      prefs.setInt(_weightKey, weightNotifier.value!);
    }
    if (phoneNumberNotifier.value != null) {
      prefs.setString(_phoneNumberKey, phoneNumberNotifier.value!);
    }
    if (cycleDataNotifier.value != null) {
      prefs.setString(_cycleDataKey, json.encode(cycleDataNotifier.value!.toJson()));
    }

    final encodedMoods = dailyMoodNotifier.value.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString(_dailyMoodKey, json.encode(encodedMoods));

    final encodedSymptoms = dailySymptomsNotifier.value.map((key, value) => MapEntry(key.toIso8601String(), value));
    prefs.setString(_dailySymptomsKey, json.encode(encodedSymptoms));
  }

  Future<void> loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Load user name
    if (prefs.containsKey(_userNameKey)) {
      userNameNotifier.value = prefs.getString(_userNameKey);
    }

    // Load birth date
    if (prefs.containsKey(_birthDateKey)) {
      final dateString = prefs.getString(_birthDateKey);
      if (dateString != null) {
        birthDateNotifier.value = DateTime.parse(dateString);
      }
    }

    // Load weight
    if (prefs.containsKey(_weightKey)) {
      weightNotifier.value = prefs.getInt(_weightKey);
    }

    // Load phone number
    if (prefs.containsKey(_phoneNumberKey)) {
      phoneNumberNotifier.value = prefs.getString(_phoneNumberKey);
    }

    // Load cycle data
    if (prefs.containsKey(_cycleDataKey)) {
      final data = json.decode(prefs.getString(_cycleDataKey)!);
      cycleDataNotifier.value = CycleData.fromJson(data);
    }

    // Load daily moods
    if (prefs.containsKey(_dailyMoodKey)) {
      final Map<String, dynamic> decodedMoods = json.decode(prefs.getString(_dailyMoodKey)!);
      dailyMoodNotifier.value = decodedMoods.map((key, value) => MapEntry(DateTime.parse(key), value as String));
    }

    // Load daily symptoms
    if (prefs.containsKey(_dailySymptomsKey)) {
      final Map<String, dynamic> decodedSymptoms = json.decode(prefs.getString(_dailySymptomsKey)!);
      dailySymptomsNotifier.value = decodedSymptoms.map((key, value) => MapEntry(DateTime.parse(key), (value as List).cast<String>()));
    }

  }
}