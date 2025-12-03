import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:femora/config/constants.dart';
import 'package:femora/widgets/primary_button.dart';
import 'package:femora/widgets/size_config.dart';

class MoodPickerScreen extends StatefulWidget {
  final String initialMood;
  const MoodPickerScreen({Key? key, required this.initialMood}) : super(key: key);

  @override
  State<MoodPickerScreen> createState() => _MoodPickerScreenState();
}

class _MoodPickerScreenState extends State<MoodPickerScreen> {
  // Hanya dua mood: Baik dan Buruk
  final List<Map<String, dynamic>> _moods = [
    {'label': 'Baik', 'emoji': '😊', 'color': const Color.fromARGB(255, 255, 255, 255)}, // Kuning
    {'label': 'Buruk', 'emoji': '😞', 'color': const Color.fromARGB(255, 255, 255, 255)}, // Merah/Orange
  ];
  
  late String _selectedMood;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
    
    final initialIndex = _moods.indexWhere((m) => m['label'] == widget.initialMood);
    
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex != -1 ? initialIndex : 0,
    );
  }

  void _onSave() {
    context.pop(_selectedMood);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    
    return Scaffold(
      backgroundColor: AppColors.white, 
      body: Stack(
        children: [
          // Background Hint Pink (Lapisan Paling Bawah)
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryLight.withOpacity(0.5), 
                  AppColors.white, 
                ],
                stops: const [0.3, 0.8], 
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header (Close Button)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.close, size: 28, color: AppColors.textPrimary),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Picker Area
                SizedBox(
                  height: SizeConfig.getHeight(40),
                  child: CupertinoPicker.builder(
                    scrollController: _scrollController,
                    itemExtent: 100, 
                    childCount: _moods.length * 1000, 
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedMood = _moods[index % _moods.length]['label'];
                      });
                    },
                    itemBuilder: (context, index) {
                      final mood = _moods[index % _moods.length];
                      final isSelected = mood['label'] == _selectedMood;
                      
                      return Center(
                        child: AnimatedContainer(
                          duration: AppDurations.fast,
                          // FIX: Pink selection bar yang rata kiri-kanan
                          decoration: isSelected ? BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15), 
                            borderRadius: BorderRadius.circular(50),
                          ) : null,
                          
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Emoticon Circle FIX: Latar Belakang Warna Stabil
                                Transform.scale(
                                  scale: isSelected ? 1.0 : 0.8,
                                  child: Container(
                                    width: 80, 
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: mood['color'], // Warna stabil (Kuning/Merah)
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        mood['emoji'],
                                        style: const TextStyle(fontSize: 45),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 15),
                                
                                // Label
                                Text(
                                  mood['label'],
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: isSelected ? 24 : 18,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(flex: 2),
                
                // Save Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: PrimaryButton(
                    text: 'Simpan',
                    onPressed: _onSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}