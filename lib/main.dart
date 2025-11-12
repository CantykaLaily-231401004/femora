import 'package:femora/config/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Gunakan MaterialApp.router untuk sistem navigasi modern
    return MaterialApp.router(
      // Ambil konfigurasi router dari file routes.dart
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Femora',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
    );
  }
}
