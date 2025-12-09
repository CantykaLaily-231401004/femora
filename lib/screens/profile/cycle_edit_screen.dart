import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';

// --- Data Models ---
class DailyCycleData {
  int flowIndex;
  Set<int> symptomIndices;
  String selectedMood;
  String notes;

  DailyCycleData({
    required this.flowIndex,
    required this.symptomIndices,
    required this.selectedMood,
    required this.notes,
  });

  factory DailyCycleData.initial() => DailyCycleData(
        flowIndex: 0,
        symptomIndices: {},
        selectedMood: 'Baik',
        notes: '',
      );
}

// Data sesuai History Screen
final List<String> flowOptions = ['Ringan', 'Normal', 'Banyak'];

final List<String> symptomLabels = [
  'Mood Swing',
  'Kembung',
  'Nyeri Punggung',
  'Kelelahan',
  'Nyeri Perut',
];

final List<Map<String, dynamic>> moodOptions = [
  {'label': 'Baik', 'emoji': '😊'},
  {'label': 'Buruk', 'emoji': '😞'},
];

class CycleEditScreen extends StatefulWidget {
  final DateTime initialDate;
  const CycleEditScreen({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<CycleEditScreen> createState() => _CycleEditScreenState();
}

class _CycleEditScreenState extends State<CycleEditScreen> {
  late Map<DateTime, DailyCycleData> _dailyDataMap;
  late DateTime _selectedDate;
  late List<DateTime> _dates;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Generate 7 hari terakhir
    _dates = List.generate(7, (index) => DateTime(
      today.year,
      today.month, 
      today.day - (6 - index),
    ));

    _dailyDataMap = {};
    for (var date in _dates) {
      _dailyDataMap[date] = DailyCycleData.initial();
    }

    _selectedDate = _dates.last; // Default ke hari ini
    _notesController.text = _currentData.notes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  DailyCycleData get _currentData => _dailyDataMap[_selectedDate]!;

  // Cek apakah tanggal bisa diedit
  bool _canEditDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    
    // TODO: Ganti dengan firstLoginDate dari Firebase
    final firstLoginDate = DateTime(2024, 12, 3);
    
    // Bisa edit jika: tanggal >= firstLogin DAN tanggal <= hari ini
    return checkDate.isAfter(firstLoginDate.subtract(const Duration(days: 1))) && 
           checkDate.isBefore(today.add(const Duration(days: 1)));
  }

  void _showNoDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Tidak Ada Data',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: const Text(
          'Tidak ada data pada tanggal ini. Anda hanya bisa mengedit tanggal sejak pertama kali login hingga hari ini.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMoodPicker() async {
    final result = await context.push<String>(
      AppRoutes.moodPicker,
      extra: _currentData.selectedMood,
    );
    if (result != null) {
      setState(() {
        _currentData.selectedMood = result;
      });
    }
  }

  void _saveChanges() {
    print('--- SAVING ALL DATA ---');
    _dailyDataMap.forEach((date, data) {
      print('Date: $date');
      print('Flow: ${flowOptions[data.flowIndex]}');
      print('Symptoms: ${data.symptomIndices.map((i) => symptomLabels[i]).toList()}');
      print('Mood: ${data.selectedMood}');
      print('Notes: ${data.notes}');
      print('---');
    });
    
    // TODO: Simpan ke Firebase
    context.go(AppRoutes.history);
  }

  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: _dates.map((date) {
          final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
          final canEdit = _canEditDate(date);

          return GestureDetector(
            onTap: () {
              if (!canEdit) {
                _showNoDataDialog();
              } else {
                setState(() {
                  _selectedDate = _dates.firstWhere(
                      (d) => d.day == date.day && d.month == date.month);
                  _notesController.text = _currentData.notes;
                });
              }
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary 
                    : (canEdit ? AppColors.white : AppColors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    ['Mg', 'Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb'][date.weekday % 7],
                    style: TextStyle(
                      color: isSelected ? Colors.white : (canEdit ? Colors.black : AppColors.grey),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : (canEdit ? Colors.black : AppColors.grey),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMoodPill({
    required String label,
    required String emoji,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: _navigateToMoodPicker,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.3) 
                      : AppColors.primaryLight,
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
                  fontSize: 14,
                  fontFamily: AppTextStyles.fontFamily,
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
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Colors.black,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildSelectableItem({
    required Widget iconWidget,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isAssetIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: isAssetIcon
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: iconWidget,
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isSelected ? Colors.white : AppColors.primary,
                          BlendMode.srcIn,
                        ),
                        child: iconWidget,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                fontFamily: AppTextStyles.fontFamily,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 224, 224),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  CustomBackButton(onPressed: () => context.pop()),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Log Entry',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Selector
                    _buildDateSelector(),
                    const SizedBox(height: 24),

                    // Tingkat Menstruasi - RATA KIRI KANAN
                    _buildSectionTitle('Tingkat Menstruasi'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: flowOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final flow = entry.value;
                          final isSelected = _currentData.flowIndex == index;
                          
                          Color iconColor = AppColors.primary;
                          if (index == 1) iconColor = AppColors.primary.withOpacity(0.7);
                          
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              child: GestureDetector(
                                onTap: () => setState(() => _currentData.flowIndex = index),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 58,
                                      height: 58,
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.primary : AppColors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            isSelected ? Colors.white : iconColor,
                                            BlendMode.srcIn,
                                          ),
                                          child: const Icon(Icons.water_drop, size: 28),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      flow,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        fontFamily: AppTextStyles.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Gejala
                    _buildSectionTitle('Gejala'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: symptomLabels.asMap().entries.map((entry) {
                          final index = entry.key;
                          final symptom = entry.value;

                          String assetPath;
                          switch (symptom) {
                            case 'Mood Swing':
                              assetPath = AppAssets.moodSwing;
                              break;
                            case 'Kembung':
                              assetPath = AppAssets.kembung;
                              break;
                            case 'Nyeri Punggung':
                              assetPath = AppAssets.nyeriPunggung;
                              break;
                            case 'Kelelahan':
                              assetPath = AppAssets.kelelahan;
                              break;
                            case 'Nyeri Perut':
                              assetPath = AppAssets.nyeriPerut;
                              break;
                            default:
                              assetPath = AppAssets.sakitKepala;
                          }

                          return _buildSelectableItem(
                            iconWidget: Image.asset(assetPath, fit: BoxFit.contain),
                            label: symptom,
                            isSelected: _currentData.symptomIndices.contains(index),
                            isAssetIcon: true,
                            onTap: () {
                              setState(() {
                                if (_currentData.symptomIndices.contains(index)) {
                                  _currentData.symptomIndices.remove(index);
                                } else {
                                  _currentData.symptomIndices.add(index);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Suasana Hati
                    _buildSectionTitle('Suasana Hati'),
                    Row(
                      children: moodOptions.map((mood) {
                        final isSelected = _currentData.selectedMood == mood['label'];
                        return _buildMoodPill(
                          label: mood['label'],
                          emoji: mood['emoji'],
                          isSelected: isSelected,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Catatan
                    _buildSectionTitle('Catatan'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _notesController,
                        onChanged: (text) => _currentData.notes = text,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Tambahkan Catatan Anda Di sini...',
                          hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Tombol Simpan
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
              child: PrimaryButton(
                text: 'Simpan',
                onPressed: _saveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }
}