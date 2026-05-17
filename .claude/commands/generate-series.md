Generate episode content for a SpanShow TV series. Usage: /generate-series [Show Name] [Season Number]

## What this skill does

Creates JSON episode files for one season of a TV show, sourcing plot details from the web (not memory), writing English narratives first, then translating to Spanish.

## Arguments

`$ARGUMENTS` contains the show name and optionally a season number, e.g. "The Bear" or "The Bear 2".

Parse `$ARGUMENTS` to extract:
- **Show name** — the TV series title
- **Season number** — defaults to 1 if not specified

## Step 1: Check shows.json

Read `assets/shows.json`. Check if the show is already registered.

- If registered: note its `id`, `title`, and existing season data
- If not registered: derive the `id` by lowercasing the title and replacing spaces/special chars with hyphens (e.g. "The Bear" → "the-bear"). You will add it to shows.json in Step 4.

## Step 2: Look up the episode list

Use WebSearch to find the episode list for this season. Search for: `"[Show Name] season [N] episodes list"`

Find the total episode count and each episode's title. Confirm the episode count before proceeding — do not guess. If the search is ambiguous, fetch the show's Wikipedia page or IMDb season page for the authoritative list.

## Step 3: For each episode — generate content

Work through episodes in order. For each episode `SxxEyy`:

**3a. Check for existing file**

Check if `assets/content/[show-id]/s[xx]e[yy].json` already exists. If it does, skip to the next episode (this allows resuming a partially-complete season).

**3b. Search for the episode synopsis online**

Use WebSearch to find a detailed synopsis. Good search queries:
- `"[Show Name] [episode title] episode summary"`
- `"[Show Name] S[xx]E[yy] recap"`

Prioritize sources like Wikipedia episode articles, TV.com, IMDb, or fan wikis that have detailed plot summaries. Fetch the most promising result with WebFetch and read the synopsis carefully. Do not rely on memory for plot details — only use what you find on the page.

**3c. Write the English narrative**

From the synopsis, write a present-tense prose narrative of the episode. Requirements:
- **8 to 12 paragraphs**
- **600–800 words total**
- **Present tense throughout** — "Walter meets Jesse", not "Walter met Jesse"
- First paragraph sets the scene and introduces key characters for readers who may not know the show
- Capture the main plot beats, key character moments, humor, and emotional stakes
- Write in an engaging narrative style, not a dry plot summary
- Do not invent details not supported by the synopsis you found

**3d. Translate to Spanish**

Translate the English narrative paragraph by paragraph into Spanish. Requirements:
- **Simple present tense only** — avoid past tense (preterite/imperfect) throughout
- **Learner-appropriate vocabulary** — prefer common words, avoid rare idioms
- **Short, clear sentences** — if a sentence is complex, split it
- Avoid subjunctive where a simpler construction works
- The translation should be faithful but can simplify complex English phrasing for clarity
- Every English paragraph maps to exactly one Spanish paragraph (same paragraph count)

**3e. Write the JSON file**

Create `assets/content/[show-id]/s[xx]e[yy].json` with this exact structure:

```json
{
  "title": "[Episode Title in English]",
  "paragraphs": [
    {
      "es": "[Spanish paragraph]",
      "en": "[English paragraph]"
    }
  ]
}
```

The file path uses zero-padded numbers: season 1 episode 3 → `s01e03.json`.

After writing, confirm the file was created and print: `✓ s[xx]e[yy]: [Episode Title]`

## Step 4: Update shows.json

After all episodes are written, update `assets/shows.json`:

- If the show was already registered: update the season entry to reflect the actual episode count you just generated
- If the show was not registered: add a new entry in this format:

```json
{ "id": "show-id", "title": "Show Title", "seasons": { "[N]": [episode_count] } }
```

Preserve the existing JSON formatting style (one object per line, consistent spacing).

## Step 5: Report completion

Print a summary:
- Show name and season
- Total episodes generated (vs. skipped)
- Any episodes that failed or were skipped with reasons
