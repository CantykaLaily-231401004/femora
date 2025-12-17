class EducationMaterial {
  final String id;
  final String title;
  final String content;
  final String type; // Field baru untuk tipe konten

  EducationMaterial({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
  });

  // Update factory method untuk membaca 'type' dari JSON
  factory EducationMaterial.fromJson(Map<String, dynamic> json) {
    return EducationMaterial(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      // Default ke 'article' jika field 'type' tidak ada di JSON
      type: json['type'] ?? 'article',
    );
  }
}
