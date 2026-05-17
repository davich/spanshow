# SpanShow

A Flutter app for learning Spanish by reading TV show episode summaries. Each episode is told as a present-tense prose narrative in Spanish, with English translations revealed on tap.

## Content

Episode content lives in `assets/content/[show-id]/s[season]e[episode].json`. Shows are registered in `assets/shows.json`.

### Adding a new series with Claude Code

The `/generate-series` skill automates content generation for a full season. It searches the web for episode synopses, writes English narratives, translates them to learner-friendly Spanish, and creates all the JSON files.

**Usage:**

```
/generate-series [Show Name]
/generate-series [Show Name] [Season Number]
```

Examples:

```
/generate-series The Bear
/generate-series The Sopranos 2
```

The skill will:
1. Look up the episode list for the season online
2. For each episode, search for a detailed synopsis and fetch it
3. Write an English present-tense narrative (8–12 paragraphs, 600–800 words)
4. Translate it to simple present-tense Spanish
5. Save `assets/content/[show-id]/s[xx]e[yy].json`
6. Register the show in `assets/shows.json` if it isn't already

**Resuming:** If you interrupt mid-season, re-run the same command — episodes that already have files are skipped automatically.

**Tips:**
- For well-known shows, web search works well automatically
- For obscure shows, paste a synopsis URL into the prompt: `/generate-series [Show] — use this page for synopses: [url]`
- Check a few generated files before running a full season to make sure quality looks right

### JSON format

```json
{
  "title": "Episode Title",
  "paragraphs": [
    {
      "es": "Párrafo en español.",
      "en": "Paragraph in English."
    }
  ]
}
```

## Development

Built with Flutter. Run on iOS or Android:

```
flutter run
```
