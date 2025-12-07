import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';

// --- Data Models Sederhana untuk Editing ---

// Model untuk menyimpan semua data satu hari
class DailyCycleData {
  int flowIndex; // Index 0-2
  Set<int> symptomIndices;
  Set<int> medicationIndices;
  String selectedMood;
  String notes;

  DailyCycleData({
    required this.flowIndex,
    required this.symptomIndices,
    required this.medicationIndices,
    required this.selectedMood,
    required this.notes,
  });

  // Data default untuk hari baru
  factory DailyCycleData.initial() => DailyCycleData(
        flowIndex: 0, // Default Low
        symptomIndices: {},
        medicationIndices: {},
        selectedMood: 'Baik',
        notes: 'Tambahkan catatanmu di sini',
      );
}

// Data Dummy
final List<String> flowOptions = ['Low', 'Normal', 'High'];
final List<String> symptomLabels = [
  'Sakit Kepala',
  'Siklus Tidak Teratur',
  'Berat Badan Bertambah'
];
final List<String> medicationLabels = [
  'Obat Pil',
  'Obat Tempel',
  'Krim Pelembab'
];
final List<Map<String, dynamic>> moodPills = [
  {'label': 'Baik', 'emoji': '😊', 'color': const Color(0xFFFFCC33)},
  {'label': 'Buruk', 'emoji': '😞', 'color': AppColors.primaryDark},
];


class CycleEditScreen extends StatefulWidget {
  final DateTime initialDate;
  const CycleEditScreen({Key? key, required this.initialDate}) : super(key: key);

  @override
  State<CycleEditScreen> createState() => _CycleEditScreenState();
}

class _CycleEditScreenState extends State<CycleEditScreen> {
  // Key: DateTime (untuk memastikan data unik per tanggal)
  late Map<DateTime, DailyCycleData> _dailyDataMap;
  late DateTime _selectedDate;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    // Menghasilkan 7 hari (Hari ini dan 6 hari sebelumnya)
    _dates = List.generate(7, (index) => today.subtract(Duration(days: 6 - index)));

    _dailyDataMap = {};
    for (var date in _dates) {
      // Inisialisasi data unik untuk setiap tanggal
      _dailyDataMap[date] = DailyCycleData.initial();
    }

    // FIX PENTING: Memastikan _selectedDate mengambil INSTANCE yang sama dari list _dates
    _selectedDate = _dates.firstWhere(
      (date) =>
          date.year == widget.initialDate.year &&
          date.month == widget.initialDate.month &&
          date.day == widget.initialDate.day,
      orElse: () => _dates.last,
    ); // Default ke tanggal terbaru jika initialDate di luar 7 hari

    // Memberi sedikit data unik untuk demonstrasi persistence
    _dailyDataMap[_dates.last.subtract(const Duration(days: 1))]!.flowIndex = 1; // Kemarin: Normal
    _dailyDataMap[_dates.last.subtract(const Duration(days: 2))]!.selectedMood =
        'Buruk'; // 2 Hari lalu: Buruk
  }

  // Mengambil data untuk tanggal yang sedang dipilih
  DailyCycleData get _currentData => _dailyDataMap[_selectedDate]!;


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
    print('--- SAVING ALL 7 DAYS DATA ---');
    // Logic navigasi kembali ke halaman riwayat utama (history)
    context.go(AppRoutes.history);
  }

  // Helper untuk membangun item yang bisa dipilih (Flow, Gejala, Obat)
  Widget _buildSelectableItem({
    required Widget iconWidget,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isIconAsset = false, // ✅ Parameter untuk membedakan coloring
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.getWidth(28), // Lebar tetap untuk scroll horizontal
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                shape: BoxShape.circle,
                border: isSelected ? null : Border.all(color: AppColors.borderColorDark),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: isIconAsset
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: iconWidget, // Tampilkan icon asset apa adanya
                      )
                    : ColorFiltered(
                        colorFilter: isSelected
                            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                            : const ColorFilter.mode(AppColors.primary, BlendMode.srcIn), // Ikon berwarna pink saat tidak dipilih
                        child: iconWidget,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.getFontSize(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builder untuk baris horizontal tanggal
  Widget _buildDateSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(initialScrollOffset: 1000),
      child: Row(
        children: _dates.map((date) {
          final isSelected = date.day == _selectedDate.day;

          final dayNameStyle = TextStyle(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: SizeConfig.getFontSize(14),
            fontWeight: FontWeight.w500,
          );

          final dayNumStyle = TextStyle(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: SizeConfig.getFontSize(16),
            fontWeight: FontWeight.w700,
          );

          return GestureDetector(
            onTap: () {
              setState(() {
                // PENTING: Memastikan kita memilih objek DateTime yang sama dari list _dates
                _selectedDate = _dates
                    .firstWhere((d) => d.day == date.day && d.month == date.month);
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    ['Mg', 'Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb'][date.weekday % 7],
                    style: dayNameStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: dayNumStyle,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget kustom untuk pill Mood yang bisa ditekan untuk navigasi
  Widget _buildMoodPillItem({
    required String label,
    required String emoji,
    required bool isSelected,
    required Color emojiBaseColor,
    required VoidCallback onTap,
  }) {
    final pillColor = isSelected ? AppColors.primary : AppColors.white;
    final textColor = isSelected ? Colors.white : AppColors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // TIDAK ADA WIDTH AGAR MainAxisAlignment.spaceAround BERFUNGSI
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: pillColor,
          borderRadius: BorderRadius.circular(40),
          border: isSelected ? null : Border.all(color: AppColors.borderColorDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : emojiBaseColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? emojiBaseColor : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.getFontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // FIX: Mengambil data saat ini dari map
    final currentData = _dailyDataMap[_selectedDate]!;

    return Scaffold(
      backgroundColor: AppColors.primaryLight.withOpacity(0.15), // Background Hint Pink FIX
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
                        'Log Entry', // Mengikuti Judul di image_47c29a.png
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.getFontSize(24),
                          color: AppColors.textPrimary,
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
                    // --- 1. Pemilih Tanggal (Horizontal Scroll) ---
                    _buildDateSelector(),
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // --- 2. Tingkat Menstruasi (Flow) ---
                    const Text('Tingkat Menstruasi',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: SizeConfig.getHeight(2)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: flowOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final flow = entry.value;
                          final isSelected = currentData.flowIndex == index;
                          return _buildSelectableItem(
                            iconWidget:
                                const Icon(Icons.water_drop, color: Colors.white, size: 28),
                            label: flow,
                            isSelected: isSelected,
                            onTap: () => setState(() => currentData.flowIndex = index),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // --- 3. Gejala ---
                    const Text('Gejala',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: SizeConfig.getHeight(2)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: symptomLabels.asMap().entries.map((entry) {
                          final index = entry.key;
                          final symptom = entry.value;

                          final assetPath = symptom == 'Sakit Kepala'
                              ? AppAssets.sakitKepala
                              : AppAssets.siklusTidakTeratur;

                          return _buildSelectableItem(
                            iconWidget:
                                Image.asset(assetPath, fit: BoxFit.contain, width: 28, height: 28),
                            label: symptom,
                            isSelected: currentData.symptomIndices.contains(index),
                            isIconAsset: true,
                            onTap: () {
                              setState(() {
                                if (currentData.symptomIndices.contains(index)) {
                                  currentData.symptomIndices.remove(index);
                                } else {
                                  currentData.symptomIndices.add(index);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // --- 4. Suasana Hati (Mood - Selectable Pills Navigation FIX) ---
                    const Text('Suasana Hati',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: SizeConfig.getHeight(2)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(5)),
                      child: Row(
                        // FIX: Menggunakan Row dengan spaceAround
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: moodPills.map((mood) {
                          final isSelected = _currentData.selectedMood == mood['label'];
                          return _buildMoodPillItem(
                            label: mood['label'],
                            emoji: mood['emoji'],
                            emojiBaseColor: mood['color'],
                            isSelected: isSelected,
                            onTap: _navigateToMoodPicker, // Tapping always navigates to picker
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // --- 5. Pengobatan (Medication) ---
                    const Text('Pengobatan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: SizeConfig.getHeight(2)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: medicationLabels.asMap().entries.map((entry) {
                          final index = entry.key;
                          final medication = entry.value;

                          String assetPath;
                          if (medication == 'Obat Pil') {
                            assetPath = AppAssets.obatPil;
                          } else if (medication == 'Obat Tempel') {
                            assetPath = AppAssets.obatTempel;
                          } else {
                            assetPath = AppAssets.krimPelembab;
                          }

                          return _buildSelectableItem(
                            iconWidget: Image.asset(assetPath,
                                fit: BoxFit.contain, width: 28, height: 28),
                            label: medication,
                            isSelected: _currentData.medicationIndices.contains(index),
                            isIconAsset: true, // ✅ TAMBAHKAN
                            onTap: () {
                              setState(() {
                                if (_currentData.medicationIndices.contains(index)) {
                                  _currentData.medicationIndices.remove(index);
                                } else {
                                  _currentData.medicationIndices.add(index);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // --- 6. Catatan ---
                    const Text('Catatan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: SizeConfig.getHeight(1)),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: TextEditingController(text: _currentData.notes),
                        onChanged: (text) {
                          _currentData.notes = text; // Update data map langsung
                        },
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Tambahkan catatanmu di sini',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getHeight(2)),
                  ],
                ),
              ),
            ),

            // --- Tombol Simpan ---
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