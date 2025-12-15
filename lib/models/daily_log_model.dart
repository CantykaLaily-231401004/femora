import 'package:cloud_firestore/cloud_firestore.dart';

class DailyLogModel {
  final String id;
  final String userId;
  final DateTime date;
  final String? flowLevel; // 'Ringan', 'Normal', 'Banyak'
  final String mood; // 'Baik' atau 'Buruk'
  final List<String> symptoms; // ['Mood Swing', 'Kembung', dst]
  final String? note;
  final bool isMenstruation;

  DailyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    this.flowLevel,
    required this.mood,
    required this.symptoms,
    this.note,
    this.isMenstruation = false,
  });

  // Factory untuk mengubah data dari Firestore menjadi Object Dart
  factory DailyLogModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return DailyLogModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      flowLevel: data['flowLevel'],
      mood: data['mood'] ?? 'Baik',
      symptoms: List<String>.from(data['symptoms'] ?? []),
      note: data['note'],
      isMenstruation: data['isMenstruation'] ?? false,
    );
  }

  // Convert Object Dart menjadi Map untuk dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'flowLevel': flowLevel,
      'mood': mood,
      'symptoms': symptoms,
      'note': note,
      'isMenstruation': isMenstruation,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Copy with untuk update data tanpa menghapus data lama yang tidak berubah
  DailyLogModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? flowLevel,
    String? mood,
    List<String>? symptoms,
    String? note,
    bool? isMenstruation,
  }) {
    return DailyLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      flowLevel: flowLevel ?? this.flowLevel,
      mood: mood ?? this.mood,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      isMenstruation: isMenstruation ?? this.isMenstruation,
    );
  }
}