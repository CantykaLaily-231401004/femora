import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/provider/auth_provider.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.userChanges().listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  ImageProvider? _getProfileImageProvider(String? photoURL) {
    if (photoURL == null) return null;
    if (photoURL.startsWith('data:image')) {
      try {
        final uri = Uri.parse(photoURL);
        return MemoryImage(uri.data!.contentAsBytes());
      } catch (e) {
        return null;
      }
    }
    return NetworkImage(photoURL);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Keluar',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Yakin Ingin Keluar?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        final auth = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        await auth.logout();
                        if (context.mounted) {
                          context.go(AppRoutes.login);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Ya, Keluar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleDataService = Provider.of<CycleDataService>(
      context,
      listen: false,
    );

    return ValueListenableBuilder<String?>(
      valueListenable: cycleDataService.userNameNotifier,
      builder: (context, userName, _) {
        final String displayName = userName ?? 
            _currentUser?.displayName ?? 
            'Femora User';
        final String displayEmail = _currentUser?.email ?? 
            'email@example.com';
        final String? photoURL = _currentUser?.photoURL;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.personalData),
                  child: _buildProfileCard(
                    context,
                    name: displayName,
                    email: displayEmail,
                    photoURL: photoURL,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildGeneralSection(context),
                const SizedBox(height: 100), // Space for the nav bar
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required String name,
    required String email,
    String? photoURL,
  }) {
    final imageProvider = _getProfileImageProvider(photoURL);
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? const Icon(
                    Icons.person,
                    size: 28,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                  ),
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
            title: 'Ubah Kata Sandi',
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          _buildProfileOption(
            context,
            icon: Icons.notifications_none_outlined,
            title: 'Alarm Pengingat',
            onTap: () => context.push(AppRoutes.alarm),
          ),
          _buildProfileOption(
            context,
            icon: Icons.history,
            title: 'Riwayat',
            onTap: () => context.push(AppRoutes.history),
          ),
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () => context.push(AppRoutes.help),
          ),
          _buildProfileOption(
            context,
            icon: Icons.logout,
            title: 'Keluar',
            onTap: () => _showLogoutDialog(context),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.grey),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 64.0),
              child: Divider(
                height: 1,
                color: AppColors.borderColor.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}