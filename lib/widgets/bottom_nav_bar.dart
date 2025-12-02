
import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return SizedBox(
      width: 216,
      height: 72, // Tinggi disesuaikan dengan bola terbesar
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lapisan 1: Latar belakang hitam berbentuk kapsul
          Container(
            width: 216,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFF2E2E2E),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          // Lapisan 2 & 3: Bola dan ikon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              return _NavBarItem(
                item: items[index],
                isSelected: isSelected,
                onTap: () => onTap(index),
                isCenter: index == 1, // The center item is at index 1
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final bool isCenter;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.isCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72, // Lebar setiap item bola
        height: 72, // Tinggi setiap item bola
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Lapisan 2: Bola tatakan untuk menciptakan bentuk 'bumpy'
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF2E2E2E), // Sama dengan latar belakang utama
                shape: BoxShape.circle,
              ),
            ),

            // Lapisan 3: Lingkaran Ikon (putih atau pink)
            AnimatedContainer(
              duration: AppDurations.fast,
              width: isCenter ? 64 : 60,
              height: isCenter ? 64 : 60,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: isSelected ? Colors.white : Colors.grey.shade400,
                size: isCenter ? 32 : 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.route,
  });
}
