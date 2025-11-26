import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF75270),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Center(
                              child: Column(
                                children: const [
                                  Text(
                                    'Lengkapi Profil',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFFDC143C),
                                      fontSize: 30,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      height: 1.20,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Bantu kami mengenal tubuhmu lebih baik',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF808080),
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.20,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Tanggal Lahir
                            const Text(
                              'Tanggal Lahir',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: _buildTextField(
                                  controller: _dobController,
                                  hintText: 'DD/MM/YYYY',
                                  suffixIcon: Icons.calendar_today_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Row for Weight and Height
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Berat (kg)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _buildTextField(
                                        controller: _weightController,
                                        hintText: '00',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tinggi (cm)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 1.20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      _buildTextField(
                                        controller: _heightController,
                                        hintText: '000',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Button Simpan -> Navigasi ke Setup Siklus
                            GestureDetector(
                              onTap: () {
                                if (_dobController.text.isEmpty ||
                                    _weightController.text.isEmpty ||
                                    _heightController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Harap lengkapi data')),
                                  );
                                  return;
                                }
                                // Navigate to Cycle Length Setup
                                context.push(AppRoutes.cycleLength);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF75270),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: const Text(
                                  'Simpan',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF808080),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ).copyWith(
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: const Color(0xFFF75270), size: 20)
              : null,
           contentPadding: suffixIcon != null ? const EdgeInsets.only(top: 2) : null,
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );
  }
}
