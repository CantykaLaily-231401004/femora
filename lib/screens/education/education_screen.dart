import 'package:femora/config/constants.dart';
import 'package:femora/models/education_material.dart';
import 'package:femora/services/education_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final EducationService _educationService = EducationService();
  final TextEditingController _searchController = TextEditingController();

  List<EducationMaterial> _allDailyMaterials = [];
  List<EducationMaterial> _filteredMaterials = [];
  late Future<void> _initMaterialsFuture;

  @override
  void initState() {
    super.initState();
    _initMaterialsFuture = _initializeMaterials();
    _searchController.addListener(_filterMaterials);
  }

  Future<void> _initializeMaterials() async {
    // PERUBAHAN: Mengubah komposisi menjadi 4 video dan 4 artikel (total 8)
    final materials = await _educationService.getDailyMaterials(totalCount: 8, videoCount: 4);
    if (mounted) {
      setState(() {
        _allDailyMaterials = materials;
        _filteredMaterials = materials;
      });
    }
  }

  void _filterMaterials() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMaterials = _allDailyMaterials.where((material) {
        return material.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initMaterialsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _allDailyMaterials.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error memuat data: ${snapshot.error}'));
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          itemCount: 1 + (_filteredMaterials.isEmpty ? 1 : _filteredMaterials.length),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Material(
                  elevation: 1.0,
                  shadowColor: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari artikel atau video...',
                      hintStyle: const TextStyle(color: AppColors.grey, fontSize: 16),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 24),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              );
            }

            if (_filteredMaterials.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Materi tidak ditemukan.'),
                ),
              );
            }

            final material = _filteredMaterials[index - 1];
            final isVideo = material.type == 'video';
            final IconData icon = isVideo ? Icons.play_circle_outline : Icons.article_outlined;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.1),
              child: InkWell(
                onTap: () => _launchURL(material.content),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          material.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(icon, color: AppColors.primary, size: 28),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
