# Optional: automating wiki refresh

This is OPTIONAL and OUTSIDE the core skill. The core Ingest, Query and Lint
operations from SKILL.md work fully manually; none of this is required to build
or maintain a wiki.

## Scheduled refresh

To keep a wiki current without manual steps:

1. **A fetcher** — a cron or CI job that drops new files into
   `<wiki>/raw/`. It only copies raw source material; it never edits the
   bundle.
2. **An ingest invocation** — the same job then starts an agent session that
   runs the Ingest operation from SKILL.md, which picks up the new `raw/`
   files and updates `wiki/`.

Example cron layout: the fetch step runs first (downloads new files into
`raw/`), then the agent session runs Ingest for that wiki.

## Managing several wikis

If multiple wikis must be maintained, an optional registry file — e.g.
`$WIKI_HOME/wikis.yaml` mapping `name -> wiki_path` — keeps them discoverable
by name. When the registry is absent, fall back to listing `$WIKI_HOME`
directly.

## Not required

The core skill needs none of this. Automation is a convenience for keeping
wikis fresh and for running many of them; a single wiki updated by hand works
without any scheduler or registry.
