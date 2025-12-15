import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:femora/models/daily_log_model.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Butuh untuk cek creationTime
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:intl/intl.dart';

// --- Data Models UI ---
class DailyCycleData {
  Set<String> symptoms; 
  String selectedMood;
  bool isModified; 

  DailyCycleData({
    required this.symptoms,
    required this.selectedMood,
    this.isModified = false,
  });

  factory DailyCycleData.initial() => DailyCycleData(
        symptoms: {},
        selectedMood: 'Baik',
      );
}

// Data Options Gejala
final List<Map<String, String>> symptomOptions = [
  {'label': 'Mood Swing', 'path': AppAssets.moodSwing},
  {'label': 'Kembung', 'path': AppAssets.kembung},
  {'label': 'Nyeri Punggung', 'path': AppAssets.nyeriPunggung},
  {'label': 'Kelelahan', 'path': AppAssets.kelelahan},
  {'label': 'Nyeri perut/kram', 'path': AppAssets.nyeriPerut}, 
  {'label': 'Sakit kepala/pusing', 'path': AppAssets.sakitKepala}, 
];

class CycleEditScreen extends StatefulWidget {
  final Object? extra; 
  
  const CycleEditScreen({Key? key, this.extra}) : super(key: key);

  @override
  State<CycleEditScreen> createState() => _CycleEditScreenState();
}

class _CycleEditScreenState extends State<CycleEditScreen> {
  late DateTime _selectedDate;
  late DailyCycleData _currentData;
  final CycleDataService _cycleDataService = CycleDataService();
  bool _isLoading = false;
  
  // Tanggal user daftar
  late DateTime _registrationDate;

  @override
  void initState() {
    super.initState();
    
    // Set tanggal awal dari parameter
    if (widget.extra is DateTime) {
      _selectedDate = widget.extra as DateTime;
    } else {
      _selectedDate = DateTime.now();
    }

    // Ambil tanggal registrasi dari Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.metadata.creationTime != null) {
      _registrationDate = user.metadata.creationTime!;
    } else {
      // Fallback jika tidak ada data (misal 1 tahun lalu)
      _registrationDate = DateTime.now().subtract(const Duration(days: 365));
    }
    
    _currentData = DailyCycleData.initial();
    _loadDataFromFirebase();
  }

  Future<void> _loadDataFromFirebase() async {
    setState(() => _isLoading = true);
    final userId = _cycleDataService.userId;
    if (userId == null) return;

    try {
      final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final end = start.add(const Duration(days: 1));

      final snapshot = await FirebaseFirestore.instance
          .collection('daily_logs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .get();

      if (snapshot.docs.isNotEmpty) {
        final log = DailyLogModel.fromFirestore(snapshot.docs.first);
        setState(() {
          _currentData = DailyCycleData(
            symptoms: log.symptoms.toSet(),
            selectedMood: log.mood,
          );
        });
      } else {
        // Reset jika tidak ada data di tanggal itu
        setState(() {
          _currentData = DailyCycleData.initial();
        });
      }
    } catch (e) {
      debugPrint("Error loading logs: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _saveChanges() async {
    final userId = _cycleDataService.userId;
    if (userId == null) return;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      final dateId = DateFormat('yyyyMMdd').format(_selectedDate);
      final id = '${userId}_$dateId';

      final log = DailyLogModel(
        id: id,
        userId: userId,
        date: _selectedDate,
        mood: _currentData.selectedMood,
        symptoms: _currentData.symptoms.toList(),
        isMenstruation: false, 
      );

      await _cycleDataService.saveDailyLog(log);
      
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        context.pop(); // Kembali
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    }
  }

  // --- WIDGETS ---

  // 1. Date Strip (7 Hari)
  Widget _buildDateStrip() {
    final today = DateTime.now();
    // Generate 7 hari (Hari ini + 6 hari ke belakang)
    List<DateTime> dates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return Row(
      children: [
        // Tombol Kalender (Untuk pilih tanggal lama)
        IconButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              _handleDateChange(picked);
            }
          },
          icon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        // List 7 Hari
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((date) {
                final isSelected = date.year == _selectedDate.year && 
                                   date.month == _selectedDate.month && 
                                   date.day == _selectedDate.day;
                
                return GestureDetector(
                  onTap: () => _handleDateChange(date),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade200
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E', 'id_ID').format(date), // Nama Hari (Sen, Sel)
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(date), // Tanggal (05, 06)
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _handleDateChange(DateTime newDate) {
    // Validasi: Cek apakah tanggal sebelum user register
    if (newDate.isBefore(_registrationDate.subtract(const Duration(days: 1)))) {
      // Tampilkan Popup jika belum ada data (sebelum register)
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Belum Ada Data'),
          content: const Text('Kamu belum bergabung dengan Femora pada tanggal ini.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
          ],
        ),
      );
      return;
    }

    setState(() {
      _selectedDate = newDate;
    });
    _loadDataFromFirebase();
  }

  // 2. Mood Toggle (Seperti Gambar 2)
  Widget _buildMoodToggle() {
    return Row(
      children: [
        _buildMoodPill('Baik', '😊', const Color(0xFFE040FB)), // Ungu/Pink seperti gambar
        const SizedBox(width: 16),
        _buildMoodPill('Buruk', '😠', const Color(0xFFFF5722)), // Orange/Merah
      ],
    );
  }

  Widget _buildMoodPill(String label, String emoji, Color activeColor) {
    final isSelected = _currentData.selectedMood == label;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentData.selectedMood = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: isSelected ? [
              BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lingkaran Emoji
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, fontFamily: AppTextStyles.fontFamily)),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background agak putih abu
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                  CustomBackButton(onPressed: () => context.pop()),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Siklus',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                      )
                    )
                  ),
                  const SizedBox(width: 50),
              ]),
            ),

            Expanded(
              child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DATE STRIP (Gambar 3)
                    _buildDateStrip(),
                    const SizedBox(height: 30),

                    // MOOD TOGGLE (Gambar 2)
                    _buildSectionTitle('Suasana Hati'),
                    _buildMoodToggle(),
                    const SizedBox(height: 30),

                    // GEJALA (Horizontal Scroll)
                    _buildSectionTitle('Gejala'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: symptomOptions.map((symptom) {
                          final isSelected = _currentData.symptoms.contains(symptom['label']);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _currentData.symptoms.remove(symptom['label']);
                                } else {
                                  _currentData.symptoms.add(symptom['label']!);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300, width: 2),
                                    ),
                                    child: Image.asset(
                                      symptom['path']!,
                                      color: isSelected ? Colors.white : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      symptom['label']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 11, color: isSelected ? AppColors.primary : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Simpan Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white),
              child: PrimaryButton(text: 'Simpan', onPressed: _saveChanges),
            )
          ],
        ),
      ),
    );
  }
}