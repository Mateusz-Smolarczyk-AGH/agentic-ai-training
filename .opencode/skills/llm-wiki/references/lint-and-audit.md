# Lint, the wiki↔raw audit, and the rule that keeps the list from growing back

Companion to `SKILL.md` ("Lint — conformance and health check"). Load when you verify a bundle by hand, or when a defect
must become a permanent check.

## Running the checklist by hand

In OpenCode there is no separate automated pass: the agent runs this checklist by hand after a
distillation pass. It covers page schema, `sources[]` integrity (a `resource` pointing at a file
that exists), provenance binding of the changed raw files, **coverage** of the pass, footnote ↔
`sources[].id`, broken links, index completeness, page size — plus the corpus-specific checks
below. Findings are HIGH/MED/LOW; fix a HIGH finding before calling the pass done, and fix every
class that keeps firing in the corpus while keeping its check.

The checklist needs no model, no network and no write access to the bundle. The authoritative
conformance standard is the OKF v0.2 spec at `references/okf-spec.md` §11, and the
corpus-specific checks also encode the wiki's own conventions (banned phrasings, counted-number
definitions, column naming) as declared in its `AGENTS.md`.

## The rule that makes this sustainable

**Every defect found by hand becomes a permanent check — in the same session it is found.** A
hand-found defect is not fixed until the check that would have caught it exists; otherwise the
same class returns with the next ingest, because no check would have caught it. When a check
fires, the fix goes into the corpus **and** the check stays.

That means: a new kind of finding is added to the wiki's lint checklist as a check, with a
**positive control** against a page known to be correct (a check that has never fired on known-good
input is not yet a check).

## The check list (what a hand lint looks for)

Generic checks first — they apply to any corpus:

1. **Schema violations (highest):** `.md` files missing frontmatter or a non-empty `type`.
2. **Reserved files:** `index.md` / `log.md` at any level follow the spec; never concepts.
3. **Provenance gaps:** pages with no `sources` or no `generated` — flag for trust.
4. **Source-id integrity:** `sources[].id` referenced by a footnote but absent from frontmatter
   (or vice versa), and any `url` not present in the corpus's provenance map.
5. **Footnote coverage:** each factual/currency claim carries a footnote keyed to a
   `sources[].id`, and that source file must contain the quoted text. Report statements with no
   footnote and footnotes pointing at a file that does not contain the quote (measured in one
   corpus: 175 of 391 statements had no footnote, 71 of 92 footnotes pointed at the wrong file).
6. **Coverage gaps:** raw files with no bundle page, and structural units of an ingested file
   that landed nowhere. A coverage record (if the wiki's `AGENTS.md` defines one) is what makes an omission visible.
7. **Absence claims without evidence:** every statement about what the corpus does *not* contain
   must be backed by a mechanical search over the whole `raw/` with the pattern and hit count
   recorded on the page or in `log.md`. Report every one without such a record.
8. **Derived pages that do not reproduce:** for each aggregating page (maps, counters, chains,
   summaries) recompute the numbers from `raw/` and compare; a number that does not reproduce, or
   a derived page with no script named at the top, is a finding.
9. **Table column assignment:** for tables copied from a PDF, re-verify the label→value mapping
   by coordinates (header `x` vs value `x`) or by reading order. A rotated column is a silent
   factual error and readers quote it.
10. **Index completeness:** every concept appears in some `index.md`; repealed/superseded
    instruments are not presented as live.
11. **Broken links** (informational — the format tolerates them) and **orphans** (no inbound
    links).
12. **Page size:** flag concepts over ~200 lines for splitting.
13. **Trust tiers:** list unverified and machine-confirmed pages needing human review.
14. **Stale:** pages where `now >= stale_after`.
15. **Source drift:** recompute a `sha256` in raw frontmatter when present; flag mismatches.
16. **Log rotation:** if `log.md` exceeds ~500 entries, rotate to `log-<YYYY>.md`.
17. **Terminology/tone conventions** of the wiki: banned phrasings, "counted numbers must say
    what they count", and any naming rule its `AGENTS.md` declares.

Corpus-specific checks (only where the corpus has that shape) — the regulated-corpus set:

18. **Supersession / currency (HIGH when the corpus is act-based):** pages presenting a document
    as current although the raw corpus explicitly repeals it (in whole or in part); repealed
    documents still listed as live in `index.md`; missing entries in the supersession map; and a
    list of every document whose currency could not be established from the raw files.
19. **Map replay, both directions:** each repeal statement → a row; each row → a clause in `raw/`.
20. **Footnote coverage of validity claims** specifically (subset of check 5, but this is where
    an unverifiable claim turns into a wrong statement of law).

Append a dated lint entry to the wiki's `log.md`: `## <YYYY-MM-DD> | lint | N issues found`.

## Two measured ways the verifier itself goes wrong

Any new check needs a positive control against a page known to be correct, because:

- a **naive table-column matcher** (`|Δy| ≤ 14` plus splitting merged fragments) produced 22
  false column shifts and had to be replaced by sequential reading-order comparison with
  header/`x` checks;
- a **strict clause pattern** (`traci\s+moc`) missed 19 files whose clause was split by PDF
  extraction (`traci mo c`), so the text is whitespace-normalised before matching.

A check that cries wolf gets ignored, and a check that misses gets trusted — both are worse than
no check.
