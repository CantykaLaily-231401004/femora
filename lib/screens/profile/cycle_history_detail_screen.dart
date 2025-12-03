import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/size_config.dart';

class CycleHistoryDetailScreen extends StatelessWidget {
  const CycleHistoryDetailScreen({Key? key}) : super(key: key);

  // Helper widget for the two main data cards
  Widget _buildCycleDataCard({required IconData icon, required Color color, required String value, required String label}) {
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

  // Helper widget for the Previous History List Item (with visual bar)
  Widget _buildPreviousHistoryItem({
    required String dateRange,
    required int periodDays,
    required int cycleLengthDays,
    required Color periodColor,
  }) {
    // Menghitung panjang bar visual. Desain menunjukkan 25 hari cycle length.
    const int totalDots = 28; 
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateRange,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.getFontSize(16),
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$cycleLengthDays',
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
          // Visual Cycle Bar
          Row(
            children: List.generate(totalDots, (index) {
              final isPeriodDay = index < periodDays;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isPeriodDay ? periodColor : periodColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        'Siklusku',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.getFontSize(24),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50), // Balance the back button
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Data Cards (Masa Menstruasi & Siklus Menstruasi)
                    Row(
                      children: [
                        _buildCycleDataCard(
                          icon: Icons.water_drop_outlined,
                          color: AppColors.primary,
                          value: '3 hari',
                          label: 'Masa Menstruasi',
                        ),
                        _buildCycleDataCard(
                          icon: Icons.calendar_today_outlined,
                          color: const Color(0xFF6B6B6B),
                          value: '26 hari',
                          label: 'Siklus Menstruasi',
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.getHeight(5)),

                    // 2. Edit Siklus Button (FIXED STRUCTURE)
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigasi ke Edit Screen dengan membawa data tanggal dummy
                          final dummyDate = DateTime.now(); 
                          context.push(AppRoutes.cycleEdit, extra: dummyDate);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 28),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Edit Siklus',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: SizeConfig.getHeight(4)),

                    // 3. Riwayat Sebelumnya Header
                    Text(
                      'Riwayat Sebelumnya',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.getFontSize(20),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Divider(color: AppColors.borderColorDark, height: 25, thickness: 1),

                    // 4. Previous History List
                    _buildPreviousHistoryItem(
                      dateRange: '18 Januari – 24 Januari 2024',
                      periodDays: 7, 
                      cycleLengthDays: 25,
                      periodColor: AppColors.primary,
                    ),
                    _buildPreviousHistoryItem(
                      dateRange: '25 Desember – 31 Desember 2023',
                      periodDays: 6, 
                      cycleLengthDays: 25,
                      periodColor: AppColors.primary,
                    ),
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