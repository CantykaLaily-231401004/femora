import 'package:femora/config/routes.dart';
import 'package:femora/config/theme.dart';
import 'package:femora/provider/auth_provider.dart';
// import 'package:femora/provider/history_provider.dart'; // Import ini sudah dinonaktifkan
import 'package:femora/services/cycle_data_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        // ChangeNotifierProvider<HistoryProvider> telah dihapus.
        Provider<CycleDataService>(
          create: (_) => CycleDataService(),
        ),
      ],
      child: MaterialApp.router(
        // Perhatikan: Line di bawah ini mungkin perlu diubah menjadi 'routerConfig: router,'
        // tergantung bagaimana 'router' didefinisikan di lib/config/routes.dart.
        routerConfig: AppRouter.createRouter(), 
        debugShowCheckedModeBanner: false,
        title: 'Femora',
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const ClampingScrollPhysics(),
            ),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
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