import 'package:flutter/material.dart';

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home (Active)
           _NavBarItem(
            isActive: true,
            icon: Icons.home_filled, // Placeholder icon
            activeColor: const Color(0xFFF75270),
            inactiveColor: Colors.white,
          ),
          
          // Calendar
          _NavBarItem(
            isActive: false,
            icon: Icons.calendar_today,
            activeColor: const Color(0xFFF75270),
            inactiveColor: const Color(0xFF2E2E2E),
          ),

          // Article
           _NavBarItem(
            isActive: false,
            icon: Icons.article_outlined,
             activeColor: const Color(0xFFF75270),
            inactiveColor: const Color(0xFF2E2E2E),
          ),

          // Profile
           _NavBarItem(
            isActive: false,
            icon: Icons.person_outline,
             activeColor: const Color(0xFFF75270),
            inactiveColor: const Color(0xFF2E2E2E),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;

  const _NavBarItem({
    Key? key,
    required this.isActive,
    required this.icon,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor, // Background for active is handled by parent container in design, but simplified here
        shape: BoxShape.circle,
         boxShadow: isActive ? [
          BoxShadow(
            color: activeColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey, // Adjust icon color based on design
      ),
    );
  }
}
