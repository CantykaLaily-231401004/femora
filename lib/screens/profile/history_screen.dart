import 'package:femora/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:provider/provider.dart';
import 'package:femora/provider/history_provider.dart';
import 'package:femora/models/daily_log_model.dart';

// --- WIDGET HELPER KECIL ---
class _FlowIcon extends StatelessWidget {
  final Color color;
  final bool isHeavy;
  const _FlowIcon({required this.color, this.isHeavy = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58, height: 58,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(child: Icon(Icons.water_drop, color: Colors.white, size: 28)),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // --- LOGIC MENGHITUNG STATISTIK ---
  Map<String, int> _calculateCounts(List<DailyLogModel> logs, String type) {
    Map<String, int> counts = {};
    for (var log in logs) {
      List<String> items = [];
      if (type == 'symptoms') items = log.symptoms;
      else if (type == 'moods') items = log.moods;
      else if (type == 'medications') items = log.medications;
      else if (type == 'flow' && log.flowLevel != null) items = [log.flowLevel!];

      for (var item in items) {
        counts[item] = (counts[item] ?? 0) + 1;
      }
    }
    return counts;
  }

  // --- WIDGET BUILDER ---
  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(20), color: AppColors.textPrimary,
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildCycleDataCard(BuildContext context, {required IconData icon, required Color color, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon, color: color, size: 24), const SizedBox(width: 8), Text(value, style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w600, fontSize: SizeConfig.getFontSize(16), color: AppColors.textPrimary))]),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w500, fontSize: SizeConfig.getFontSize(14), color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableItem({required Widget iconWidget, required String label, required String count, double width = 85, Color? backgroundColor}) {
    return Container(
      width: width, margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: backgroundColor ?? AppColors.primaryLight, shape: BoxShape.circle),
            child: Center(child: iconWidget),
          ),
          const SizedBox(height: 8),
          Text('$label ($count)', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: SizeConfig.getFontSize(12), fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildAssetItem({required String iconPath, required String label, required String count, double width = 120}) {
    return Container(
      width: width, margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: Image.asset(iconPath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: AppColors.primary, size: 30)),
          ),
          const SizedBox(height: 4),
          Text('$label ($count)', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: SizeConfig.getFontSize(12), fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onPressed: () => context.pop()),
          Image.asset(AppAssets.logoRed, width: 70),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

    return Scaffold(
      // backgroundColor dihapus dari sini karena kita pakai Stack
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Putih ke Pink Lembut)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF), // Putih Bersih di atas
                  Color(0xFFFFF0F5), // Lavender Blush (Pink sangat muda) di bawah
                ],
                stops: [0.3, 1.0], // Putih dominan sampai 30%, lalu gradasi ke pink
              ),
            ),
          ),

          // 2. KONTEN UTAMA
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCustomHeader(context),
                SizedBox(height: SizeConfig.getHeight(1)),
                
                // Header Total Data
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Data', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Container(height: 1, color: AppColors.primary),
                    ],
                  ),
                ),

                // STREAM BUILDER
                Expanded(
                  child: StreamBuilder<List<DailyLogModel>>(
                    stream: historyProvider.getHistoryLogs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        // Tampilkan error dengan teks hitam agar terbaca
                        return Center(
                          child: Text(
                            "Terjadi kesalahan memuat data", 
                            style: TextStyle(color: AppColors.textPrimary)
                          )
                        );
                      }

                      final logs = snapshot.data ?? [];
                      
                      final flowCounts = _calculateCounts(logs, 'flow');
                      final symptomCounts = _calculateCounts(logs, 'symptoms');
                      final moodCounts = _calculateCounts(logs, 'moods');
                      final medCounts = _calculateCounts(logs, 'medications');
                      final totalMenstruationDays = logs.where((l) => l.isMenstruation).length;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- 1. Siklusku Section ---
                            _buildSectionHeader('Siklusku', onTap: () => context.push(AppRoutes.cycleHistoryDetail)),
                            Row(
                              children: [
                                _buildCycleDataCard(
                                  context, icon: Icons.water_drop_outlined, color: AppColors.primary,
                                  value: '$totalMenstruationDays hari', 
                                  label: 'Total Menstruasi',
                                ),
                                _buildCycleDataCard(
                                  context, icon: Icons.calendar_today_outlined, color: const Color(0xFF6B6B6B),
                                  value: '${logs.length} hari', 
                                  label: 'Total Log',
                                ),
                              ],
                            ),

                            // --- 2. Aliran Section ---
                            _buildSectionHeader('Aliran'),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildScrollableItem(
                                    iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: false),
                                    label: 'Low', count: (flowCounts['Low'] ?? 0).toString()
                                  ),
                                  _buildScrollableItem(
                                    iconWidget: _FlowIcon(color: AppColors.primary.withOpacity(0.7), isHeavy: false),
                                    label: 'Normal', count: (flowCounts['Normal'] ?? 0).toString()
                                  ),
                                  _buildScrollableItem(
                                    iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: true),
                                    label: 'Heavy', count: (flowCounts['Heavy'] ?? 0).toString()
                                  ),
                                ],
                              ),
                            ),

                            // --- 3. Gejala Section ---
                            _buildSectionHeader('Gejala'),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildAssetItem(
                                    iconPath: AppAssets.sakitKepala, label: 'Sakit Kepala', 
                                    count: (symptomCounts['Sakit Kepala'] ?? 0).toString()
                                  ),
                                  _buildAssetItem(
                                    iconPath: AppAssets.siklusTidakTeratur, label: 'Kram Perut', 
                                    count: (symptomCounts['Kram Perut'] ?? 0).toString()
                                  ),
                                  _buildAssetItem(
                                    iconPath: AppAssets.beratBadanBertambah, label: 'Kembung', 
                                    count: (symptomCounts['Kembung'] ?? 0).toString()
                                  ),
                                ],
                              ),
                            ),

                            // --- 4. Suasana Hati Section ---
                            _buildSectionHeader('Suasana Hati'),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildScrollableItem(
                                    iconWidget: const Text('😊', style: TextStyle(fontSize: 28)),
                                    label: 'Baik', 
                                    count: (moodCounts['Baik'] ?? moodCounts['Senang'] ?? 0).toString(),
                                    backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                                  ),
                                  _buildScrollableItem(
                                    iconWidget: const Text('😞', style: TextStyle(fontSize: 28)),
                                    label: 'Buruk', 
                                    count: (moodCounts['Buruk'] ?? moodCounts['Sedih'] ?? 0).toString(),
                                    backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                                  ),
                                ],
                              ),
                            ),

                            // --- 5. Pengobatan Section ---
                            _buildSectionHeader('Pengobatan'),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildAssetItem(
                                    iconPath: AppAssets.obatPil, label: 'Obat Pil', 
                                    count: (medCounts['Obat Pil'] ?? 0).toString(), width: 90
                                  ),
                                  _buildAssetItem(
                                    iconPath: AppAssets.obatTempel, label: 'Obat Tempel', 
                                    count: (medCounts['Obat Tempel'] ?? 0).toString(), width: 100
                                  ),
                                   _buildAssetItem(
                                    iconPath: AppAssets.krimPelembab, label: 'Krim', 
                                    count: (medCounts['Krim Pelembab'] ?? 0).toString(), width: 120
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),
                            const _CatatanCard(), 
                            SizedBox(height: SizeConfig.getHeight(10)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Catatan tetap sama 
class _CatatanCard extends StatefulWidget {
  const _CatatanCard({Key? key}) : super(key: key);
  @override
  State<_CatatanCard> createState() => _CatatanCardState();
}

class _CatatanCardState extends State<_CatatanCard> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Catatan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          TextField(
            controller: _controller, maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Tambahkan Catatan hari ini...',
              hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
              border: InputBorder.none, contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}