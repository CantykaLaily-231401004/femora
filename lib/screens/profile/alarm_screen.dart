import 'package:femora/widgets/custom_back_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:femora/config/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  // State variables
  bool _isDailyTrackingEnabled = true; // Default AKTIF
  double _volumeLevel = 0.5;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0); // Default 8:00 PM
  String _selectedRingtone = 'Ringan';

  // Audio Player untuk preview suara
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Map untuk suara dering dan file asetnya
  final Map<String, String> _ringtones = {
    'Ringan': 'sounds/ring_light.mp3',
    'Normal': 'sounds/ring_normal.mp3',
    'Keras': 'sounds/ring_loud.mp3',
    'Senyap': '', // Tidak ada suara untuk senyap
  };

  @override
  void initState() {
    super.initState();
    // Set initial volume for the player
    _audioPlayer.setVolume(_volumeLevel);
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Melepaskan resource audio player
    super.dispose();
  }

  // Fungsi untuk memainkan preview suara
  Future<void> _playPreview(String assetPath) async {
    if (assetPath.isNotEmpty) {
      try {
        await _audioPlayer.stop(); // Hentikan suara sebelumnya
        await _audioPlayer.play(AssetSource(assetPath));
      } catch (e) {
        // Log the error to the console for debugging
        print('Error playing audio preview: $e');
      }
    }
  }

  // Menampilkan pemilih waktu gulir di tengah (AlertDialog)
  void _showTimePickerDialog() {
    int tempHour = _selectedTime.hour;
    int tempMinute = _selectedTime.minute;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const Center(child: Text('Pilih Waktu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: AppTextStyles.fontFamily))),
          content: SizedBox(
            height: 150,
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: tempHour),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) => tempHour = index,
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(capStartEdge: false, capEndEdge: false),
                    children: List<Widget>.generate(24, (int index) {
                      return Center(child: Text(index.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 22, color: AppColors.primary, fontFamily: AppTextStyles.fontFamily)));
                    }),
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: AppTextStyles.fontFamily)),
                SizedBox(
                  width: 80,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: tempMinute),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) => tempMinute = index,
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(capStartEdge: false, capEndEdge: false),
                    children: List<Widget>.generate(60, (int index) {
                      return Center(child: Text(index.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 22, color: AppColors.primary, fontFamily: AppTextStyles.fontFamily)));
                    }),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: AppColors.grey, fontSize: 16, fontFamily: AppTextStyles.fontFamily)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedTime = TimeOfDay(hour: tempHour, minute: tempMinute);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Simpan', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppTextStyles.fontFamily)),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan pemilih suara dering dengan preview
  void _selectRingtone() {
    String tempRingtone = _selectedRingtone;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Center(child: Text('Pilih Suara Dering', style: TextStyle(fontFamily: AppTextStyles.fontFamily, fontWeight: FontWeight.bold, fontSize: 18))),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: _ringtones.keys.map((ringtone) {
                  return RadioListTile<String>(
                    title: Text(ringtone, style: const TextStyle(fontSize: 16, fontFamily: AppTextStyles.fontFamily)),
                    value: ringtone,
                    groupValue: tempRingtone,
                    onChanged: (String? value) {
                      if (value != null) {
                        _playPreview(_ringtones[value]!);
                        setDialogState(() {
                          tempRingtone = value;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  // Stop the preview when canceling
                  _audioPlayer.stop();
                  Navigator.of(context).pop();
                },
                child: const Text('Batal', style: TextStyle(color: AppColors.grey, fontSize: 16, fontFamily: AppTextStyles.fontFamily)),
              ),
              TextButton(
                onPressed: () {
                  // Stop the preview when saving
                  _audioPlayer.stop();
                  setState(() {
                    _selectedRingtone = tempRingtone;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Simpan', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppTextStyles.fontFamily)),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = _isDailyTrackingEnabled;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  CustomBackButton(onPressed: () => Navigator.of(context).pop()),
                  const Expanded(
                    child: Center(
                      child: Text('Alarm Pengingat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to balance the title
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                   _buildToggleItem(
                    title: 'Pengingat Pelacakan Harian',
                    value: _isDailyTrackingEnabled,
                    onChanged: (bool value) => setState(() => _isDailyTrackingEnabled = value),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _buildNavigationItem(
                    title: 'Jadwal Pengingat',
                    trailingText: _selectedTime.format(context),
                    onTap: isEnabled ? _showTimePickerDialog : null,
                    enabled: isEnabled,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  _buildNavigationItem(
                    title: 'Suara Dering',
                    trailingText: _selectedRingtone,
                    onTap: isEnabled ? _selectRingtone : null,
                    enabled: isEnabled,
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 32),
                  _buildVolumeSlider(enabled: isEnabled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildNavigationItem({required String title, required String trailingText, VoidCallback? onTap, required bool enabled}) {
    final Color textColor = enabled ? AppColors.textPrimary : Colors.grey;
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailingText, style: TextStyle(color: enabled ? Colors.grey : Colors.grey.shade300, fontSize: 16)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: enabled ? Colors.grey : Colors.grey.shade300),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildVolumeSlider({required bool enabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Icon(Icons.volume_mute, color: enabled ? Colors.grey : Colors.grey.shade300),
          Expanded(
            child: Slider(
              value: _volumeLevel,
              onChanged: enabled
                  ? (double value) {
                      setState(() {
                        _volumeLevel = value;
                      });
                      // Directly update player volume
                      _audioPlayer.setVolume(value);
                    }
                  : null,
              activeColor: enabled ? AppColors.primary : Colors.grey,
              inactiveColor: enabled ? AppColors.primary.withAlpha(77) : Colors.grey.shade300,
            ),
          ),
          Icon(Icons.volume_up, color: enabled ? Colors.grey : Colors.grey.shade300),
        ],
      ),
    );
  }
}
