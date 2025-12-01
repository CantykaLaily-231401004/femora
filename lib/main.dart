import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for the Indonesian locale
  await initializeDateFormatting('id_ID', null);
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Femora',
      theme: AppTheme.lightTheme,
      
      // Builder to access MediaQuery throughout the app
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(physics: const ClampingScrollPhysics()),
          child: MediaQuery(
            // Keep text scale factor at 1.0
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
        );
      },
    );
  }
}
