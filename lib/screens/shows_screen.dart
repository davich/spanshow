import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/show.dart';
import 'seasons_screen.dart';

class ShowsScreen extends StatelessWidget {
  const ShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SpanShow'), centerTitle: true),
      body: FutureBuilder<List<Show>>(
        future: ContentRepository.loadShows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final shows = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
            itemCount: shows.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final show = shows[index];
              return ListTile(
                title: Text(show.title),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SeasonsScreen(show: show)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
