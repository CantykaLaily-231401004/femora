class CyclePrediction {
  final DateTime lastPeriodStart;
  final int periodDuration;
  final int minCycleLength;
  final int maxCycleLength;
  final bool isRegular;

  DateTime? predictedPeriodStart;
  DateTime? predictedPeriodEnd;
  DateTime? earliestPeriodStart;
  DateTime? latestPeriodStart;

  CyclePrediction({
    required this.lastPeriodStart,
    required this.periodDuration,
    required this.minCycleLength,
    required this.maxCycleLength,
    required this.isRegular,
  }) {
    _calculate();
  }

  void _calculate() {
    int avgCycle;
    if (isRegular) {
      // Jika siklus teratur, hanya ada satu nilai panjang siklus.
      avgCycle = minCycleLength;
    } else {
      // Jika tidak teratur, hitung rata-rata dari rentang.
      avgCycle = ((minCycleLength + maxCycleLength) / 2).round();
    }

    // Logika inti prediksi
    predictedPeriodStart = lastPeriodStart.add(Duration(days: avgCycle));
    
    // Akhir periode didasarkan pada awal prediksi + durasi
    predictedPeriodEnd = predictedPeriodStart!.add(Duration(days: periodDuration - 1));

    // Jendela prediksi untuk siklus tidak teratur
    earliestPeriodStart = lastPeriodStart.add(Duration(days: minCycleLength));
    latestPeriodStart = lastPeriodStart.add(Duration(days: maxCycleLength));
  }
}
