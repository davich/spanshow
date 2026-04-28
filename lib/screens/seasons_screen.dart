import 'package:flutter/material.dart';
import '../models/show.dart';
import 'episodes_screen.dart';

class SeasonsScreen extends StatelessWidget {
  final Show show;

  const SeasonsScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    final seasonNumbers = show.seasons.keys.toList()..sort();
    return Scaffold(
      appBar: AppBar(title: Text(show.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: seasonNumbers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final season = seasonNumbers[index];
          final episodeCount = show.seasons[season]!;
          return ListTile(
            title: Text('Temporada $season'),
            subtitle: Text('$episodeCount episodios'),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EpisodesScreen(show: show, season: season),
              ),
            ),
          );
        },
      ),
    );
  }
}
