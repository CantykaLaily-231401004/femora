import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:femora/logic/menstruation_tracking_logic.dart';
import 'package:femora/models/daily_log_model.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:intl/intl.dart';

// Data Models
class DailyCycleData {
  Set<String> symptoms; 
  String selectedMood;
  bool isModified; 
  bool isMenstruating; // ✅ TAMBAHAN: Status menstruasi

  DailyCycleData({
    required this.symptoms,
    required this.selectedMood,
    this.isModified = false,
    this.isMenstruating = false,
  });

  factory DailyCycleData.initial() => DailyCycleData(
        symptoms: {},
        selectedMood: 'Baik',
        isMenstruating: false,
      );
}

// Data Options
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
  final MenstruationTrackingLogic _trackingLogic = MenstruationTrackingLogic();
  bool _isLoading = false;
  
  late DateTime _registrationDate;

  @override
  void initState() {
    super.initState();
    
    if (widget.extra is DateTime) {
      _selectedDate = widget.extra as DateTime;
    } else {
      _selectedDate = DateTime.now();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.metadata.creationTime != null) {
      _registrationDate = user.metadata.creationTime!;
    } else {
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
      // Load daily log data
      final start = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      final end = start.add(const Duration(days: 1));

      final snapshot = await FirebaseFirestore.instance
          .collection('daily_logs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .get();

      // ✅ CEK STATUS MENSTRUASI DARI TRACKING LOGIC
      final isMenstruating = await _trackingLogic.isMenstruationDay(_selectedDate);

      if (snapshot.docs.isNotEmpty) {
        final log = DailyLogModel.fromFirestore(snapshot.docs.first);
        setState(() {
          _currentData = DailyCycleData(
            symptoms: log.symptoms.toSet(),
            selectedMood: log.mood,
            isMenstruating: isMenstruating,
          );
        });
      } else {
        setState(() {
          _currentData = DailyCycleData(
            symptoms: {},
            selectedMood: 'Baik',
            isMenstruating: isMenstruating,
          );
        });
      }
    } catch (e) {
      debugPrint("Error loading logs: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// ✅ SAVE CHANGES - Termasuk Status Menstruasi
  void _saveChanges() async {
    final userId = _cycleDataService.userId;
    if (userId == null) return;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator())
    );

    try {
      // 1. Simpan Daily Log
      final dateId = DateFormat('yyyyMMdd').format(_selectedDate);
      final id = '${userId}_$dateId';

      final log = DailyLogModel(
        id: id,
        userId: userId,
        date: _selectedDate,
        mood: _currentData.selectedMood,
        symptoms: _currentData.symptoms.toList(),
        isMenstruation: _currentData.isMenstruating,
      );

      await _cycleDataService.saveDailyLog(log);
      
      // 2. ✅ UPDATE MENSTRUATION TRACKING
      await _trackingLogic.updateMenstruationStatus(
        checkInDate: _selectedDate,
        isMenstruating: _currentData.isMenstruating,
      );
      
      debugPrint('✅ Menstruation status updated for ${_selectedDate.toString().split(' ')[0]}');
      
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        context.pop(); // Kembali ke home
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'))
        );
      }
    }
  }

  Widget _buildDateStrip() {
    final today = DateTime.now();
    List<DateTime> dates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: _registrationDate,
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              _handleDateChange(picked);
            }
          },
          icon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
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
                          DateFormat('E', 'id_ID').format(date),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(date),
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
    if (newDate.isBefore(_registrationDate.subtract(const Duration(days: 1)))) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Belum Ada Data'),
          content: const Text('Kamu belum bergabung dengan Femora pada tanggal ini.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('OK')
            )
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

  Widget _buildMoodToggle() {
    return Row(
      children: [
        _buildMoodPill('Baik', '😊', const Color(0xFFE040FB)),
        const SizedBox(width: 16),
        _buildMoodPill('Buruk', '😠', const Color(0xFFFF5722)),
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
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3), 
                blurRadius: 8, 
                offset: const Offset(0, 4)
              )
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

  /// ✅ MENSTRUATION TOGGLE
  Widget _buildMenstruationToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _currentData.isMenstruating ? AppColors.primary : Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.water_drop,
            color: _currentData.isMenstruating ? AppColors.primary : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sedang Menstruasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _currentData.isMenstruating ? AppColors.primary : Colors.black87,
              ),
            ),
          ),
          Switch(
            value: _currentData.isMenstruating,
            onChanged: (value) {
              setState(() {
                _currentData.isMenstruating = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w700, 
          fontSize: 18, 
          fontFamily: AppTextStyles.fontFamily
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                  CustomBackButton(onPressed: () => context.pop()),
                  const Expanded(
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
                    _buildDateStrip(),
                    const SizedBox(height: 30),

                    // ✅ MENSTRUATION STATUS
                    _buildSectionTitle('Status Menstruasi'),
                    _buildMenstruationToggle(),
                    const SizedBox(height: 30),

                    _buildSectionTitle('Suasana Hati'),
                    _buildMoodToggle(),
                    const SizedBox(height: 30),

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
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : Colors.grey.shade300, 
                                        width: 2
                                      ),
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
                                      style: TextStyle(
                                        fontSize: 11, 
                                        color: isSelected ? AppColors.primary : Colors.black
                                      ),
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
