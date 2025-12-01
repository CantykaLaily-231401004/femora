import 'package:femora/screens/onboarding/onboarding_screen.dart';
import 'package:femora/screens/auth/signup_screen.dart';
import 'package:femora/screens/splash/splash_screen.dart';
import 'package:femora/screens/auth/register_screen.dart';
import 'package:femora/screens/auth/login_screen.dart';
import 'package:femora/screens/auth/forgot_password_screen.dart';
import 'package:femora/screens/auth/reset_password_screen.dart';
import 'package:femora/screens/auth/password_success_screen.dart';
import 'package:femora/screens/setup/profile_setup_screen.dart';
import 'package:femora/screens/setup/weight_screen.dart';
import 'package:femora/screens/setup/period_duration_screen.dart';
import 'package:femora/screens/setup/cycle_length_screen.dart';
import 'package:femora/screens/setup/last_period_screen.dart';
import 'package:femora/screens/home/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
  static const String register = '/register';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String passwordSuccess = '/password-success';
  static const String profileSetup = '/profile-setup';
  static const String weight = '/weight';
  static const String periodDuration = '/period-duration';
  static const String cycleLength = '/cycle-length';
  static const String lastPeriod = '/last-period';
  static const String home = '/home';
}

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: 'reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.passwordSuccess,
      name: 'password-success',
      builder: (context, state) => const PasswordSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      name: 'profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.weight,
      name: 'weight',
      builder: (context, state) => const WeightScreen(),
    ),
    GoRoute(
      path: AppRoutes.periodDuration,
      name: 'period-duration',
      builder: (context, state) => const PeriodDurationScreen(),
    ),
    GoRoute(
      path: AppRoutes.cycleLength,
      name: 'cycle-length',
      builder: (context, state) => const CycleLengthScreen(),
    ),
    GoRoute(
      path: AppRoutes.lastPeriod,
      name: 'last-period',
      builder: (context, state) => const LastPeriodScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
