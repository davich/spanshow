import 'paragraph.dart';

class Episode {
  final String title;
  final List<Paragraph> paragraphs;

  const Episode({required this.title, required this.paragraphs});

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        title: json['title'] as String,
        paragraphs: (json['paragraphs'] as List)
            .map((p) => Paragraph.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
}
