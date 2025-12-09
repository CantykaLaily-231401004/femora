import 'package:femora/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/size_config.dart';

const Color _darkThemeBackground = Color(0xFF1E1E1E);

// Widget Kustom untuk ikon Aliran
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
      child: const Center(
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
                color: Colors.black, // CHANGED: Hitam
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.black), // CHANGED: Hitam
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
                    color: Colors.black, // CHANGED: Hitam
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
                color: Colors.black, // CHANGED: Hitam
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk item yang bisa di-scroll (Aliran, Mood)
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
          SizedBox(
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
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
                if (count != '0')
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 22,
                        minHeight: 22,
                      ),
                      child: Center(
                        child: Text(
                          count,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
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

  // Widget untuk item Gejala
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
          SizedBox(
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 48,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: AppColors.primary, size: 30),
                  ),
                ),
                if (count != '0')
                  Positioned(
                    top: -2,
                    right: 28,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 22,
                        minHeight: 22,
                      ),
                      child: Center(
                        child: Text(
                          count,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
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
          Image.asset(AppAssets.logoRed, width: 70), 
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final List<Map<String, String>> newSymptomData = [
      {'label': 'Mood Swing', 'count': '0', 'path': AppAssets.moodSwing},
      {'label': 'Kembung', 'count': '0', 'path': AppAssets.kembung},
      {'label': 'Nyeri Punggung', 'count': '0', 'path': AppAssets.nyeriPunggung},
      {'label': 'Kelelahan', 'count': '0', 'path': AppAssets.kelelahan},
      {'label': 'Nyeri Perut', 'count': '0', 'path': AppAssets.nyeriPerut},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 224, 224),
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

                    // --- 2. Aliran Section ---
                    _buildSectionHeader('Aliran'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildScrollableItem(
                              iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: false),
                              label: 'Ringan', count: '0', width: double.infinity
                            ),
                          ),
                          Expanded(
                            child: _buildScrollableItem(
                              iconWidget: _FlowIcon(color: AppColors.primary.withOpacity(0.7), isHeavy: false),
                              label: 'Normal', count: '0', width: double.infinity
                            ),
                          ),
                          Expanded(
                            child: _buildScrollableItem(
                              iconWidget: const _FlowIcon(color: AppColors.primary, isHeavy: true), 
                              label: 'Banyak', count: '0', width: double.infinity
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- 3. Gejala Section ---
                    _buildSectionHeader('Gejala'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: newSymptomData.map((symptom) {
                          return _buildAssetItem(
                            iconPath: symptom['path']!, 
                            label: symptom['label']!, 
                            count: symptom['count']!,
                            width: 120,
                          );
                        }).toList(),
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
                            label: 'Baik', count: '0', backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                          ),
                          _buildScrollableItem(
                            iconWidget: const Text('😞', style: TextStyle(fontSize: 28)),
                            label: 'Buruk', count: '0', backgroundColor: AppColors.primaryLight, width: SizeConfig.getWidth(35)
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- 5. Catatan Section ---
                    const _CatatanCard(),

                    const SizedBox(height: 100),
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
        color: AppColors.white,
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
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 18, 
              color: Colors.black, // CHANGED: Hitam
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Tambahkan Catatan Anda Di sini...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              color: Colors.black, // CHANGED: Hitam
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}