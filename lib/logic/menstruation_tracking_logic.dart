import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenstruationTrackingLogic {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  /// UPDATE STATUS MENSTRUASI DARI DAILY CHECKIN
  Future<void> updateMenstruationStatus({
    required DateTime checkInDate,
    required bool isMenstruating,
  }) async {
    if (userId == null) throw Exception('User not authenticated');

    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) throw Exception('User data not found');

    final cycleData = userDoc.data()!['cycleData'];
    if (cycleData == null) throw Exception('Cycle data not found');

    int defaultPeriodDuration = cycleData['periodDuration'] as int;
    final checkInDateNormalized = DateTime(
      checkInDate.year, 
      checkInDate.month, 
      checkInDate.day
    );

    final activePeriod = await _getActivePeriod();

    if (isMenstruating) {
      if (activePeriod == null) {
        await _startNewPeriod(
          startDate: checkInDateNormalized, 
          defaultDuration: defaultPeriodDuration
        );
        debugPrint('🟢 Periode baru dimulai: $checkInDateNormalized');
      } else {
        debugPrint('✅ Konfirmasi: Masih dalam periode aktif');
      }
    } else {
      if (activePeriod != null) {
        await _endPeriod(
          periodId: activePeriod['id'],
          endDate: checkInDateNormalized.subtract(const Duration(days: 1)),
        );
        debugPrint('🔴 Periode diakhiri: ${activePeriod['id']}');
      } else {
        debugPrint('✅ Konfirmasi: Tidak sedang menstruasi');
      }
    }
  }

  /// UPDATE MANUAL DARI EDIT CYCLE SCREEN
  /// This will delete any overlapping periods and create a new one.
  Future<void> updateManualPeriod({
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    if (userId == null) throw Exception('User not authenticated');

    final startNormalized = DateTime(startDate.year, startDate.month, startDate.day);
    final endNormalized = endDate != null
        ? DateTime(endDate.year, endDate.month, endDate.day)
        : null;

    // 1. Find and delete all overlapping periods.
    await _deleteOverlappingPeriods(startNormalized, endNormalized);

    // 2. Create the new period.
    final duration = endNormalized != null
        ? endNormalized.difference(startNormalized).inDays + 1
        : 7; // Default duration if only start date is provided

    await _firestore.collection('menstruation_periods').add({
      'userId': userId,
      'startDate': Timestamp.fromDate(startNormalized),
      'endDate': endNormalized != null ? Timestamp.fromDate(endNormalized) : null,
      'duration': duration,
      'isActive': endNormalized == null, // Active if no end date
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint('🔄 Periode manual diperbarui: $startNormalized - $endNormalized');
  }

  /// Helper to find and delete periods overlapping with the given range.
  Future<void> _deleteOverlappingPeriods(DateTime startDate, DateTime? endDate) async {
      if (userId == null) return;

      final effectiveEndDate = endDate ?? startDate;

      // We query for periods that could potentially overlap.
      // This query is broad to work around Firestore limitations and requires client-side filtering.
      // It gets all periods that start before the new period ends.
      final snapshot = await _firestore
          .collection('menstruation_periods')
          .where('userId', isEqualTo: userId)
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(effectiveEndDate))
          .get();

      final batch = _firestore.batch();
      int deleteCount = 0;

      for (final doc in snapshot.docs) {
          final data = doc.data();
          final docStartDate = (data['startDate'] as Timestamp).toDate();

          DateTime? docEndDate;
          if (data['endDate'] != null) {
              docEndDate = (data['endDate'] as Timestamp).toDate();
          } else if (data['isActive'] == true) {
              final duration = data['duration'] as int? ?? 7;
              docEndDate = docStartDate.add(Duration(days: duration - 1));
          }

          // Overlap check: (start1 <= end2) && (start2 <= end1)
          if (docEndDate != null) {
              final periodsOverlap =
                  !docStartDate.isAfter(effectiveEndDate) && !startDate.isAfter(docEndDate);

              if (periodsOverlap) {
                  batch.delete(doc.reference);
                  deleteCount++;
              }
          }
      }

      if (deleteCount > 0) {
        await batch.commit();
        debugPrint('🗑️ Dihapus $deleteCount periode yang tumpang tindih.');
      }
  }

  Future<Map<String, dynamic>?> _getActivePeriod() async {
    if (userId == null) return null;
    try {
      final snapshot = await _firestore
          .collection('menstruation_periods')
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) return null;
      
      final doc = snapshot.docs.first;
      return {'id': doc.id, ...doc.data()};
    } catch (e) {
      debugPrint('Error getting active period: $e');
      return null;
    }
  }

  Future<void> _startNewPeriod({
    required DateTime startDate,
    required int defaultDuration,
  }) async {
    if (userId == null) return;
    
    await _closeAllActivePeriods();
    
    await _firestore.collection('menstruation_periods').add({
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': null,
      'duration': defaultDuration,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _endPeriod({
    required String periodId,
    required DateTime endDate,
  }) async {
    if (userId == null) return;
    
    final periodDoc = await _firestore
        .collection('menstruation_periods')
        .doc(periodId)
        .get();
    
    if (!periodDoc.exists) return;
    
    final periodData = periodDoc.data()!;
    DateTime startDate = (periodData['startDate'] as Timestamp).toDate();
    final actualDuration = endDate.difference(startDate).inDays + 1;
    
    await _firestore.collection('menstruation_periods').doc(periodId).update({
      'endDate': Timestamp.fromDate(endDate),
      'duration': actualDuration > 0 ? actualDuration : 1,
      'isActive': false,
    });
  }

  Future<void> _closeAllActivePeriods() async {
    if (userId == null) return;
    
    final snapshot = await _firestore
        .collection('menstruation_periods')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      DateTime startDate = (data['startDate'] as Timestamp).toDate();
      int defaultDuration = data['duration'] ?? 7;
      DateTime estimatedEnd = startDate.add(Duration(days: defaultDuration - 1));
      
      await doc.reference.update({
        'endDate': Timestamp.fromDate(estimatedEnd),
        'isActive': false,
      });
    }
  }

  Future<bool> isMenstruationDay(DateTime date) async {
    if (userId == null) return false;

    final dateNormalized = DateTime(date.year, date.month, date.day);

    // This optimized query checks for periods that could contain 'date'.
    // It finds the most recent period that started on or before the given date.
    final snapshot = await _firestore
        .collection('menstruation_periods')
        .where('userId', isEqualTo: userId)
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(dateNormalized))
        .orderBy('startDate', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return false; // No period started on or before this date.
    }

    final doc = snapshot.docs.first;
    final data = doc.data();
    DateTime startDate = (data['startDate'] as Timestamp).toDate();

    DateTime? endDate;
    if (data['endDate'] != null) {
      endDate = (data['endDate'] as Timestamp).toDate();
    } else if (data['isActive'] == true) {
      // If the period is active, estimate its end date.
      int duration = data['duration'] ?? 7;
      endDate = startDate.add(Duration(days: duration - 1));
    }

    if (endDate != null) {
      final startNormalized = DateTime(startDate.year, startDate.month, startDate.day);
      final endNormalized = DateTime(endDate.year, endDate.month, endDate.day);

      // Check if the given date is within the period range (inclusive).
      if (!dateNormalized.isBefore(startNormalized) &&
          !dateNormalized.isAfter(endNormalized)) {
        return true;
      }
    }

    return false;
  }

  Future<DateTime?> getMostRecentPeriodStartDate() async {
    if (userId == null) return null;
    
    try {
      final snapshot = await _firestore
          .collection('menstruation_periods')
          .where('userId', isEqualTo: userId)
          .orderBy('startDate', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return (data['startDate'] as Timestamp).toDate();
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting most recent period start date: $e');
      return null;
    }
  }

  Future<bool> isCurrentlyMenstruating() async {
    final today = DateTime.now();
    return await isMenstruationDay(today);
  }
}
