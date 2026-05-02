import 'package:flutter/material.dart';
import '../models/adventure_choice.dart';

class ChoiceTile extends StatefulWidget {
  final AdventureChoice choice;
  final VoidCallback onNavigate;

  const ChoiceTile({super.key, required this.choice, required this.onNavigate});

  @override
  State<ChoiceTile> createState() => _ChoiceTileState();
}

class _ChoiceTileState extends State<ChoiceTile> {
  bool _showEnglish = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => setState(() => _showEnglish = !_showEnglish),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: colors.primaryContainer.withAlpha(40),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.primary.withAlpha(80)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.choice.text.spanish, style: texts.bodyLarge),
                    if (_showEnglish) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2, right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'EN',
                              style: texts.labelSmall?.copyWith(
                                color: colors.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.choice.text.english,
                              style: texts.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              color: colors.primary,
              onPressed: widget.onNavigate,
            ),
          ],
        ),
      ),
    );
  }
}
