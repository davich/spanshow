class AdventureStory {
  final String id;
  final String title;
  final String startPageId;

  const AdventureStory({
    required this.id,
    required this.title,
    required this.startPageId,
  });

  factory AdventureStory.fromJson(Map<String, dynamic> json) => AdventureStory(
        id: json['id'] as String,
        title: json['title'] as String,
        startPageId: json['startPageId'] as String,
      );
}
