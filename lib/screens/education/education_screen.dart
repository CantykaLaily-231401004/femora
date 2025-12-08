import 'package:femora/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final List<Map<String, String>> _educationContent = [
    {
      'title': 'Mendobrak Mitos Seputar Menstruasi',
      'url': 'https://www.unicef.org/indonesia/id/stories/mendobrak-mitos-seputar-menstruasi',
      'type': 'article'
    },
    {
      'title': 'Menjaga Kesehatan dan Kebersihan Saat Menstruasi',
      'url': 'https://yankes.kemkes.go.id/view_artikel/1530/menjaga-kesehatan-dan-kebersihan-saat-menstruasi',
      'type': 'article'
    },
    {
      'title': 'Edukasi Kesehatan Reproduksi Remaja oleh Dokter',
      'url': 'https://www.youtube.com/watch?v=f44s92a4JkE',
      'type': 'video'
    },
  ];

  List<Map<String, String>> _filteredContent = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredContent = _educationContent;
    _searchController.addListener(() {
      _filterContent();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContent() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContent = _educationContent.where((content) {
        return content['title']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Material(
            elevation: 1.0,
            shadowColor: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari...',
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
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filteredContent.length,
              itemBuilder: (context, index) {
                final content = _filteredContent[index];
                final isVideo = content['type'] == 'video';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 1,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: InkWell(
                    onTap: () => _launchURL(content['url']!),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              content['title']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            isVideo ? Icons.play_circle_outline : Icons.article_outlined,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 100), // Space for the nav bar
      ],
    );
  }
}
