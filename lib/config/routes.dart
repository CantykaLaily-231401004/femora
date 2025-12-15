import 'package:femora/config/constants.dart';
import 'package:femora/screens/auth/forgot_password_screen.dart';
import 'package:femora/screens/auth/login_screen.dart';
import 'package:femora/screens/auth/password_success_screen.dart';
import 'package:femora/screens/auth/register_screen.dart';
import 'package:femora/screens/auth/reset_password_screen.dart';
import 'package:femora/screens/auth/signup_screen.dart';
import 'package:femora/screens/education/education_screen.dart';
import 'package:femora/screens/home/home_screen.dart';
import 'package:femora/screens/onboarding/onboarding_screen.dart';
import 'package:femora/screens/profile/alarm_screen.dart';
import 'package:femora/screens/profile/change_password_screen.dart';
import 'package:femora/screens/profile/cycle_edit_screen.dart';
import 'package:femora/screens/profile/cycle_history_detail_screen.dart';
import 'package:femora/screens/profile/edit_cycle_screen.dart';
import 'package:femora/screens/profile/edit_phone_number_screen.dart';
import 'package:femora/screens/profile/help_screen.dart';
import 'package:femora/screens/profile/history_screen.dart';
import 'package:femora/screens/profile/mood_picker_screen.dart';
import 'package:femora/screens/profile/personal_data_screen.dart';
import 'package:femora/screens/profile/profile_screen.dart';
import 'package:femora/screens/setup/cycle_length_screen.dart';
import 'package:femora/screens/setup/last_period_screen.dart';
import 'package:femora/screens/setup/period_duration_screen.dart';
import 'package:femora/screens/setup/profile_setup_screen.dart';
import 'package:femora/screens/setup/setup_loading_screen.dart';
import 'package:femora/screens/setup/weight_screen.dart';
import 'package:femora/screens/splash/splash_screen.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:femora/widgets/bottom_nav_bar.dart';
import 'package:femora/widgets/gradient_background.dart';
import 'package:femora/widgets/home_header.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Route path constants
class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String passwordSuccess = '/password-success';

  // Setup Routes
  static const String profileSetup = '/profile-setup';
  static const String weight = '/weight';
  static const String cycleLength = '/cycle-length';
  static const String periodDuration = '/period-duration';
  static const String lastPeriod = '/last-period';
  static const String setupLoading = '/setup-loading';

  // Main App Routes
  static const String home = '/home';
  static const String edukasi = '/edukasi';
  static const String profile = '/profile';
  
  // History Routes
  static const String history = '/history';
  static const String cycleHistoryDetail = '/cycle-history-detail';
  
  // Note: Pastikan di Home Screen kamu menggunakan '/cycle-edit' bukan '/profile/edit_cycle'
  static const String cycleEdit = '/cycle-edit'; 
  static const String moodPicker = '/mood-picker';
  
  // Profile Settings Routes
  static const String editCycle = '/edit-cycle'; // Ini sepertinya screen lama?
  static const String alarm = '/alarm';
  static const String changePassword = '/change-password';
  static const String personalData = '/personal-data';
  static const String editPhoneNumber = '/edit-phone-number';
  static const String help = '/help';
}

/// Router configuration
class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        // ============================================
        // AUTH & ONBOARDING ROUTES
        // ============================================
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          builder: (context, state) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.passwordSuccess,
          builder: (context, state) => const PasswordSuccessScreen(),
        ),

        // ============================================
        // SETUP ROUTES
        // ============================================
        GoRoute(
          path: AppRoutes.profileSetup,
          builder: (context, state) => const ProfileSetupScreen(),
        ),
        GoRoute(
          path: AppRoutes.weight,
          builder: (context, state) => const WeightScreen(),
        ),
        GoRoute(
          path: AppRoutes.cycleLength,
          name: 'cycle-length',
          builder: (context, state) => const CycleLengthScreen(),
        ),
        GoRoute(
          path: AppRoutes.periodDuration,
          name: 'period-duration',
          builder: (context, state) => const PeriodDurationScreen(),
        ),
        GoRoute(
          path: AppRoutes.lastPeriod,
          name: 'last-period',
          builder: (context, state) => const LastPeriodScreen(),
        ),
        GoRoute(
          path: AppRoutes.setupLoading,
          builder: (context, state) => const SetupLoadingScreen(),
        ),

        // ============================================
        // HISTORY & CYCLE ROUTES
        // ============================================
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.cycleHistoryDetail,
          name: 'cycle-history-detail',
          builder: (context, state) => const CycleHistoryDetailScreen(),
        ),
        
        // --- BAGIAN YANG DIPERBAIKI ---
        GoRoute(
          path: AppRoutes.cycleEdit, // '/cycle-edit'
          name: 'cycle-edit',
          builder: (context, state) {
            // Kita kirim parameter extra langsung ke CycleEditScreen
            // extra bisa berupa DateTime atau null
            return CycleEditScreen(
              extra: state.extra, 
            );
          },
        ),
        GoRoute(
          path: AppRoutes.moodPicker,
          name: 'mood-picker',
          builder: (context, state) => MoodPickerScreen(
            // Tambahkan default value biar ga crash kalau null
            initialMood: state.extra as String? ?? 'Baik',
          ),
        ),
        // -----------------------------

        GoRoute(
          path: AppRoutes.editCycle,
          builder: (context, state) => const EditCycleScreen(),
        ),

        // ============================================
        // PROFILE SETTINGS ROUTES
        // ============================================
        GoRoute(
          path: AppRoutes.alarm,
          builder: (context, state) => const AlarmScreen(),
        ),
        GoRoute(
          path: AppRoutes.changePassword,
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: AppRoutes.personalData,
          builder: (context, state) => const PersonalDataScreen(),
        ),
        GoRoute(
          path: AppRoutes.editPhoneNumber,
          builder: (context, state) => EditPhoneNumberScreen(
            initialPhoneNumber: state.extra as String? ?? '',
          ),
        ),
        GoRoute(
          path: AppRoutes.help,
          builder: (context, state) => const HelpScreen(),
        ),

        // ============================================
        // MAIN APP ROUTES (With Shared UI & NavBar)
        // ============================================
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithSharedUI(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.edukasi,
              builder: (context, state) => const EducationScreen(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================
// SHARED UI WRAPPER
// ============================================
class ScaffoldWithSharedUI extends StatelessWidget {
  const ScaffoldWithSharedUI({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    const navItems = [
      BottomNavItem(icon: Icons.book_outlined, route: AppRoutes.edukasi),
      BottomNavItem(icon: Icons.home_outlined, route: AppRoutes.home),
      BottomNavItem(icon: Icons.person_outline, route: AppRoutes.profile),
    ];

    int getCurrentIndex() {
      final location = GoRouterState.of(context).uri.toString();
      if (location.startsWith(AppRoutes.edukasi)) return 0;
      if (location.startsWith(AppRoutes.home)) return 1;
      if (location.startsWith(AppRoutes.profile)) return 2;
      return 1; // default to home
    }

    void onNavBarTapped(int index) {
      context.go(navItems[index].route);
    }

    final currentIndex = getCurrentIndex();
    
    // Pastikan CycleDataService tersedia di sini (dari Provider di main.dart)
    final cycleDataService = Provider.of<CycleDataService>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GradientBackground(
              height: SizeConfig.getHeight(40),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: HomeHeader(
                    userNameNotifier: cycleDataService.userNameNotifier,
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(
                currentIndex: currentIndex,
                onTap: onNavBarTapped,
                items: navItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}