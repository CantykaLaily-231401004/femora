import 'package:femora/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/size_config.dart';

// Widget Kustom untuk ikon Aliran (VISUAL STYLE STABIL)
class _FlowIcon extends StatelessWidget {
  final Color color;
  final bool isHeavy;

  const _FlowIcon({required this.color, this.isHeavy = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        // Menggunakan Icon Flutter standar yang pasti tampil
        child: Icon(Icons.water_drop, color: Colors.white, size: 28), 
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Reusable widget untuk header bagian dengan panah navigasi
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
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.getFontSize(20),
                color: AppColors.textPrimary,
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu data Siklusku
  Widget _buildCycleDataCard(BuildContext context, {required IconData icon, required Color color, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.white, // Dijaga tetap putih agar pop up
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.getFontSize(16),
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.getFontSize(14),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk item yang bisa di-scroll (Mood)
  Widget _buildScrollableItem({
    required Widget iconWidget, 
    required String label,
    required String count,
    double width = 85, 
    Color? backgroundColor,
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 48, 
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(height: 8),
          Text(
            '$label(${count}x)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: SizeConfig.getFontSize(12),
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget untuk item Gejala/Pengobatan (Menggunakan Image.asset dari assets/icon/)
  Widget _buildAssetItem({
    required String iconPath,
    required String label,
    required String count,
    double width = 120, 
  }) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 48,
            // Menggunakan Image.asset yang benar dari folder icon/
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              // Fallback yang jelas jika aset gagal dimuat
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: AppColors.primary, size: 30),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$label($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: SizeConfig.getFontSize(12),
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  // Header kustom (Back button + Logo Femora)
  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomBackButton(onPressed: () => context.pop()),
          // Menggunakan Image.asset(AppAssets.logoRed)
          Image.asset(AppAssets.logoRed, width: 70), 
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.primaryLight.withOpacity(0.15), // ✅ FIX 1: Background Hint Pink
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCustomHeader(context),
            
            SizedBox(height: SizeConfig.getHeight(1)),
            
            // "Total Data" text dengan garis merah
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Data',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 1, color: AppColors.primary),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                // Konten diluar kartu tetap mengikuti background pink
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. Siklusku Section ---
                    _buildSectionHeader('Siklusku', onTap: () => context.push(AppRoutes.cycleHistoryDetail)), 
                    Row(
                      children: [
                        _buildCycleDataCard(
                          context,
                          icon: Icons.water_drop_outlined,
                          color: AppColors.primary,
                          value: '3 hari',
                          label: 'Masa Menstruasi',
                        ),
                        _buildCycleDataCard(
                          context,
                          icon: Icons.calendar_today_outlined,
                          color: const Color(0xFF6B6B6B),
                          value: '26 hari',
                          label: 'Siklus Menstruasi',
                        ),
                      ],
                    ),

                    // --- 2. Aliran Section (Horizontal Scroll - Visual Stabil) ---
                    _buildSectionHeader('Aliran'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildScrollableItem(
                            iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: false),
                            label: 'Low', count: '39', width: 85
                          ),
                          _buildScrollableItem(
                            iconWidget: _FlowIcon(color: AppColors.primary.withOpacity(0.7), isHeavy: false),
                            label: 'Normal', count: '21', width: 85
                          ),
                          _buildScrollableItem(
                            iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: true), 
                            label: 'Heavy', count: '10', width: 85
                          ),
                        ],
                      ),
                    ),

                    // --- 3. Gejala Section (Horizontal Scroll - Ikon Aset PNG) ---
                    _buildSectionHeader('Gejala', onTap: () {}),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Sakit Kepala
                          _buildAssetItem(
                            iconPath: AppAssets.sakitKepala, 
                            label: 'Sakit Kepala', 
                            count: '12',
                            width: 120, 
                          ),
                          // Siklus Tidak Teratur
                          _buildAssetItem(
                            iconPath: AppAssets.siklusTidakTeratur, 
                            label: 'Siklus Tidak Teratur', 
                            count: '39', 
                            width: 130, 
                          ),
                          // ✅ FIX 2: Berat Badan Bertambah
                          _buildAssetItem(
                            iconPath: AppAssets.beratBadanBertambah, // ✅ PERBAIKI INI
                            label: 'Berat Badan Bertambah', 
                            count: '8',
                            width: 150, 
                          ),  
                        ],
                      ),
                    ),
                    
                    // --- 4. Suasana Hati Section (HORIZONTAL RATAKANAN-KIRI FIX) ---
                    _buildSectionHeader('Suasana Hati', onTap: () {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildScrollableItem(
                            iconWidget: const Text('😊', style: TextStyle(fontSize: 28)),
                            label: 'baik', count: '24', backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                          ),
                          _buildScrollableItem(
                            iconWidget: const Text('😞', style: TextStyle(fontSize: 28)),
                            label: 'buruk', count: '15', backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                          ),
                        ],
                      ),
                    ),

                    // --- 5. Pengobatan Section (Horizontal Scroll - DATA DIBATASI 3 ITEM) ---
                    _buildSectionHeader('Pengobatan', onTap: () {}),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Obat Pil
                          _buildAssetItem(
                            iconPath: AppAssets.obatPil, 
                            label: 'Obat Pil', 
                            count: '7',
                            width: 90,
                          ),
                          // Obat Tempel
                          _buildAssetItem(
                            iconPath: AppAssets.obatTempel, 
                            label: 'Obat Tempel', 
                            count: '5',
                            width: 100,
                          ),
                           // Krim Pelembab
                          _buildAssetItem(
                            iconPath: AppAssets.krimPelembab, 
                            label: 'Krim Pelembab', 
                            count: '39', 
                            width: 120,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // --- 6. Catatan Section (Dibuat menjadi TextField) ---
                    const _CatatanCard(),

                    SizedBox(height: SizeConfig.getHeight(10)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CatatanCard extends StatefulWidget {
  const _CatatanCard({Key? key}) : super(key: key);

  @override
  State<_CatatanCard> createState() => _CatatanCardState();
}

class _CatatanCardState extends State<_CatatanCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white, // Dijaga tetap putih agar pop up
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Tambahkan Catatan Anda Di sini...',
              hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
              border: InputBorder.none, // Hapus border
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}