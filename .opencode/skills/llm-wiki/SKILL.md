---
name: llm-wiki
description: "Use when the user wants to create, populate, query, or maintain a local OKF (Open Knowledge Format) wiki / knowledge base — building a wiki from a folder of documents, ingesting new sources into markdown concept pages, answering questions from an existing wiki, or linting it. Covers raw-only vs flexible sourcing, provenance, supersession, and the multi-wiki layout under $WIKI_HOME."
---

# LLM Wiki over OKF

An **OKF wiki** is a directory of markdown **concept pages** with YAML frontmatter, plus an
`index.md` (what exists) and a `log.md` (what changed). It is a **local, agent-managed**
knowledge base: no pipeline, no registry service, no crawling infrastructure — the agent
curates and reads it directly.

This skill defines how to *work* a wiki. The **format** is OKF v0.2, bundled at
`references/okf-spec.md`. Read this skill for procedure, read the spec for field definitions.
The OKF spec is **not** copied into a wiki — it stays in this skill as the format authority —
while each wiki carries its own `AGENTS.md` for its identity and local rules.

Work with OpenCode's own tools: `read`, `write` and `edit` for files; `bash`, `glob` and `grep`
to inspect; `webfetch` only when flexible mode allows it; and `task` to delegate bulk ingest to
subagents.

---

## Two layers of truth — and which wins

| Layer | Holds | Where |
|---|---|---|
| **This skill** (`SKILL.md` + `references/`) | how to work a wiki, plus the OKF v0.2 **format** standard (`references/okf-spec.md`). Nothing about any particular corpus. | loaded by the agent |
| **`AGENTS.md`** (per wiki) | this wiki's **identity and rules**: what it is about, what lies in `raw/`, where the data comes from, how to analyse it, and local conventions. | `<wiki>/AGENTS.md` |

**On any conflict the per-wiki file wins** for corpus facts and local rules. Do not impose a
convention from this skill, and do not carry a convention from another wiki into this one.

---

## The RAW rule

In **raw-only** mode, work ONLY from files in the wiki's `raw/`:

- **No web, no model knowledge.** Every claim, number, name, date and cross-reference must be
  traceable to a raw file.
- If no raw source covers something, **say so plainly** rather than filling the gap from
  knowledge.
- **`raw/` is immutable** — never edit, rename, delete, or write extracted text back into it.

In **flexible** mode, web documents and model knowledge are allowed; provenance is still
recorded, but is not restricted to `raw/`.

---

## Ask before you create (never guess)

Before creating a wiki, ask for four things:

1. **Location** — the default `$WIKI_HOME` (default `~/wikis`, persistent across container
   rebuilds); the current project at `./wikis/<name>`; or a custom path the user names.
2. **Provenance mode** — `raw-only` or `flexible` (see *The RAW rule*).
3. **Language** of the wiki pages (e.g. `pl`, `en`). If unstated, infer it from the sources and
   confirm with the user.
4. **The wiki brief** — what the wiki is about, what to focus on, where the data comes from;
   this becomes the wiki's `AGENTS.md`. OR a path to an existing `AGENTS.md` to use verbatim.

Record name, location, provenance mode and language in the wiki's `AGENTS.md` and honour them
thereafter.

---

## Layout of a wiki

```
<WIKI_HOME>/<name>/
  AGENTS.md            # this wiki's identity + local rules (from assets/agents.md); not an OKF concept
  raw/                 # source documents (immutable; may be empty in flexible mode)
  wiki/                # the OKF bundle
    index.md           # concept catalogue
    log.md             # chronological record of actions
    *.md               # concept pages, grouped by domain in subdirectories
```

- If `$WIKI_HOME` is unset, use `~/wikis`.
- **Discovery:** a directory with `AGENTS.md` + `wiki/` is a wiki. List `$WIKI_HOME` to find
  managed wikis.

---

## Creating a wiki

After the four questions above:

1. Create the tree. **If `<name>` exists, stop and ask** rather than overwriting.
2. Write `<wiki>/AGENTS.md` from `assets/agents.md`, filled in from the brief (topic, language,
   provenance mode, location, scope/focus, data sources, provenance binding, analysis guidance,
   local rules), or the user's supplied file verbatim. **The OKF spec is NOT copied into the
   wiki; it stays in this skill.**
3. Seed `wiki/index.md` from `assets/index.md` and `wiki/log.md` from `assets/log.md`, filling in
   the date and an initialization entry.
4. Report the absolute path and suggest the first sources to ingest (list the folder with
   `bash`, `glob`, `grep`).

**Lifecycle rule:** the wiki's `AGENTS.md` is **drafted at creation** and **REVISED after the
first ingest** from what the corpus actually contains — only then is it accurate — and maintained
thereafter.

---

## Orientation before every session (do not skip)

For the wiki you are about to touch, in this order:

1. Read the wiki's `AGENTS.md` **FIRST** — its identity, corpus context and local rules.
2. Read `wiki/index.md` — what concepts exist.
3. Read the recent entries of `wiki/log.md` — what changed and what the last pass did.
4. List `raw/` (`glob`) and compare against the coverage noted in the wiki.
5. `grep` the bundle for the topic at hand, so you extend existing pages instead of duplicating
   them, and check inbound/outbound links.

This persisted context is what lets a later session work **without re-explaining the wiki in the
prompt**. Orientation prevents duplicate pages, missed cross-references, invented provenance and
schema violations.

---

## Operations

### Ingest — turn sources into concept pages

1. **Inventory.** List the sources (`raw/` or the paths the user gave). Classify new, changed,
   type and size.
2. **Read each source COMPLETELY, in fragments.** Large files (multi-page PDF, big `.docx`/`.xlsx`,
   long text) must be read unit by unit — article/chapter/section for PDFs, heading-styled blocks
   for `.docx`, sheet by sheet for `.xlsx` — distilling each fragment before the next. Reading a
   large document in one shot truncates it; that is how material is silently lost. When done, the
   structural units you covered **must equal** the units in the source — go back for any gap
   before calling it ingested. See `references/reading-sources.md`.
3. **Check what exists.** `grep`/`glob` the bundle for the entities the source touches.
4. **Write or update concept pages** under `wiki/`, per the wiki's `AGENTS.md`, grouped by domain.
   See *Writing concept pages*.
5. **Update navigation.** Refresh `index.md` (entries, count, "Last updated") and append a
   `## <YYYY-MM-DD>` entry to `log.md` (newest first) listing every file created or updated.
6. **Report** every file created/updated, and account for every changed raw file:
   distilled / **no material** / unreadable / skipped. **"No material" is a correct outcome** —
   a source that adds nothing is recorded as such, never padded into an article. Where the wiki's
   `AGENTS.md` defines a coverage record, account for every changed raw file in it.
7. **Revise the wiki's `AGENTS.md`** after the **first** ingest — fold in what the corpus actually
   contains (folders, naming, provenance binding) — and update it thereafter whenever folder or
   provenance conventions change.

**Batch ingest.** When several sources land together: read them all first, identify all entities
across them, check existing pages in one pass, write/update pages in one pass (cross-linking
concepts that span sources), then update `index.md` and `log.md` once.

### Query — answer from the wiki

1. Read the wiki's `AGENTS.md` and `wiki/index.md` to find relevant pages; `grep` the bundle.
2. Read the relevant pages.
3. Answer from what is **in the bundle**, citing the pages used (e.g. "Based on
   `wiki/concepts/foo.md` and `wiki/regulations/bar.md`").
4. In raw-only mode, if no raw source covers the answer, **say so** instead of filling the gap.
5. File substantial answers (comparisons, deep dives) back as a new concept page; skip trivial
   lookups. Log the query.

### Lint — conformance and health check

Scan the bundle (`bash`/`grep`/`glob`) and report grouped by severity:

1. **Schema (highest):** `.md` files missing frontmatter or a non-empty `type`.
2. **Reserved files:** `index.md`/`log.md` follow the spec and are never concepts.
3. **Broken links** (informational): links to missing targets.
4. **Orphans** (informational): pages with no inbound links.
5. **Provenance gaps:** pages with no `sources` or no `generated`.
6. **Trust tiers:** unverified and machine-confirmed pages needing human review.
7. **Stale:** pages where `now >= stale_after`.
8. **Contradictions:** pages sharing tags/domain but stating conflicting facts.
9. **Page size:** concepts over ~200 lines, flagged for splitting.
10. **Index completeness:** every concept appears in some `index.md`.
11. **Log rotation:** if `log.md` exceeds 500 entries, rotate to `log-<YYYY>.md`.

Append `## <YYYY-MM-DD> | lint | N issues found` to `wiki/log.md`.

### List wikis

List `$WIKI_HOME`; for each directory with an `AGENTS.md`, report its name, topic and language
from that file.

---

## Writing concept pages

Use this cheat-sheet; the authoritative definitions are in `references/okf-spec.md`.

```yaml
---
type: Concept                 # REQUIRED (the only always-required key). e.g. Concept, Reference, Guide, Metric, Comparison
title: Human-readable name
description: One-line summary
resource: <canonical URI>     # optional
tags: [keyword, ...]          # optional
status: draft                 # draft | stable | deprecated
sources:                      # provenance (encouraged; required in raw-only mode)
  - id: src-1                 # stable key used by body footnotes
    resource: ../../raw/<file>  # the file the claim came from
    title: Title of the source
generated: { by: opencode/<model>, at: <ISO now> }
---
```

- **`type` is required; everything else is optional.** Populate `sources`, `generated` and
  `status` for agent-maintained trust.
- **Per-claim attribution:** markdown footnotes whose label is the source `id` (`[^src-1]`),
  **never positional indices** like `sources[0]` — they misattribute as soon as the list is
  reordered.
- **Cross-link** to at least two other pages using bundle-relative paths (`/concepts/foo.md`),
  and check that existing pages link back.
- **Structure suits the content:** headings that reflect the material (`# Definition`, `# Scope`,
  `# Examples`, `# Timeline`), favouring lists and tables over prose.
- **Language:** prose and headings in the wiki's `language`; keep **verbatim quotes in the source's
  own language** — never translate quoted authoritative text.
- **Status:** default new machine-written pages to `status: draft` until reviewed.
- Keep each page readable; split beyond ~200 lines and cross-link the pieces.

---

## Current state, not history + conflict/update policy

A wiki describes what holds **now**, not a chronological archive. When a source says something was
replaced, amended or withdrawn, the page shows the current state and the superseded material is
kept (as `status: deprecated`) rather than presented as live.

**A newer date is not a supersession.** Older material stops applying only when a source **says
so** — and that statement may live in a *different* file, so a change in one document can
invalidate a page derived from another.

Three distinct situations — do not collapse them:

1. **Explicit supersession** — the newer source names the older and says it replaces, amends or
   withdraws it. Show the current state; set the superseded content to `status: deprecated`; link
   the successor to it and record the replacing clause verbatim with its source. See
   `references/supersession.md`.
2. **Silent contradiction** — the newer source contradicts the older but does not replace it. This
   is **not** a supersession and the newer date proves nothing. Do **not** silently overwrite:
   record **both** positions with their dates and sources, keep the dispute visible, and flag it
   for human review.
3. **Same page, newer content** — an ordinary refresh: update to the current state and keep history
   in `sources` and `log.md`.

Anything whose currency you could not establish from the raw files goes on the same review list —
say so plainly instead of guessing.

**Archiving / deprecating** is expressed through `status`, not by deleting the file:

1. Set `status: deprecated` in frontmatter (kept for links and history).
2. Remove the entry from `index.md` (or mark it "(deprecated)" in place).
3. Update pages that linked to it.
4. Log the deprecation.

Delete a file outright only if no inbound links remain and it has no historical value.

---

## Three honesty rules

1. **No claim about absence without a recorded search.** "The corpus does not contain…", "not
   documented", "no such clause" are facts about the *whole* `raw/` and require a mechanical pass
   with the pattern and hit count written down (on a page or in `log.md`). Unverified absence
   claims are the most productive source of false statements in a machine-written corpus.
2. **Never hand-write an aggregating page or counter.** Maps, chains, "N of M" counts and summary
   lines are output of a repeatable script recomputed from `raw/` (kept in the wiki, e.g. under
   `wiki/references/`); a hand-edited aggregate drifts towards whatever the writer last believed.
3. **Never re-derive a table.** Copy column order and labels from the source and verify the
   label→value mapping before writing; if the mapping is uncertain, quote the raw instead of
   tabulating it. A rotated or shifted column is a silent factual error.

---

## Pitfalls

- **Never modify `raw/`** — immutable; corrections go in the bundle's concept pages.
- **Ask where and how before creating a wiki** — location and raw-only vs flexible. Never assume.
- **Never skip fragment-reading for large files** — read unit by unit and verify full coverage
  before declaring a source ingested.
- **Always orient first** — `AGENTS.md` + index + recent log + list `raw/`.
- **Always update `index.md` and `log.md`** — the navigational backbone.
- **Never invent provenance** — no URL from a filename pattern, no date from memory, no `sources[]`
  entry without a raw file behind it.
- **Never report an unreadable file as ingested** (scans without a text layer, legacy
  `.doc`/`.xls`/`.ppt`) — flag it and ask for OCR or a converted copy.
- **Don't create pages for passing mentions** (2+ source mentions, or central to one source).
- **Don't create pages without cross-references** — every page links to 2+ others.
- **Footnotes key to `sources[].id`, never positional indices.**
- **Respect the wiki's `language`** — prose in it, verbatim quotes in the source's own language.
- **Never silently overwrite a contradiction** — record both positions with sources and dates.
- **In raw-only mode, do not fetch the web or use model knowledge** — if a raw source does not
  cover it, say so.
- **Ask before mass-updating 10+ existing pages.**

---

## References

Load on demand — each file exists so this one can stay short:

| File | Load when |
|---|---|
| `references/okf-spec.md` | you need the normative OKF v0.2 field definitions and reserved-file rules |
| `references/reading-sources.md` | you are about to read a PDF/`.docx`/`.xlsx`, a long document you must slice, or a format that may be unreadable |
| `references/provenance.md` | you need the file→URL/date map, or the corpus binds provenance in an unusual way |
| `references/supersession.md` | the corpus contains documents that replace or amend one another |
| `references/lint-and-audit.md` | you verify a bundle by hand, or a defect must become a permanent check |
| `references/scaling-and-bulk.md` | dozens of sources, batch ingest, or delegation to subagents |
| `references/automation.md` | an ingest or lint pass runs unattended, or you wire up scheduled/repeatable runs |

The per-wiki `AGENTS.md` template lives at `assets/agents.md`.
