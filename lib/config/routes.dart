import 'package:femora/models/cycle_data.dart';
import 'package:femora/screens/auth/forgot_password_screen.dart';
import 'package:femora/screens/auth/login_screen.dart';
import 'package:femora/screens/auth/password_success_screen.dart';
import 'package:femora/screens/auth/register_screen.dart';
import 'package:femora/screens/auth/reset_password_screen.dart';
import 'package:femora/screens/auth/signup_screen.dart';
import 'package:femora/screens/home/home_screen.dart';
import 'package:femora/screens/onboarding/onboarding_screen.dart';
import 'package:femora/screens/profile/edit_cycle_screen.dart';
import 'package:femora/screens/profile/profile_screen.dart';
import 'package:femora/screens/setup/cycle_length_screen.dart';
import 'package:femora/screens/setup/last_period_screen.dart';
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
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
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
