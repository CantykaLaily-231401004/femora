// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:femora/models/daily_log_model.dart'; // Sesuaikan import

// class HistoryProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Stream untuk mendengarkan perubahan data secara real-time
//   Stream<List<DailyLogModel>> getHistoryLogs() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return Stream.value([]);
//     }

//     return _firestore
//         .collection('daily_logs')
//         .where('userId', isEqualTo: user.uid)
//         .orderBy('date', descending: true) // Data terbaru dulu
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) => DailyLogModel.fromFirestore(doc)).toList();
//     });
//   }
// }