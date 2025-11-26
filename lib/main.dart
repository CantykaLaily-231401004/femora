import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/config/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Femora',
      theme: AppTheme.lightTheme,
      
      // Builder untuk mengakses MediaQuery di seluruh app
      builder: (context, child) {
        return MediaQuery(
          // Membuat text scale factor tetap 1.0
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
