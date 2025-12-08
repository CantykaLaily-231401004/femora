import 'dart:convert';
import 'dart:typed_data';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:femora/config/routes.dart';
import 'package:femora/services/auth_controller.dart';
import 'package:femora/services/cycle_data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/size_config.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final AuthController _authController = AuthController();
  // State variables for user data
  String _email = 'email@example.com';
  String? _photoURL;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? _email;
        _photoURL = user.photoURL;
        // For now, phone number is stored locally in this state
      });
    }
  }

  // --- Edit Dialogs and Pickers ---

  Future<void> _showEditDialog(
      {required String title,
      required String initialValue,
      required Function(String) onSave,
      TextInputType keyboardType = TextInputType.text}) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), // Increased
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
           style: const TextStyle(fontSize: 18), // Increased
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.grey, fontSize: 16))), // Increased
          TextButton(
            onPressed: () {
              onSave(controller.text);
              context.pop();
            },
            child: const Text('Simpan',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)), // Increased
          ),
        ],
      ),
    );
  }

  Future<void> _showEditPhoneNumberDialog(String initialPhoneNumber, Function(String) onPhoneNumberSaved) async {
    final newPhoneNumber = await showDialog<String>(
      context: context,
      builder: (context) =>
          EditPhoneNumberDialog(initialPhoneNumber: initialPhoneNumber),
    );

    if (newPhoneNumber != null) {
      onPhoneNumberSaved(newPhoneNumber);
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  Future<void> _showWeightPicker(int initialWeight, Function(int) onWeightSelected) async {
    int tempWeight = initialWeight;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pilih Berat Badan',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), // Increased
        content: SizedBox(
          height: 150,
          width: 100,
          child: CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: tempWeight - 30),
            itemExtent: 40,
            onSelectedItemChanged: (int index) => tempWeight = index + 30,
            selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                capStartEdge: false, capEndEdge: false),
            children: List<Widget>.generate(121, (int index) {
              return Center(
                  child: Text((index + 30).toString(),
                      style: const TextStyle(
                          fontSize: 24, color: AppColors.primary))); // Increased
            }),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.grey, fontSize: 16))), // Increased
          TextButton(
            onPressed: () {
              onWeightSelected(tempWeight);
              context.pop();
            },
            child: const Text('Simpan',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)), // Increased
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Pilih dari Galeri', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_rear, color: AppColors.primary),
              title: const Text('Kamera Belakang', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera, cameraDevice: CameraDevice.rear);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_front, color: AppColors.primary),
              title: const Text('Kamera Depan', style: TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera, cameraDevice: CameraDevice.front);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, {CameraDevice cameraDevice = CameraDevice.rear}) async {
    setState(() => _isUploading = true);
    try {
      final XFile? pickedFile;
      if (source == ImageSource.camera) {
        pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: cameraDevice,
        );
      } else {
        pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
      }

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final image = img.decodeImage(bytes);

        if (image != null) {
          final resizedImage = img.copyResize(image, width: 200, height: 200);
          final base64Image = base64Encode(img.encodePng(resizedImage));

          String result =
              await _authController.updateUserProfilePicture(base64Image);

          if (result == "success") {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await user.reload();
              final reloadedUser = FirebaseAuth.instance.currentUser;
              setState(() {
                _photoURL = reloadedUser?.photoURL;
              });
            }
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Foto profil berhasil diperbarui.')),
              );
            }
          } else {
            throw Exception(result);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui foto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  ImageProvider? _getProfileImage() {
    if (_photoURL == null) return null;
    if (_photoURL!.startsWith('data:image')) {
      try {
        final uri = Uri.parse(_photoURL!);
        return MemoryImage(uri.data!.contentAsBytes());
      } catch (e) {
        return null;
      }
    }
    return NetworkImage(_photoURL!);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final cycleDataService = Provider.of<CycleDataService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: CustomBackButton(onPressed: () => context.pop())),
        title: const Text('Personal Data',
            style: TextStyle(
                fontSize: 22, // Increased
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: AppTextStyles.fontFamily)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getHeight(2)),
            Center(
              child: GestureDetector(
                onTap: _isUploading ? null : _showImageSourceDialog,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: _getProfileImage(),
                      child: _photoURL == null && !_isUploading
                          ? const Icon(Icons.person,
                              size: 50, color: AppColors.primary)
                          : _isUploading
                              ? const CircularProgressIndicator(
                                  color: AppColors.primary)
                              : null,
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                            border: Border.all(
                                color: AppColors.background, width: 3)),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.edit_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(3)),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getWidth(6),
                  vertical: SizeConfig.getHeight(1.5)),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 20,
                        offset: Offset(0, 4))
                  ]),
              child: Column(
                children: [
                  ValueListenableBuilder<String?>(
                      valueListenable: cycleDataService.userNameNotifier,
                      builder: (context, userName, _) {
                        return _buildDataRow(
                            label: 'Nama Pengguna',
                            value: userName ?? '',
                            icon: Icons.edit_outlined,
                            onTap: () {
                              _showEditDialog(
                                title: 'Ubah Nama Pengguna',
                                initialValue: userName ?? '',
                                onSave: (newUserName) {
                                  if (newUserName.trim().isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Nama tidak boleh kosong')),
                                    );
                                    return;
                                  }
                                  cycleDataService.updateUserName(newUserName);
                                  FirebaseAuth.instance.currentUser
                                      ?.updateDisplayName(newUserName);
                                },
                              );
                            });
                      }),
                  _buildDataRow(
                    label: 'Email',
                    value: _email,
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: cycleDataService.phoneNumberNotifier,
                    builder: (context, phoneNumber, child) {
                      return _buildDataRow(
                        label: 'Nomor Telepon',
                        value: phoneNumber ?? '',
                        icon: Icons.edit_outlined,
                        onTap: () => _showEditPhoneNumberDialog(phoneNumber ?? '', (newPhoneNumber) {
                          cycleDataService.updatePhoneNumber(newPhoneNumber);
                        }),
                      );
                    },
                  ),
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: cycleDataService.birthDateNotifier,
                    builder: (context, birthDate, _) {
                      return _buildDataRow(
                          label: 'Tanggal Lahir',
                          value: birthDate != null ? DateFormat('dd - MM - yyyy').format(birthDate) : '',
                          icon: Icons.calendar_today_outlined,
                          onTap: () => _selectDate(context, birthDate ?? DateTime.now(), (newDate) {
                            cycleDataService.updateBirthDate(newDate);
                          }));
                    }
                  ),
                  ValueListenableBuilder<int?>(
                    valueListenable: cycleDataService.weightNotifier,
                    builder: (context, weight, _) {
                      return _buildDataRowWithTrailing(
                          label: 'Berat Badan',
                          trailingText: weight != null ? '$weight kg' : '',
                          onTap: () => _showWeightPicker(weight ?? 55, (newWeight) {
                            cycleDataService.updateWeight(newWeight);
                          }),
                          showDivider: false);
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Widgets ---

Widget _buildDataRow(
    {required String label,
    String? value,
    IconData? icon,
    VoidCallback? onTap,
    bool showDivider = true,
    TextInputType? keyboardType}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18, // Increased
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTextStyles.fontFamily)),
                    if (value != null && value.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(value,
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16, // Increased
                              fontFamily: AppTextStyles.fontFamily))
                    ],
                  ],
                ),
              ),
              if (icon != null)
                Icon(icon, color: AppColors.textSecondary, size: 22),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: AppColors.textSecondary.withOpacity(0.15), height: 1),
      ],
    ),
  );
}

Widget _buildDataRowWithTrailing(
    {required String label,
    required String trailingText,
    required VoidCallback onTap,
    bool showDivider = true}) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18, // Increased
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTextStyles.fontFamily))),
              if (trailingText.isNotEmpty)
                Row(
                  children: [
                    Text(trailingText,
                        style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.8),
                            fontSize: 16, // Increased
                            fontFamily: AppTextStyles.fontFamily,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        size: 16),
                  ],
                ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: AppColors.textSecondary.withOpacity(0.15), height: 1),
      ],
    ),
  );
}

class EditPhoneNumberDialog extends StatefulWidget {
  final String initialPhoneNumber;

  const EditPhoneNumberDialog({super.key, required this.initialPhoneNumber});

  @override
  _EditPhoneNumberDialogState createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
  String _countryCode = '+62'; // Default to Indonesia
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialPhoneNumber.isNotEmpty) {
      if (widget.initialPhoneNumber.startsWith('+')) {
        // Simple parsing logic
        final parts = widget.initialPhoneNumber.split(' ');
        if (parts.length > 1) {
          try {
            CountryCode.fromDialCode(parts[0]);
            _countryCode = parts[0];
            _phoneNumberController.text = parts.sublist(1).join(' ');
          } catch(e) {
             _phoneNumberController.text = widget.initialPhoneNumber;
          }
        } else {
           _phoneNumberController.text = widget.initialPhoneNumber;
        }
      } else {
        _phoneNumberController.text = widget.initialPhoneNumber;
      }
    }
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onCountryChange(CountryCode countryCode) {
    _countryCode = countryCode.dialCode ?? '+62';
  }

  void _savePhoneNumber() {
    final newPhoneNumber = '$_countryCode ${_phoneNumberController.text.trim()}';
    context.pop(newPhoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Ubah Nomor Telepon',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), // Increased
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    showDropDownButton: true,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                        fontSize: 18, // Increased
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: const TextStyle(
                          fontSize: 18, // Increased
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text('Batal', style: TextStyle(color: AppColors.grey, fontSize: 16))), // Increased
        TextButton(
          onPressed: _savePhoneNumber,
          child: const Text('Simpan',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)), // Increased
        ),
      ],
    );
  }
}
