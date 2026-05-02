import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/episode.dart';
import '../models/show.dart';
import '../models/show_progress.dart';
import '../services/progress_service.dart';
import '../widgets/paragraph_tile.dart';

class EpisodeScreen extends StatefulWidget {
  final Show show;
  final int season;
  final int episodeNumber;
  final int initialParagraphIndex;
  final double initialScrollOffset;

  const EpisodeScreen({
    super.key,
    required this.show,
    required this.season,
    required this.episodeNumber,
    this.initialParagraphIndex = 0,
    this.initialScrollOffset = 0,
  });

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  late final ScrollController _scrollController;
  Episode? _episode;
  bool _loading = true;
  String? _error;
  List<GlobalKey> _paragraphKeys = [];
  int _currentParagraphIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentParagraphIndex = widget.initialParagraphIndex;
    _scrollController = ScrollController(
      initialScrollOffset: widget.initialScrollOffset,
    );
    _scrollController.addListener(_onScroll);
    _loadEpisode();
  }

  Future<void> _loadEpisode() async {
    try {
      final episode = await ContentRepository.loadEpisode(
        widget.show.id,
        widget.season,
        widget.episodeNumber,
      );
      if (!mounted) return;
      setState(() {
        _episode = episode;
        _loading = false;
        _paragraphKeys = List.generate(episode.paragraphs.length, (_) => GlobalKey());
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onScroll() {
    if (_paragraphKeys.isEmpty) return;
    // Find the last paragraph whose top edge is still above (or at) the top of the screen.
    // Items scrolled off-screen above have null contexts; items in the viewport are non-null.
    int newIndex = _currentParagraphIndex;
    for (int i = 0; i < _paragraphKeys.length; i++) {
      final ctx = _paragraphKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final dy = box.localToGlobal(Offset.zero).dy;
      if (dy <= 0) {
        newIndex = i;
      } else {
        break;
      }
    }
    _currentParagraphIndex = newIndex;
  }

  @override
  void dispose() {
    if (_episode != null && _scrollController.hasClients) {
      ProgressService.save(
        widget.show.id,
        ShowProgress(
          season: widget.season,
          episode: widget.episodeNumber,
          paragraphIndex: _currentParagraphIndex,
          scrollOffset: _scrollController.offset,
        ),
      );
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('T${widget.season}E${widget.episodeNumber}  •  ${widget.show.title}'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));

    final episode = _episode!;
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
              Icon(
                Icons.touch_app_outlined,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
            itemCount: episode.paragraphs.length,
            itemBuilder: (context, index) => ParagraphTile(
              key: _paragraphKeys[index],
              paragraph: episode.paragraphs[index],
            ),
          ),
        ),
      ],
    );
  }
}
