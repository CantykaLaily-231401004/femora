import 'package:flutter/material.dart';
import 'package:femora/models/cycle_phase_data.dart';
import 'package:femora/core/utils/size_config.dart';

class CyclePhaseCard extends StatelessWidget {
  final CyclePhaseData data;

  const CyclePhaseCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Countdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${data.subtitle} ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  data.remainingTime,
                  style: TextStyle(
                    color: data.secondaryColor,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // Phase Title with Icon
          Row(
            children: [
              // Placeholder Icon
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // What Happens Section
          const Text(
            'Yang Terjadi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.whatHappens,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 16),

          // Tips Section
          const Text(
            'Tips',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.tips,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
