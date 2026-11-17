# Provenance: the file → URL/date map

Companion to `SKILL.md`. Load when you need the map, or when the corpus binds provenance in an
unusual way.

## What provenance is here

Every page records, in `sources[]`, **which raw file** a claim came from (`resource`) and — when
the corpus knows it — the file's **canonical URL** and date (`url`, `last_modified`). Without
that, a reader cannot reach the original and the next writer cannot tell a verified claim from a
remembered one.

**There is no single mandated manifest.** Provenance is bound **where the data is created**, and
the convention is **per folder**. Three shapes occur in practice:

| Shape | Where the map lives | Typical producer |
|---|---|---|
| **per-file frontmatter** | each raw page carries `url`, `date`, often `fetched_at`/`fingerprint` in its own YAML frontmatter | a crawler/scraper writing markdown pages |
| **folder catalogue** | one sidecar next to the files: `metadata.jsonl`, `index.jsonl`, `items.jsonl`, `catalog.jsonl` — one record per file | a fetcher pulling documents (e.g. an object store / SharePoint sync) |
| **none** | the corpus binds no URL at all | hand-collected material |

**The wiki's `AGENTS.md` names the convention folder by folder — read it first.** If it is silent
about a folder you must touch, inspect one file/one record before assuming anything, and say
which convention you found. Never carry a convention from another wiki into this one.

## Reading a catalogue

Inspect the shape before trusting it — the field names are the producer's, not OKF's:

```bash
find <wiki>/raw -name '*.jsonl'          # or: glob "**/*.jsonl" under <wiki>/raw
```

```python
import json
rows = [json.loads(l) for l in open('<catalogue>', encoding='utf-8') if l.strip()]
print(len(rows), rows[0])                  # never assume the schema — look at one record
by_file = {}                               # {basename: record}
for r in rows:
    name = r.get('file_name') or r.get('filename') or r.get('path') or r.get('name')
    if name:
        by_file[str(name).split('/')[-1]] = r
```

Real field-name variance to expect: `file_name`/`filename`/`path`/`name` for the file,
`url`/`source_url`/`link` for the address, `last_modified`/`date`/`updated`/`fetched_at` for the
timestamp. **Most catalogues name files without a directory component** while the files sit in
subfolders — match by basename, then verify.

Report, both directions: catalogue rows whose file is missing on disk, and raw files with no
catalogue row.

## The rules

- **A URL or date is copied from the corpus only.** Never reconstruct one from a filename
  pattern, never take one from model knowledge, never "improve" a canonical form. A fabricated
  URL is worse than none.
- **A missing URL is recorded, not filled in.** Write it explicitly in the source index (e.g.
  "no URL bound for this file") so the gap is visible.
- **The catalogue is metadata, not a source.** No concept page for it, no `sources[]` entry
  pointing at it, no distillation of it into prose. Its change alone is not news.
- **`raw/` is immutable** — a catalogue that is wrong is reported to its producer; it is never
  edited by the agent.
- **`resource` and `url` are different things.** `resource` is the path to the raw file actually
  distilled; `url` is where that file came from. Keep both; never replace the path with the URL.
- **Footnotes key to `sources[].id`**, and the footnote's source must be the file that actually
  contains the quoted text — a footnote pointing at the wrong file is a defect, not a nitpick.

## Examples seen in practice

- **Regulated/document corpus, folder catalogue**: `raw/metadata.jsonl`, one JSON object per
  line, e.g. `{"url": "https://…", "file_name": "z202601.pdf", "last_modified": "2026-09-16T14:45:24+00:00"}`
  — the URL goes into every `sources[]` entry alongside the raw file name, and the mapped
  timestamp becomes `last_modified`. That wiki's `AGENTS.md` states the rule; the lint checks
  that no `url` appears in a page that is absent from the catalogue.
- **Crawled wiki pages, frontmatter only**: this one wiki has *no* catalogue at all — each raw
  page carries `url`, `title`, `date`, `fetched_at` and a content `fingerprint` in its own
  frontmatter, and its `AGENTS.md` states plainly that there is no raw manifest — the URL lives on
  the page. A page's `sources[]` takes `url`/`title`/`date` from that
  frontmatter. A change is recognised by a changed `fingerprint`, not by a new file.
- **Document fetcher, folder catalogue**: the fetcher writes a flat folder plus `index.jsonl`
  (`file_name`, `url`, `item_id`, `etag`, `last_modified`, `fetched_at`, `size`). Etag/last
  modified are the fetcher's business (they decide what to re-pull); for the wiki the useful
  part is again `url` + date per file.

When two folders cover the same entity (e.g. an external scraped page and an internal
document), **say which one wins** for each kind of fact — the wiki's `AGENTS.md` should state it;
if it does not, record both values with their sources and flag the question instead of picking
one silently.
