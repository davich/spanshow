class AdventureProgress {
  final String pageId;

  const AdventureProgress({required this.pageId});

  Map<String, dynamic> toJson() => {'pageId': pageId};

  factory AdventureProgress.fromJson(Map<String, dynamic> json) =>
      AdventureProgress(pageId: json['pageId'] as String);
}
