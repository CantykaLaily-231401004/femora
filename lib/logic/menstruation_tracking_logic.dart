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
  Future<void> updateManualPeriod({
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    if (userId == null) throw Exception('User not authenticated');

    final startNormalized = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime? endNormalized;
    if (endDate != null) {
      endNormalized = DateTime(endDate.year, endDate.month, endDate.day);
    }

    final existingPeriod = await _getPeriodByDate(startNormalized);

    if (existingPeriod != null) {
      await _updateExistingPeriod(
        periodId: existingPeriod['id'],
        startDate: startNormalized,
        endDate: endNormalized,
      );
      debugPrint('✏️ Periode diupdate: ${existingPeriod['id']}');
    } else {
      final duration = endNormalized != null 
          ? endNormalized.difference(startNormalized).inDays + 1 
          : 7;

      await _createManualPeriod(
        startDate: startNormalized,
        endDate: endNormalized,
        duration: duration,
      );
      debugPrint('➕ Periode manual ditambahkan: $startNormalized');
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

  Future<Map<String, dynamic>?> _getPeriodByDate(DateTime date) async {
    if (userId == null) return null;
    
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final snapshot = await _firestore
          .collection('menstruation_periods')
          .where('userId', isEqualTo: userId)
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startDate', isLessThan: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();
      
      if (snapshot.docs.isEmpty) return null;
      
      final doc = snapshot.docs.first;
      return {'id': doc.id, ...doc.data()};
    } catch (e) {
      debugPrint('Error getting period by date: $e');
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

  Future<void> _createManualPeriod({
    required DateTime startDate,
    required DateTime? endDate,
    required int duration,
  }) async {
    if (userId == null) return;

    await _firestore.collection('menstruation_periods').add({
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
      'duration': duration,
      'isActive': endDate == null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateExistingPeriod({
    required String periodId,
    required DateTime startDate,
    required DateTime? endDate,
  }) async {
    if (userId == null) return;

    final updates = <String, dynamic>{
      'startDate': Timestamp.fromDate(startDate),
    };

    if (endDate != null) {
      final duration = endDate.difference(startDate).inDays + 1;
      updates['endDate'] = Timestamp.fromDate(endDate);
      updates['duration'] = duration;
      updates['isActive'] = false;
    }

    await _firestore.collection('menstruation_periods').doc(periodId).update(updates);
  }

  Future<bool> isMenstruationDay(DateTime date) async {
    if (userId == null) return false;
    
    final dateNormalized = DateTime(date.year, date.month, date.day);
    
    final snapshot = await _firestore
        .collection('menstruation_periods')
        .where('userId', isEqualTo: userId)
        .get();
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      DateTime startDate = (data['startDate'] as Timestamp).toDate();
      final startNormalized = DateTime(startDate.year, startDate.month, startDate.day);
      
      DateTime? endDate;
      if (data['endDate'] != null) {
        endDate = (data['endDate'] as Timestamp).toDate();
      } else if (data['isActive'] == true) {
        int duration = data['duration'] ?? 7;
        endDate = startDate.add(Duration(days: duration - 1));
      }
      
      if (endDate != null) {
        final endNormalized = DateTime(endDate.year, endDate.month, endDate.day);
        
        if (!dateNormalized.isBefore(startNormalized) && 
            !dateNormalized.isAfter(endNormalized)) {
          return true;
        }
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
