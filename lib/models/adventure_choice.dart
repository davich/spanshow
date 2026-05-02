import 'paragraph.dart';

class AdventureChoice {
  final Paragraph text;
  final String targetPageId;

  const AdventureChoice({required this.text, required this.targetPageId});

  factory AdventureChoice.fromJson(Map<String, dynamic> json) => AdventureChoice(
        text: Paragraph(
          spanish: json['es'] as String,
          english: json['en'] as String,
        ),
        targetPageId: json['target'] as String,
      );
}
