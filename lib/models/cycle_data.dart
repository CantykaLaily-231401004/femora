import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Helper function to handle both Timestamp and String
  static DateTime _parseTimestamp(dynamic dateValue) {
    if (dateValue is Timestamp) {
      return dateValue.toDate();
    } else if (dateValue is String) {
      return DateTime.parse(dateValue);
    } else {
      // Fallback or throw error if the type is unexpected
      throw Exception('Invalid date format in database: ${dateValue.runtimeType}');
    }
  }

  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      lastPeriodStart: _parseTimestamp(json['lastPeriodStart']),
      periodDuration: json['periodDuration'] as int,
      minCycleLength: json['minCycleLength'] as int,
      maxCycleLength: json['maxCycleLength'] as int,
      isRegular: json['isRegular'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    // Always write as Timestamp for consistency going forward
    return {
      'lastPeriodStart': Timestamp.fromDate(lastPeriodStart),
      'periodDuration': periodDuration,
      'minCycleLength': minCycleLength,
      'maxCycleLength': maxCycleLength,
      'isRegular': isRegular,
    };
  }
}
