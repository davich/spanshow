import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/show.dart';
import '../models/show_progress.dart';
import '../services/progress_service.dart';
import 'episode_screen.dart';
import 'seasons_screen.dart';

class ShowsScreen extends StatefulWidget {
  const ShowsScreen({super.key});

  @override
  State<ShowsScreen> createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  List<Show> _shows = [];
  Map<String, ShowProgress?> _progressMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  Future<void> _loadShows() async {
    final shows = await ContentRepository.loadShows();
    if (!mounted) return;
    setState(() {
      _shows = shows;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SpanShow'), centerTitle: true),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
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
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                        )
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color:
                            Theme.of(context).colorScheme.outlineVariant),
                  ),
                  onTap: () => _openShow(context, show),
                );
              },
            ),
    );
  }
}
