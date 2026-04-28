class Paragraph {
  final String spanish;
  final String english;

  const Paragraph({required this.spanish, required this.english});

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
        spanish: json['es'] as String,
        english: json['en'] as String,
      );
}
