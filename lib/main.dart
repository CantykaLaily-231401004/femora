import 'package:femora/config/constants.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/theme.dart';
import 'package:femora/provider/auth_provider.dart';
import 'package:femora/provider/history_provider.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services before running the app
  await initializeDateFormatting('id_ID', null);

  // Load data from shared preferences
  await CycleDataService().loadDataFromPrefs();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: AppRoutes.splash,
      routes: [
        // Rute yang tidak menggunakan NavBar
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
            initialDate: state.extra as DateTime,
          ),
        ),
        GoRoute(
          path: AppRoutes.moodPicker,
          name: 'mood-picker',
          builder: (context, state) => MoodPickerScreen(
            initialMood: state.extra as String,
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

        // ShellRoute untuk halaman dengan UI bersama
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<HistoryProvider>(
          create: (_) => HistoryProvider(),
        ),
        Provider<CycleDataService>(
          create: (_) => CycleDataService(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Femora',
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const ClampingScrollPhysics(),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            ),
          );
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
          Locale('en', 'US'),
        ],
        locale: const Locale('id', 'ID'),
      ),
    );
  }
}

// Widget "cangkang" untuk UI bersama (Latar Belakang, Header, NavBar)
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
