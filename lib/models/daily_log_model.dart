import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final String? flowLevel;
  final List<String> moods;
  final List<String> symptoms;
  final List<String> medications;
  final String? note;
  final bool isMenstruation;

  DailyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    this.flowLevel,
    required this.moods,
    required this.symptoms,
    required this.medications,
    this.note,
    this.isMenstruation = false,
  });

  factory DailyLogModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DailyLogModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      flowLevel: data['flowLevel'],
      moods: List<String>.from(data['moods'] ?? []),
      symptoms: List<String>.from(data['symptoms'] ?? []),
      medications: List<String>.from(data['medications'] ?? []),
      note: data['note'],
      isMenstruation: data['isMenstruation'] ?? false,
    );
  }
}