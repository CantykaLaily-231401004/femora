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
}
