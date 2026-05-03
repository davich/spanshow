import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/show.dart';
import '../models/adventure_story.dart';
import '../models/show_progress.dart';
import '../services/progress_service.dart';
import 'episode_screen.dart';
import 'seasons_screen.dart';
import 'adventure_page_screen.dart';


class ShowsScreen extends StatefulWidget {
  const ShowsScreen({super.key});

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  List<Show> _shows = [];
  List<AdventureStory> _adventures = [];
  Map<String, ShowProgress?> _progressMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final results = await Future.wait([
      ContentRepository.loadShows(),
      ContentRepository.loadAdventureStories(),
    ]);
    if (!mounted) return;
    setState(() {
      _shows = results[0] as List<Show>;
      _adventures = results[1] as List<AdventureStory>;
      _loading = false;
    });
    _refreshProgress();
  }

  Future<void> _refreshProgress() async {
    final updated = <String, ShowProgress?>{};
    for (final show in _shows) {
      updated[show.id] = await ProgressService.load(show.id);
    }
    if (mounted) setState(() => _progressMap = updated);
  }

  Future<void> _openShow(BuildContext context, Show show) async {
    final progress = _progressMap[show.id];
    if (progress != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EpisodeScreen(
            show: show,
            season: progress.season,
            episodeNumber: progress.episode,
            initialParagraphIndex: progress.paragraphIndex,
            initialScrollOffset: progress.scrollOffset,
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SeasonsScreen(show: show)),
      );
    }
    _refreshProgress();
  }

  Future<void> _openAdventure(BuildContext context, AdventureStory story) async {
    final progress = await ProgressService.loadAdventureProgress(story.id);
    final hasRealProgress =
        progress != null && progress.pageId != story.startPageId;

    if (!context.mounted) return;

    String startPageId = story.startPageId;

    if (hasRealProgress) {
      final resume = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(story.title),
          content: const Text('¿Continuar desde donde lo dejaste?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Empezar de nuevo'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
      if (resume == null || !context.mounted) return;
      if (!resume) {
        await ProgressService.clearAdventureProgress(story.id);
      } else {
        startPageId = progress.pageId;
      }
    }

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdventurePageScreen(
          story: story,
          pageId: startPageId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SpanShow'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Series'),
              Tab(text: 'Aventuras'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildSeriesList(),
                  _buildAdventuresList(),
                ],
              ),
      ),
    );
  }

  Widget _buildSeriesList() {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      itemCount: _shows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final show = _shows[index];
        final progress = _progressMap[show.id];
        return ListTile(
          title: Text(show.title),
          subtitle: progress != null
              ? Text(
                  'T${progress.season}E${progress.episode} · ¶${progress.paragraphIndex + 1}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )
              : null,
          trailing: const Icon(Icons.chevron_right),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant),
          ),
          onTap: () => _openShow(context, show),
        );
      },
    );
  }

  Widget _buildAdventuresList() {
    if (_adventures.isEmpty) {
      return Center(
        child: Text(
          'No hay aventuras disponibles.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      itemCount: _adventures.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final story = _adventures[index];
        return ListTile(
          title: Text(story.title),
          trailing: const Icon(Icons.chevron_right),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant),
          ),
          onTap: () => _openAdventure(context, story),
        );
      },
    );
  }
}
