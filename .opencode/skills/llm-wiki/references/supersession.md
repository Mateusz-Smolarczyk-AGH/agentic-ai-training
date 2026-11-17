# Supersession: corpora where documents replace one another

Companion to `SKILL.md` ("Current state, not history"). **Load this only when the corpus is like
this** — the wiki's `AGENTS.md` says so if it is: acts, decrees, directives, policies, standards,
procedures, price lists, successive versions of the same document. For a corpus of unrelated
pages (product docs, scraped articles, notes) the short rule in `SKILL.md` is the whole rule.

The wiki describes what is **in force NOW**, not a chronological archive of every document ever
issued. When the corpus contains documents that amend, replace or repeal one another, the wiki
reflects the **current** rule — and the raw corpus is what tells you which rule that is.

## The one rule that matters: supersession must be EXPLICIT

- **A newer date is NOT enough.** A later document supersedes an earlier one only when it **says
  so**: it names the earlier document and states that it repeals / replaces / amends it.
  Polish: `uchyla`, `traci moc`, `zastępuje`, `zmienia … w części`, `wygaśnie`; English:
  `repeals`, `is superseded by`, `amends`, `revokes`, `replaced by`.
- **No explicit repeal ⇒ the older document STAYS IN FORCE.** Silence, a later issue date, a
  similar subject or differing content does not revoke it. Never deprecate a document because a
  newer one exists; deprecate it because a newer one *says* it repeals it.
- If a newer document **contradicts** an older one without repealing it, that is a *conflict*,
  not a supersession — record both positions with dates, numbers and quotes and flag it for
  review. Do not silently overwrite.
- The repeal must come **only from the raw files**. Never infer one from model knowledge of what
  "usually" applies to that kind of document. No raw file says it is repealed ⇒ it is in force,
  and the wiki says so.

## Partial repeal is the normal case, not the exception

Such documents are typically amended "w części": specific paragraphs, chapters or attachments are
repealed while the rest survives. Read the repealing clause precisely and apply it **unit by
unit**:

- repealed units → no longer the rule; drop them from the current-state wording;
- surviving units → still the rule; they stay, unchanged;
- the page must state the **boundary explicitly**: which points are in force, which were
  repealed, by which document, from which date.

Never treat "partially repealed" as "repealed" (do not wipe the page) and never as "still valid"
(do not ignore the repeal).

## A repeal is prospective and dated

The repealing clause usually names an entry-into-force date (`wchodzi w życie z dniem …`,
`z mocą od …`), often **later** than the repealing document's own date — a vacatio legis.
Between issue and that date the OLD text is still the rule. Record the **effective date**, not
only the publication date.

## The order of reading must not change the outcome

The wiki must come out the same whether you read the newest document first or the oldest, and
whether the older document was ingested months ago or in this pass:

- **Newest → oldest:** before writing an older document as current, check the corpus and the
  bundle for a later document that repeals it. If one exists, the older document's page is
  written as *repealed*, not as current.
- **Oldest → newest:** when a newly ingested document repeals something already ingested, do not
  merely add the new page — **go back and fix every page derived from the repealed document in
  the same pass**, so the bundle never presents a dead provision as current.
- **The repeal lives in the OTHER document.** It is a one-directional reference and easy to miss.
  For every document you ingest, search the **whole `raw/`** corpus for its number/date/title and
  for repeal keywords — not just the file in front of you:

```text
grep "12/2023"                              path=<wiki>/raw   # the identifier being ingested
grep "uchyla|traci moc|zastępuje|zmienia"   path=<wiki>/raw   # repeal clauses anywhere
```

Whenever a new document lands, ask first: **does it repeal something already in the bundle?**
That reconciliation is part of the same ingest, not a follow-up task.

## What to record on the page (so a reader can verify the current state)

1. The **governing document** — number/date, plus the raw source in `sources[]`.
2. A short body section stating the **validity state**, one of:
   - in force in full; or
   - repealed **in part** — which units, by which document, with the repealing clause quoted
     verbatim (in the raw source's own language) and its effective date; or
   - repealed in full / superseded by X — same details.
3. A link to the **replacing document's page** and to the supersession map (below).
4. The chain (A repealed by B, B amended by C) belongs in **ONE** place: a
   `references/supersession-map.md` (or the wiki's equivalent) listing per instrument what
   replaced/amended what, kept current and linked from the affected pages.

**Quote the repealing sentence verbatim**, with the article/§ it sits in. "Document X was
repealed" without the clause and the source is an unverifiable claim.

**Repealed documents stay in the bundle** as `status: deprecated` (links and history): the page
exists, is linked from its successor, and is never presented as the current rule.

**`index.md` reflects current state.** Repealed instruments are not listed as live entries:
remove them or annotate them in place (`(repealed — see <replacing page>)`). A reader skimming
the index must not be able to mistake a dead rule for a live one.

## The map and the counters are generated, not written

A supersession map, a "N of M" counter or a summary line is the **output of a committed script**
recomputed from `raw/` — see the wiki's `AGENTS.md` and rule 2 in the main skill. A hand-edited aggregate drifts towards whatever the writer last believed: in one measured
corpus the counters were off by 15–26% and 28 of 149 relations were missing, because the register
and the map were maintained by hand in two places.

Where the corpus has such registers, replay them **in both directions**: every repeal statement
in `raw/` → is there a row? every row → does `raw/` contain that clause? The register→map
direction is where relations get lost.

## Verifying it

The corpus-specific checks for this class (currency of pages, repealed documents still listed as
live, missing map entries, footnote coverage of validity claims, map replay both ways) are
described in `references/lint-and-audit.md`. Verify them by hand after every pass using the wiki's
lint checklist; if a whole class of them keeps firing, the fix is a corpus correction plus keeping
the check — never removing the check.
