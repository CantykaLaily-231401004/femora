import 'dart:async';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  static const String cycleEdit = '/cycle-edit';
  static const String moodPicker = '/mood-picker';
  
  // Profile Settings Routes
  static const String editCycle = '/edit-cycle';
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
      refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
      redirect: (BuildContext context, GoRouterState state) async {
        final location = state.matchedLocation;

        if (location == AppRoutes.splash) {
          return null;
        }

        final prefs = await SharedPreferences.getInstance();
        final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
        final loggedIn = FirebaseAuth.instance.currentUser != null;

        final unprotectedRoutes = [
          AppRoutes.onboarding,
          AppRoutes.login,
          AppRoutes.signup,
          AppRoutes.register,
          AppRoutes.forgotPassword,
          AppRoutes.resetPassword,
          AppRoutes.passwordSuccess,
        ];
        final isPublicRoute = unprotectedRoutes.contains(location);

        if (!loggedIn && !isPublicRoute) {
          return AppRoutes.login;
        }

        if (loggedIn) {
          final isAtAuthFlow = location == AppRoutes.login || location == AppRoutes.onboarding || location == AppRoutes.register;
          if (isAtAuthFlow) {
             return onboardingComplete ? AppRoutes.home : AppRoutes.profileSetup;
          }
        }

        return null;
      },
      routes: [
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
        GoRoute(
          path: AppRoutes.cycleEdit,
          name: 'cycle-edit',
          builder: (context, state) => CycleEditScreen(
            extra: state.extra,
          ),
        ),
        GoRoute(
          path: AppRoutes.moodPicker,
          name: 'mood-picker',
          builder: (context, state) => MoodPickerScreen(
            initialMood: state.extra as String? ?? 'Baik',
          ),
        ),
        GoRoute(
          path: AppRoutes.editCycle,
          builder: (context, state) => const EditCycleScreen(),
        ),
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
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithSharedUI(child: child);
          },
          routes: [
            GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const SizedBox(),
            ),
            GoRoute(
                path: AppRoutes.edukasi,
                builder: (context, state) => const SizedBox(),
            ),
            GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}

class ScaffoldWithSharedUI extends StatefulWidget {
  const ScaffoldWithSharedUI({required this.child, super.key});
  final Widget child;

  @override
  State<ScaffoldWithSharedUI> createState() => _ScaffoldWithSharedUIState();
}

class _ScaffoldWithSharedUIState extends State<ScaffoldWithSharedUI> {
  late PageController _pageController;
  int _currentIndex = 1; // Default to home

  static const _screens = [
    EducationScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  static const _navItems = [
    BottomNavItem(icon: Icons.book_outlined, route: AppRoutes.edukasi),
    BottomNavItem(icon: Icons.home_outlined, route: AppRoutes.home),
    BottomNavItem(icon: Icons.person_outline, route: AppRoutes.profile),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with a default page. didChangeDependencies will correct it.
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sync the PageView with the current route.
    final newIndex = _calculateCurrentIndex();
    if (_currentIndex != newIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
      // Use jumpToPage to prevent animation on initial load or deep link.
      _pageController.jumpToPage(newIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _calculateCurrentIndex() {
    final location = GoRouterState.of(context).uri.toString();
    // The order is Edukasi (0), Home (1), Profile (2)
    final index = _navItems.indexWhere((item) => location.startsWith(item.route));
    return index == -1 ? 1 : index; // Default to home (index 1)
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      // This is triggered by a swipe gesture. Navigate to the new route.
      context.go(_navItems[index].route);
    }
  }

  void _onNavBarTapped(int index) {
    // This is triggered by a tap on the nav bar. Animate to the new page.
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final cycleDataService = Provider.of<CycleDataService>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned.fill(
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
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    children: _screens,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onNavBarTapped,
                items: _navItems,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
