import 'package:flutter/material.dart';
import '../models/show.dart';
import 'episode_screen.dart';

class EpisodesScreen extends StatelessWidget {
  final Show show;
  final int season;

  const EpisodesScreen({super.key, required this.show, required this.season});

  @override
  Widget build(BuildContext context) {
    final episodeCount = show.seasons[season]!;
    return Scaffold(
      appBar: AppBar(title: Text('${show.title} — T$season')),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        itemCount: episodeCount,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final episodeNumber = index + 1;
          return ListTile(
            leading: CircleAvatar(child: Text('$episodeNumber')),
            title: Text('Episodio $episodeNumber'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EpisodeScreen(
                  show: show,
                  season: season,
                  episodeNumber: episodeNumber,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
