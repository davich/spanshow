import 'paragraph.dart';
import 'adventure_choice.dart';

class AdventurePage {
  final String id;
  final List<Paragraph> paragraphs;
  final List<AdventureChoice> choices;

  const AdventurePage({
    required this.id,
    required this.paragraphs,
    required this.choices,
  });

  bool get isEnding => choices.isEmpty;

  factory AdventurePage.fromJson(Map<String, dynamic> json) => AdventurePage(
        id: json['id'] as String,
        paragraphs: (json['paragraphs'] as List)
            .map((p) => Paragraph.fromJson(p as Map<String, dynamic>))
            .toList(),
        choices: ((json['choices'] as List?) ?? [])
            .map((c) => AdventureChoice.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}
