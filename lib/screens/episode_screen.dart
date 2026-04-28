import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/show.dart';
import '../models/episode.dart';
import '../widgets/paragraph_tile.dart';

class EpisodeScreen extends StatelessWidget {
  final Show show;
  final int season;
  final int episodeNumber;

  const EpisodeScreen({
    super.key,
    required this.show,
    required this.season,
    required this.episodeNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T${season}E$episodeNumber  •  ${show.title}'),
      ),
      body: FutureBuilder<Episode>(
        future: ContentRepository.loadEpisode(show.id, season, episodeNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final episode = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Text(
                      episode.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Icon(Icons.touch_app_outlined, size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      'toca para traducir',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: episode.paragraphs.length,
                  itemBuilder: (context, index) =>
                      ParagraphTile(paragraph: episode.paragraphs[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
