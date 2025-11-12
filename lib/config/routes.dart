import 'package:femora/screens/onboarding_screen.dart';
import 'package:femora/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

// Definisikan path rute sebagai konstanta agar mudah dikelola
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
}

// Konfigurasi GoRouter terpusat di sini
final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash, // Mulai dari splash screen
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
    // Tambahkan rute lain di sini nanti, contoh:
    // GoRoute(
    //   path: '/login',
    //   name: 'login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
  ],
);

class Text {
  const Text();
}

class Center {
  const Center();
}
