import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class CycleHistoryDetailScreen extends StatelessWidget {
  const CycleHistoryDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for display purposes
    final dummyDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat Siklus'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the edit cycle screen
            context.push(AppRoutes.editCycle, extra: dummyDate);
          },
          child: const Text('Edit Siklus'),
        ),
      ),
    );
  }
}
