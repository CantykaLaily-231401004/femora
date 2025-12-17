import 'dart:convert';
import 'dart:math';

import 'package:femora/models/education_material.dart';
import 'package:flutter/services.dart';

class EducationService {
  static const String _dataPath = 'assets/education_materials.json';
  List<EducationMaterial> _allMaterials = [];

  Future<List<EducationMaterial>> getDailyMaterials({
    int totalCount = 8,
    int videoCount = 2, // Jumlah video yang ingin dipastikan ada
  }) async {
    if (_allMaterials.isEmpty) {
      await _loadMaterials();
    }

    final seed = DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day;
    final random = Random(seed);

    // 1. Pisahkan materi berdasarkan tipe
    final articles = _allMaterials.where((m) => m.type == 'article').toList();
    final videos = _allMaterials.where((m) => m.type == 'video').toList();

    // 2. Acak masing-masing daftar
    articles.shuffle(random);
    videos.shuffle(random);

    // 3. Ambil sejumlah tertentu dari setiap tipe
    final dailyVideos = videos.take(videoCount).toList();
    final articleCount = totalCount - dailyVideos.length; // Sisa kuota untuk artikel
    final dailyArticles = articles.take(articleCount).toList();

    // 4. Gabungkan dan acak sekali lagi agar posisi tercampur
    final dailyMaterials = [...dailyVideos, ...dailyArticles];
    dailyMaterials.shuffle(random);

    return dailyMaterials;
  }

  Future<void> _loadMaterials() async {
    try {
      final jsonString = await rootBundle.loadString(_dataPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      _allMaterials = jsonList.map((json) => EducationMaterial.fromJson(json)).toList();
    } catch (e) {
      print('Error loading education materials: $e');
      _allMaterials = [];
    }
  }
}
