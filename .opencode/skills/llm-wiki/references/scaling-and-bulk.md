# Scaling: batch ingest, dozens of sources, delegation

Companion to `SKILL.md` ("Batch ingest"). **This is interactive guidance; there is no
separate automated pass.**

## Batch ingest (several sources land together)

Common when a fetcher or a cron drops a batch into `raw/`. Batch the work instead of processing
source by source:

1. **Read all new sources first** (each fully, in fragments if large).
2. **Identify all entities and concepts** across all of them before writing anything.
3. **Check existing pages in ONE search pass** for all of them (not N passes) — avoids
   duplicates and catches concepts shared across sources.
4. **Create/update pages in one pass**, so cross-links between concepts from different sources
   can be created.
5. **Update `index.md` once** at the end, covering all the changes.
6. **Write a single `log.md` entry** for the whole batch, listing every file created/updated.

## Dozens of sources: delegate by theme

When a wiki's `raw/` holds many unrelated documents (a company/documentation wiki with 50+ files),
one agent cannot read them all without exhausting context. Split by **theme** and delegate with
`task` — one subagent per theme (`@editor`/`@editor-cheap` to write pages, `@researcher` for
read-only tracing):

1. **Extract every source to text yourself first** (`/tmp/<wiki>_txt/<raw-filename>.txt`) and
   record per file: format, page/line count, alphanumeric-char count, `sha256`, and the `url`
   from the corpus's provenance map when one exists. Files under ~300 alphanumeric chars are
   scans without a text layer — list them as unreadable **up front** instead of letting children
   rediscover it.
2. **Write two shared files the children read before acting**:
   - a *conventions* file — the frontmatter template, the footnote-per-`sources[].id` rule, the
     exact raw provenance path, the **file → URL map** (so children put the real URL in
     `sources[].url` instead of inventing one), the language rules, and a "never guess scanned
     files" warning. Take the conventions from the wiki's `AGENTS.md`, not from memory.
   - a *page inventory* — every planned page path, so children cross-link to real targets instead
     of inventing them.
3. **Assign each child a disjoint set of page paths** and the exact source-text filenames to
   read. One child per theme; never two children writing the same page.
4. **Keep the structural pages yourself** (index, log, coverage ledger/source index, the wiki's
   central organizing document) — children must not write `index.md`/`log.md`.
5. **After the children report:** regenerate `index.md` from frontmatter programmatically, run the
   lint, and re-verify their flagged conflicts yourself. **A child's summary is a self-report** —
   spot-check specific numbers against the extracted text before trusting them.

## Index scaling

When an `index.md` section exceeds ~50 entries, split it into sub-sections by first letter or
sub-domain; when the bundle-root index exceeds ~200 entries, add a topic map grouping pages by
theme. Most bundles are small today; this guards against an unmanageable index as they grow.
