import 'package:femora/config/constants.dart';
import 'package:femora/widgets/page_header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Use the reusable PageHeader for the background and greeting
          const PageHeader(userName: 'Ningning'),

          // The rest of the page content, scrolling on top of the header
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add space to push content below the greeting text in the PageHeader
                    const SizedBox(height: 120),

                    // Profile card
                    _buildProfileCard(),
                    const SizedBox(height: 32),

                    // General section title
                    const Text(
                      'General',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    // General options card
                    _buildGeneralSection(context),
                    
                    // Add space at the bottom for the nav bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Placeholder
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ningning',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  'ningning123@gmail.com',
                  style: TextStyle(color: AppColors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildProfileOption(
            context,
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            onTap: () { /* TODO: Navigate to Settings */ },
          ),
          _buildProfileOption(
            context,
            icon: Icons.notifications_none_outlined,
            title: 'Alarm Pengingat',
            onTap: () { /* TODO: Navigate to Alarm */ },
          ),
          _buildProfileOption(
            context,
            icon: Icons.history,
            title: 'Riwayat',
            onTap: () { /* TODO: Navigate to History */ },
          ),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () { /* TODO: Navigate to Help */ },
            showDivider: false, // No divider for the last item
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool showDivider = true}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 24),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 64.0), // Align with text
              child: Divider(height: 1, color: AppColors.borderColor.withOpacity(0.5)),
            ),
        ],
      ),
    );
  }
}
