import 'package:femora/models/cycle_phase_data.dart';
import 'package:flutter/material.dart';

class CyclePhaseCard extends StatelessWidget {
  final CyclePhaseData data;

  const CyclePhaseCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                // Header: Current Phase Title
                Row(
                  children: [
                    Image.asset( // Use Image.asset for local assets
                      data.iconUrl,
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Sub-card: Countdown to next phase
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    textAlign: TextAlign.center, // This ensures the whole text block is centered
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        height: 1.2, // Adjust line height for better vertical alignment
                      ),
                      children: [
                        TextSpan(
                          text: '${data.subtitle} ', // Subtitle with a trailing space
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: data.remainingTime, // Remaining time text
                          style: TextStyle(
                            color: data.secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Details Section
                _buildDetailSection(data.descriptionTitle, data.whatHappens),
                const SizedBox(height: 12),
                _buildDetailSection('Tips', data.tips),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Text(
            content,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1.3, 
            ),
          ),
        ),
      ],
    );
  }
}
