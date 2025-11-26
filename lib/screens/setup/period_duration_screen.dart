import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class PeriodDurationScreen extends StatefulWidget {
  const PeriodDurationScreen({Key? key}) : super(key: key);

  @override
  State<PeriodDurationScreen> createState() => _PeriodDurationScreenState();
}

class _PeriodDurationScreenState extends State<PeriodDurationScreen> {
  int _selectedPeriodDuration = 5; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            // Gradient Background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 494,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF75270),
                      Color(0xFFFDEBD0),
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Progress Indicator 2/5
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new, size: 24),
                          ),
                        ),
                        const Spacer(),
                        _buildProgressStep(isActive: false), // Step 1 done
                        const SizedBox(width: 3),
                        _buildProgressStep(isActive: true), // Step 2 active
                        const SizedBox(width: 3),
                        _buildProgressStep(isActive: false),
                        const SizedBox(width: 3),
                        _buildProgressStep(isActive: false),
                        const SizedBox(width: 3),
                        _buildProgressStep(isActive: false),
                        const SizedBox(width: 10),
                        const Text(
                          '2 / 5',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'Berapa Lama Menstruasi Anda Biasanya?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFDC143C),
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Wheel Picker Container
                    Container(
                      height: 350,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 29.40,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoPicker(
                        itemExtent: 60,
                        scrollController: FixedExtentScrollController(initialItem: _selectedPeriodDuration - 1),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _selectedPeriodDuration = index + 1;
                          });
                        },
                        children: List<Widget>.generate(14, (int index) { // 1 to 14 days
                          return Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: _selectedPeriodDuration == (index + 1)
                                    ? Colors.black // Active color
                                    : const Color(0xFFBEBEBE), // Inactive color
                                fontSize: 32,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const Spacer(),

                    // Continue Button
                    GestureDetector(
                      onTap: () {
                         context.push(AppRoutes.lastPeriod);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF75270),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          'Continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep({required bool isActive}) {
    return Container(
      width: 30,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDC143C) : const Color(0xFFFFF3F4),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
