import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            // Gradient Background
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 426,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            const Text(
                              'Lupa Kata Sandi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFDC143C),
                                fontSize: 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Masukkan alamat emailmu untuk kirim tautan reset kata sandi',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Email Field
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  height: 1.20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: const Color(0xFFF1F1F1)),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email', // Example from design: ningning123@gmail.com
                                  hintStyle: TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 14,
                                    fontFamily: 'Instrument Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  icon: Icon(Icons.email_outlined, color: Colors.grey, size: 20),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Instrument Sans',
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Kirim OTP Button
                            GestureDetector(
                              onTap: () {
                                if (_emailController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Harap isi email')),
                                  );
                                  return;
                                }
                                // Navigate to Reset Password Screen
                                context.push(AppRoutes.resetPassword);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF75270),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Text(
                                  'Kirim Kode OTP',
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

                      const SizedBox(height: 320), // Adjust spacing to match layout

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
