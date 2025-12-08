import 'package:femora/config/constants.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:go_router/go_router.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  final String initialPhoneNumber;
  const EditPhoneNumberScreen({super.key, required this.initialPhoneNumber});

  @override
  State<EditPhoneNumberScreen> createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  String _countryCode = '+62'; // Default to Indonesia
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Logic to parse initialPhoneNumber if it exists
    if (widget.initialPhoneNumber.isNotEmpty) {
      // This is a simple parsing logic. A more robust one would be needed for production.
      // For now, assuming the format is `+code number` or just `number`.
      if (widget.initialPhoneNumber.startsWith('+')) {
        // trying to find a valid country code
        // simple logic: check for 1 to 4 digits after +
        for (int i = 4; i > 1; i--) {
            try {
                final code = widget.initialPhoneNumber.substring(0, i);
                final number = widget.initialPhoneNumber.substring(i).trim();
                // A simple validation for country code
                CountryCode.fromDialCode(code);
                _countryCode = code;
                _phoneNumberController.text = number;
                return;
            } catch(e) {
                // Was not a valid country code of this length
            }
        }
      }
       _phoneNumberController.text = widget.initialPhoneNumber;
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.dialCode!;
    });
  }

  void _savePhoneNumber() {
    final newPhoneNumber = '$_countryCode ${_phoneNumberController.text.trim()}';
    // Return the new phone number to the previous screen
    context.pop(newPhoneNumber);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: CustomBackButton(onPressed: () => context.pop()),
        ),
        title: const Text(
          'Ubah Nomor Telepon',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection: 'ID',
                    favorite: const ['+62', 'ID'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: AppTextStyles.fontFamily,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Nomor Telepon',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Simpan',
              onPressed: _savePhoneNumber,
            ),
            SizedBox(height: SizeConfig.getHeight(4)),
          ],
        ),
      ),
    );
  }
}
