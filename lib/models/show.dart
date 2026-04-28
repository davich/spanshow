class Show {
  final String id;
  final String title;
  final Map<int, int> seasons; // season number -> episode count

  const Show({required this.id, required this.title, required this.seasons});

  factory Show.fromJson(Map<String, dynamic> json) => Show(
        id: json['id'] as String,
        title: json['title'] as String,
        seasons: (json['seasons'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(int.parse(k), v as int),
        ),
      );
}
