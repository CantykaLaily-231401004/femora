import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/core/utils/size_config.dart';

/// Reusable Bottom Navigation Bar
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
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.lg),
          topRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getWidth(5),
            vertical: SizeConfig.getHeight(1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _NavBarItem(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getWidth(4),
          vertical: SizeConfig.getHeight(1.2),
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
              size: SizeConfig.getFontSize(24),
            ),
            SizedBox(height: SizeConfig.getHeight(0.5)),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontSize: SizeConfig.getFontSize(12),
                fontFamily: AppTextStyles.fontFamily,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Model untuk Bottom Nav Item
class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
