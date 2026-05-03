import 'package:flutter/material.dart';
import '../data/content_repository.dart';
import '../models/adventure_page.dart';
import '../models/adventure_progress.dart';
import '../models/adventure_story.dart';
import '../services/progress_service.dart';
import '../widgets/paragraph_tile.dart';
import '../widgets/choice_tile.dart';

class AdventurePageScreen extends StatefulWidget {
  final AdventureStory story;
  final String pageId;

  const AdventurePageScreen({
    super.key,
    required this.story,
    required this.pageId,
  });

  @override
  State<AdventurePageScreen> createState() => _AdventurePageScreenState();
}

class _AdventurePageScreenState extends State<AdventurePageScreen> {
  AdventurePage? _page;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    try {
      final page = await ContentRepository.loadAdventurePage(
        widget.story.id,
        widget.pageId,
      );
      if (!mounted) return;
      setState(() {
        _page = page;
        _loading = false;
      });
      await ProgressService.saveAdventureProgress(
        widget.story.id,
        AdventureProgress(pageId: widget.pageId),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _navigateTo(String pageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdventurePageScreen(
          story: widget.story,
          pageId: pageId,
        ),
      ),
    );
  }

  Future<void> _confirmRestart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reiniciar historia'),
        content: const Text('¿Empezar desde el principio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ProgressService.clearAdventureProgress(widget.story.id);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AdventurePageScreen(
          story: widget.story,
          pageId: widget.story.startPageId,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  Future<void> _finishAndRestart() async {
    await ProgressService.clearAdventureProgress(widget.story.id);
    if (!mounted) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reiniciar',
            onPressed: _confirmRestart,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));

    final page = _page!;
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'toca para traducir',
                style: texts.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            children: [
              for (final paragraph in page.paragraphs)
                ParagraphTile(paragraph: paragraph),
              if (page.isEnding) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Fin',
                    style: texts.titleLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text('Empezar de nuevo'),
                    onPressed: _finishAndRestart,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  '¿Qué haces?',
                  style: texts.titleSmall?.copyWith(color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                for (final choice in page.choices)
                  ChoiceTile(
                    choice: choice,
                    onNavigate: () => _navigateTo(choice.targetPageId),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
