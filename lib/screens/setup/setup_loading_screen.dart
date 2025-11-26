import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class SetupLoadingScreen extends StatefulWidget {
  const SetupLoadingScreen({Key? key}) : super(key: key);

  @override
  State<SetupLoadingScreen> createState() => _SetupLoadingScreenState();
}

class _SetupLoadingScreenState extends State<SetupLoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create an integer animation from 0 to 100
    _animation = IntTween(begin: 0, end: 100).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation
    _controller.forward().then((_) {
      // When animation completes (after 3 seconds), navigate to home
      context.go(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Mempersiapkan kalender pribadi Anda...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFDC143C),
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),

                    // Circular Progress
                    SizedBox(
                      width: 215,
                      height: 215,
                      child: Stack(
                        children: [
                          Container(
                            width: 215,
                            height: 215,
                            decoration: const ShapeDecoration(
                              color: Color(0xFFF75270),
                              shape: OvalBorder(),
                            ),
                          ),
                          // Inner decoration details from Figma
                          Positioned(
                            left: 5.55,
                            top: 42.84,
                            child: Container(
                              width: 31.73,
                              height: 31.73,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF75270),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 15.87,
                                  height: 15.87,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFF9F9F9),
                                    shape: OvalBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_animation.value}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 50, // Adjusted size
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 1.20,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontFamily: 'Instrument Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 1.20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    const Text(
                      'Memuat data… hampir selesai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
