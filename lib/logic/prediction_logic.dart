import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CyclePrediction {
  final DateTime lastPeriodStart;
  final int periodDuration;
  final int minCycleLength;
  final int maxCycleLength;
  final bool isRegular;
  
  DateTime? predictedPeriodStart;
  DateTime? predictedPeriodEnd;
  DateTime? earliestPeriodStart;
  DateTime? latestPeriodStart;
  
  final List<PeriodRecord> historicalPeriods;
  final int averageCycleFromHistory;

  CyclePrediction({
    required this.lastPeriodStart,
    required this.periodDuration,
    required this.minCycleLength,
    required this.maxCycleLength,
    required this.isRegular,
    this.historicalPeriods = const [],
  }) : averageCycleFromHistory = _calculateAverageCycle(historicalPeriods) {
    _calculate();
  }

  static int _calculateAverageCycle(List<PeriodRecord> periods) {
    if (periods.length < 2) return 0;
    
    int totalDays = 0;
    int count = 0;
    
    for (int i = 1; i < periods.length; i++) {
      int daysBetween = periods[i].startDate.difference(periods[i - 1].startDate).inDays;
      if (daysBetween >= 21 && daysBetween <= 35) {
        totalDays += daysBetween;
        count++;
      }
    }
    
    return count > 0 ? (totalDays / count).round() : 0;
  }

  void _calculate() {
    int avgCycle;
    
    if (averageCycleFromHistory > 0) {
      avgCycle = averageCycleFromHistory;
      debugPrint('📊 Using historical average: $avgCycle days');
    } else if (isRegular) {
      avgCycle = minCycleLength;
    } else {
      avgCycle = ((minCycleLength + maxCycleLength) / 2).round();
    }

    predictedPeriodStart = lastPeriodStart.add(Duration(days: avgCycle));
    predictedPeriodEnd = predictedPeriodStart!.add(Duration(days: periodDuration - 1));

    if (!isRegular || averageCycleFromHistory == 0) {
      earliestPeriodStart = lastPeriodStart.add(Duration(days: minCycleLength));
      latestPeriodStart = lastPeriodStart.add(Duration(days: maxCycleLength));
    } else {
      earliestPeriodStart = predictedPeriodStart!.subtract(const Duration(days: 2));
      latestPeriodStart = predictedPeriodStart!.add(const Duration(days: 2));
    }

    debugPrint('🔮 Next period predicted: ${predictedPeriodStart?.toString().split(' ')[0]}');
  }

  // ✅ FACTORY METHOD YANG DIPERBARUI
  static Future<CyclePrediction> fromHistoricalData({
    required String userId,
    required int defaultPeriodDuration,
    required int defaultMinCycle,
    required int defaultMaxCycle,
    required bool defaultIsRegular,
  }) async {
    // Ambil SEMUA periode, baik aktif maupun tidak
    final allPeriods = await _fetchAllPeriods(userId);
    // Ambil periode yang sudah SELESAI untuk hitung rata-rata
    final completedPeriods = allPeriods.where((p) => p.endDate != null).toList();
    
    DateTime lastStart;
    int periodDuration;
    
    if (allPeriods.isNotEmpty) {
      // Patokan prediksi SELALU dari periode terbaru (aktif atau tidak)
      lastStart = allPeriods.first.startDate;
      periodDuration = allPeriods.first.duration ?? defaultPeriodDuration;
    } else {
      // Fallback ke data setup jika tidak ada data sama sekali
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final cycleData = userDoc.data()?['cycleData'];
      lastStart = (cycleData?['lastPeriodStart'] as Timestamp? ?? Timestamp.now()).toDate();
      periodDuration = defaultPeriodDuration;
    }

    return CyclePrediction(
      lastPeriodStart: lastStart,
      periodDuration: periodDuration,
      minCycleLength: defaultMinCycle,
      maxCycleLength: defaultMaxCycle,
      isRegular: defaultIsRegular,
      // Kalkulasi rata-rata HANYA dari periode yang sudah selesai
      historicalPeriods: completedPeriods,
    );
  }

  // ✅ HELPER BARU: Ambil SEMUA periode (aktif & tidak aktif)
  static Future<List<PeriodRecord>> _fetchAllPeriods(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('menstruation_periods')
          .where('userId', isEqualTo: userId)
          .orderBy('startDate', descending: true) // Terbaru di atas
          .limit(7) // Ambil 7 terakhir (6 untuk kalkulasi, 1 untuk patokan)
          .get();

      return snapshot.docs.map((doc) => PeriodRecord.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error fetching all periods: $e');
      return [];
    }
  }
}

class PeriodRecord {
  final DateTime startDate;
  final DateTime? endDate;
  final int? duration;

  PeriodRecord({
    required this.startDate,
    this.endDate,
    this.duration,
  });

  factory PeriodRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PeriodRecord(
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null ? (data['endDate'] as Timestamp).toDate() : null,
      duration: data['duration'] as int?,
    );
  }
}
