import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:femora/models/cycle_data.dart';
import 'package:femora/models/daily_log_model.dart';
import 'package:flutter/foundation.dart';

class CycleDataService {
  static final CycleDataService _instance = CycleDataService._internal();
  factory CycleDataService() => _instance;
  CycleDataService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Notifiers
  final ValueNotifier<CycleData?> cycleDataNotifier = ValueNotifier(null);
  final ValueNotifier<String?> userNameNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime?> birthDateNotifier = ValueNotifier(null);
  final ValueNotifier<int?> weightNotifier = ValueNotifier(null);
  final ValueNotifier<String?> phoneNumberNotifier = ValueNotifier(null);

  // Untuk Daily Check-In UI
  final ValueNotifier<Map<DateTime, String>> dailyMoodNotifier = ValueNotifier({});

  // Temporary data untuk setup flow
  String? _tempFullName;
  DateTime? _tempBirthDate;
  int? _tempWeight;
  String? _tempPhoneNumber;
  int? _tempPeriodDuration;
  int? _tempMinCycleLength;
  int? _tempMaxCycleLength;
  bool? _tempIsRegular;
  DateTime? _tempLastPeriodStart;

  String? get userId => _auth.currentUser?.uid;

  // ========== CLEAR DATA SAAT LOGOUT (PENTING!) ==========
  void clearAllData() {
    debugPrint('🧹 CLEARING ALL DATA...');

    // Clear notifiers
    cycleDataNotifier.value = null;
    userNameNotifier.value = null;
    birthDateNotifier.value = null;
    weightNotifier.value = null;
    phoneNumberNotifier.value = null;
    dailyMoodNotifier.value = {};

    // Clear temp data
    _clearTempData();

    debugPrint('✅ All data cleared!');
  }

  // ========== SETUP FLOW METHODS ==========
  void setFullName(String name) {
    debugPrint('📝 Setting full name: $name');
    _tempFullName = name;
  }

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

  Future<void> finalizeData() async {
    if (userId == null) throw Exception('User not authenticated');

    debugPrint('💾 Finalizing data for user: $userId');

    try {
      // Save user profile
      await _firestore.collection('users').doc(userId).set({
        'fullName': _tempFullName,
        'birthDate': _tempBirthDate != null ? Timestamp.fromDate(_tempBirthDate!) : null,
        'weight': _tempWeight,
        'phoneNumber': _tempPhoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Save cycle data
      if (_tempLastPeriodStart != null && _tempPeriodDuration != null) {
        final cycleData = CycleData(
          lastPeriodStart: _tempLastPeriodStart!,
          periodDuration: _tempPeriodDuration!,
          minCycleLength: _tempMinCycleLength!,
          maxCycleLength: _tempMaxCycleLength!,
          isRegular: _tempIsRegular!,
        );

        await _firestore.collection('users').doc(userId).update({
          'cycleData': cycleData.toJson(),
        });

        cycleDataNotifier.value = cycleData;
        debugPrint('✅ Cycle data saved!');
      }

      // Update local notifiers
      userNameNotifier.value = _tempFullName;
      birthDateNotifier.value = _tempBirthDate;
      weightNotifier.value = _tempWeight;
      phoneNumberNotifier.value = _tempPhoneNumber;

      _clearTempData();
      debugPrint('✅ Data finalized successfully!');
    } catch (e) {
      debugPrint('❌ Error finalizing data: $e');
      rethrow;
    }
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

  // ========== LOAD DATA DARI FIREBASE ==========
  Future<void> loadUserData() async {
    if (userId == null) {
      debugPrint('⚠️ Cannot load user data: userId is null');
      return;
    }

    debugPrint('📥 Loading user data for: $userId');

    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        debugPrint('⚠️ User document does not exist');
        return;
      }

      final data = doc.data()!;

      userNameNotifier.value = data['fullName'];
      birthDateNotifier.value = data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate()
          : null;
      weightNotifier.value = data['weight'];
      phoneNumberNotifier.value = data['phoneNumber'];

      if (data['cycleData'] != null) {
        cycleDataNotifier.value = CycleData.fromJson(data['cycleData']);
        debugPrint('✅ Cycle data loaded!');
      }

      debugPrint('✅ User data loaded successfully!');
    } catch (e) {
      debugPrint('❌ Error loading user data: $e');
    }
  }

  // ========== UPDATE USER PROFILE ==========
  Future<void> updateUserName(String newName) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(userId).update({
      'fullName': newName,
    });
    userNameNotifier.value = newName;
  }

  Future<void> updateBirthDate(DateTime newDate) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(userId).update({
      'birthDate': Timestamp.fromDate(newDate),
    });
    birthDateNotifier.value = newDate;
  }

  Future<void> updateWeight(int newWeight) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(userId).update({
      'weight': newWeight,
    });
    weightNotifier.value = newWeight;
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(userId).update({
      'phoneNumber': newPhoneNumber,
    });
    phoneNumberNotifier.value = newPhoneNumber;
  }

  // ========== UPDATE CYCLE DATA ==========
  Future<void> updateCycleData(CycleData newCycleData) async {
    if (userId == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(userId).update({
      'cycleData': newCycleData.toJson(),
    });
    cycleDataNotifier.value = newCycleData;
  }

  // ========== DAILY CHECK-IN ==========
  Future<void> saveDailyLog(DailyLogModel log) async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('daily_logs')
          .doc(log.id)
          .set(log.toMap());

      final normalizedDay = DateTime(log.date.year, log.date.month, log.date.day);
      final currentMoods = Map<DateTime, String>.from(dailyMoodNotifier.value);
      currentMoods[normalizedDay] = log.mood;
      dailyMoodNotifier.value = currentMoods;

      debugPrint('✅ Daily log saved: ${log.id}');
    } catch (e) {
      debugPrint('❌ Error saving daily log: $e');
      rethrow;
    }
  }

  Future<bool> hasCheckedInToday() async {
    if (userId == null) return false;

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final snapshot = await _firestore
          .collection('daily_logs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking daily log: $e');
      return false;
    }
  }

  String? getMoodForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return dailyMoodNotifier.value[normalizedDay];
  }

  Future<void> loadMoodsForMonth(DateTime month) async {
    if (userId == null) return;

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    try {
      final snapshot = await _firestore
          .collection('daily_logs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      final moodMap = <DateTime, String>{};
      for (var doc in snapshot.docs) {
        final log = DailyLogModel.fromFirestore(doc);
        final normalizedDate = DateTime(log.date.year, log.date.month, log.date.day);
        moodMap[normalizedDate] = log.mood;
      }

      dailyMoodNotifier.value = {...dailyMoodNotifier.value, ...moodMap};
    } catch (e) {
      debugPrint('Error loading moods: $e');
    }
  }
}