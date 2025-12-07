import 'package:femora/models/cycle_data.dart';
import 'package:femora/screens/auth/forgot_password_screen.dart';
import 'package:femora/screens/auth/login_screen.dart';
import 'package:femora/screens/auth/password_success_screen.dart';
import 'package:femora/screens/setup/profile_setup_screen.dart';
import 'package:femora/screens/setup/weight_screen.dart';
import 'package:femora/screens/auth/register_screen.dart';
import 'package:femora/screens/auth/reset_password_screen.dart';
import 'package:femora/screens/auth/signup_screen.dart';
import 'package:femora/screens/home/home_screen.dart';
import 'package:femora/screens/onboarding/onboarding_screen.dart';
import 'package:femora/screens/profile/edit_cycle_screen.dart';
import 'package:femora/screens/profile/profile_screen.dart';
import 'package:femora/screens/setup/cycle_length_screen.dart';
import 'package:femora/screens/setup/period_duration_screen.dart';
import 'package:femora/screens/setup/last_period_screen.dart';
import 'package:femora/screens/home/home_screen.dart';
import 'package:femora/screens/profile/history_screen.dart';
import 'package:femora/screens/profile/cycle_history_detail_screen.dart';
import 'package:femora/screens/profile/cycle_edit_screen.dart'; // <-- BARU
import 'package:femora/screens/profile/mood_picker_screen.dart'; // <-- BARU
import 'package:go_router/go_router.dart';

class AppRoutes {
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

  // Main Routes
  static const String home = '/home';
  static const String history = '/history';
  static const String cycleHistoryDetail = '/cycle-history-detail';
  static const String cycleEdit = '/cycle-edit'; // <-- BARU
  static const String moodPicker = '/mood-picker'; // <-- BARU
}

import 'package:femora/screens/setup/period_duration_screen.dart';
import 'package:femora/screens/setup/profile_setup_screen.dart';
import 'package:femora/screens/setup/setup_loading_screen.dart';
import 'package:femora/screens/setup/weight_screen.dart';
import 'package:femora/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

// Rute navigasi disederhanakan untuk menggunakan service sebagai state management
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
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
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/password-success',
      builder: (context, state) => const PasswordSuccessScreen(),
    ),
    // Setup Routes
    // Alur Pengaturan (Setup Flow) - Disederhanakan
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/weight',
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
      path: '/period-duration',
      builder: (context, state) => const PeriodDurationScreen(),
    ),
    GoRoute(
      path: '/cycle-length',
      builder: (context, state) => const CycleLengthScreen(),
    ),
    GoRoute(
      path: '/last-period',
      builder: (context, state) => const LastPeriodScreen(),
    ),
    // Main Routes
    GoRoute(
      path: '/setup-loading',
      builder: (context, state) => const SetupLoadingScreen(),
    ),
    // Halaman Utama
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
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
    GoRoute( // <-- Rute BARU
      path: AppRoutes.cycleEdit,
      name: 'cycle-edit',
      builder: (context, state) => CycleEditScreen(
        initialDate: state.extra as DateTime,
      ),
    ),
    GoRoute( // <-- Rute BARU
      path: AppRoutes.moodPicker,
      name: 'mood-picker',
      builder: (context, state) => MoodPickerScreen(
        initialMood: state.extra as String,
      ),
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
      routes: [
        GoRoute(
          path: 'edit_cycle',
          builder: (context, state) => const EditCycleScreen(),
        ),
      ],
    ),
  ],
);