import 'package:femora/screens/onboarding_screen.dart';
import 'package:femora/screens/auth/signup_screen.dart';
import 'package:femora/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

// Definisikan path rute sebagai konstanta agar mudah dikelola
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signup = '/signup';
}

// Konfigurasi GoRouter terpusat di sini
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
  ],
);
