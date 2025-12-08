import 'package:flutter/foundation.dart';

@immutable
class CycleData {
  final DateTime lastPeriodStart;
  final int periodDuration;
  final int minCycleLength;
  final int maxCycleLength;
  final bool isRegular;

  const CycleData({
    required this.lastPeriodStart,
    required this.periodDuration,
    required this.minCycleLength,
    required this.maxCycleLength,
    required this.isRegular,
  });

  // Factory constructor for creating a new CycleData instance from a map.
  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      lastPeriodStart: DateTime.parse(json['lastPeriodStart'] as String),
      periodDuration: json['periodDuration'] as int,
      minCycleLength: json['minCycleLength'] as int,
      maxCycleLength: json['maxCycleLength'] as int,
      isRegular: json['isRegular'] as bool,
    );
  }

  // Method to convert a CycleData instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'lastPeriodStart': lastPeriodStart.toIso8601String(),
      'periodDuration': periodDuration,
      'minCycleLength': minCycleLength,
      'maxCycleLength': maxCycleLength,
      'isRegular': isRegular,
    };
  }
}
