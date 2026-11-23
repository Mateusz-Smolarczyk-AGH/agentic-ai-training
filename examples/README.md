# examples/ — exercise materials

Supporting materials for the exercises. None of this is the subject of the training — it is
just data for the agent to work on.

| Item           | What for                                                      |
|----------------|---------------------------------------------------------------|
| `mini-projekt/`| a small CLI program; the `build` agent adds the `p95` command |
| `injection/`   | prompt injection demo (`NOTES.md` + `CRITICAL_DATA/`)         |
| `seed.md`      | a short source document for the llm-wiki exercise (distillation) |

Reset after the exercises:

```bash
bash scripts/reset-demo.sh
```

## The llm-wiki exercise

In [docs/16-llm-wiki.md](../docs/16-llm-wiki.md) we ask the agent to build a wiki in
**raw-only** mode from the sources in `wiki/llm-wiki/raw/`. The corpus is pre-seeded there;
`seed.md` is an optional minimal source document for a quick demo — drop it into
`wiki/llm-wiki/raw/` if you want one more input.
