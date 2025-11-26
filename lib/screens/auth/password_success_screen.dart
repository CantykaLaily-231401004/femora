import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({Key? key}) : super(key: key);

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

            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            // Typically success screens might not have a back button to "undo" the success,
                            // but based on the design pattern, it is there.
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // White Card Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x07000000),
                              blurRadius: 37.60,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Success Icon Stack
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE7EA),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD0D5),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF75270),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 20),

                            // Success Text
                            const Text(
                              'Selesai',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFDC143C),
                                fontSize: 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Kata sandimu berhasil diubah!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.20,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Home Button
                            GestureDetector(
                              onTap: () {
                                // Navigate back to Login or Home
                                context.go(AppRoutes.home); 
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF75270),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Text(
                                  'Kembali ke Beranda',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    height: 1.20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 200), // Adjust spacing

                      // Footer Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: const SizedBox(
                              width: 105,
                              child: Text(
                                'Kebijakan Privasi',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Syarat & Ketentuan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 1.20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
