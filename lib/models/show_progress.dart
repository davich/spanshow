class ShowProgress {
  final int season;
  final int episode;
  final int paragraphIndex;
  final double scrollOffset;

  const ShowProgress({
    required this.season,
    required this.episode,
    required this.paragraphIndex,
    required this.scrollOffset,
  });

  Map<String, dynamic> toJson() => {
        'season': season,
        'episode': episode,
        'paragraphIndex': paragraphIndex,
        'scrollOffset': scrollOffset,
      };

  factory ShowProgress.fromJson(Map<String, dynamic> json) => ShowProgress(
        season: json['season'] as int,
        episode: json['episode'] as int,
        paragraphIndex: json['paragraphIndex'] as int,
        scrollOffset: (json['scrollOffset'] as num).toDouble(),
      );
}
