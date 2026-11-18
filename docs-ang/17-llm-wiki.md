# Your own knowledge base (LLM Wiki)

[← Previous: Agentic research — using agents for research](16-agentic-research.md) · [Agenda](00-agenda.md)

## Step 1 — creating the wiki

> 🚀 **Paste into opencode:** the `build` agent, paste:

```text
Build the `llm-wiki` wiki in the ./wiki/llm-wiki/ directory from the data in /raw
Raw-only mode, language en.
```
The agent will then build the wiki. In our case, because 20 participants of the meeting are using this at once, we do not delegate the task of building the wiki to subagents. However, when working on your own it is worth letting the agent delegate tasks to many subagents in parallel - it speeds the work up.

> 🚀 **Type `!` and paste into opencode:**

```bash
ls -R wiki/llm-wiki
```

You will see `AGENTS.md`, `raw/` and `wiki/` (with `index.md` and `log.md`).

## Step 2 — what LLM Wiki is

**LLM Wiki** is a local knowledge base in the **OKF** (Open Knowledge Format) format: markdown pages
with YAML frontmatter, plus `index.md` and `log.md`. The agent curates it with the `llm-wiki` skill.

Every wiki has `AGENTS.md` (identity and rules), `raw/` (source documents) and `wiki/` (the OKF bundle).

It is a knowledge base built from the files in the /raw folder. These can be articles, documentation - anything. On that basis the agent builds the wiki - where each page is a single concept - and the concepts are linked to each other. 

### LLM Wiki vs RAG

| | RAG | LLM Wiki |
|---|---|---|
| When knowledge is created | on every query | once, when the wiki is built |
| What is in the base | text fragments in an index/vectors | curated concept pages |
| Search | similarity | by pages, a catalogue in `index.md` |
| The answer | assembled ad hoc from fragments | cites the wiki pages |
| Structure and provenance | none, "raw" text | first-class (`sources`, links) |
| Output format | vectors (unreadable to a human) | markdown: readable, diffable, versionable |
| Infrastructure | a vector database + pipeline | none, a directory is enough |

Both answer from your documents. The wiki adds **curation, structure and the ability to
trace a source**; RAG — fast matching of fragments.

## Step 3 — demo: without a wiki vs with a wiki

The wiki is built **live**, so we have the questions prepared in advance — but **general**, about the topic
of the research from the previous block. The answer should be **short (one sentence)**. We compare not
the content of the answer but **the path to the information**: what the agent did step by step (the `tool call` list),
what it cost and how quickly you can then check that answer.

> 🚀 **First switch the model:** `/models` → `plgrid/Qwen/Qwen3.6-27B` (small, but it uses tools
> efficiently). The same model stays for both runs.

### Questions (pick one)

General, about the research topic; the answer is always one sentence:

| Question | Answer |
|---|---|
| What is LLM Wiki (an agent-native wiki) and why build it? | one sentence |
| How does LLM Wiki differ from classic RAG? | one sentence |
| When does agentic retrieval beat long context? | one sentence |
| What does GraphRAG give you and what are its limitations? | one sentence |
| What does the life cycle of agent memory look like? | one sentence |
| How does the agent keep the wiki's quality up over time? | one sentence |

The wiki pages are built live — before asking, glance at `wiki/llm-wiki/wiki/index.md` to see whether
the topic is covered.

> 🚀 **Without a wiki — the `plan` agent (raw and the web, no bundle):**

```text
<your question> — answer using the files in wiki/llm-wiki/raw/ (you may also use the web).
Do NOT use wiki/llm-wiki/wiki/. At the end state what you took the answer from — a file or a URL
— or write: I did not find it. Answer briefly (one sentence).
```

> 🚀 **With a wiki — the `plan` agent (bundle only):**

```text
Using ONLY the pages in wiki/llm-wiki/wiki/, answer briefly (one sentence)
and at the end give the page you cited. <your question>
```

### What to look at — the path, not the answer

The same answer can come out in both modes. The difference is in **how the agent got to it**
and how much checking it costs:

- **without a wiki** — a long `tool call` list: `grep`/`glob`, attempts to read PDFs, `bash`
  with `pdftotext` (which is not there), custom scripts, `webfetch`;
- **with a wiki** — a few calls: `index.md` → `read` of one page → a quotation.

> 🚀 **See both paths side by side** — in a second terminal, next to the opencode session, paste:

```bash
bash scripts/wiki-compare.sh "<twoje pytanie>"
```

The script itself launches `opencode run` in headless mode, which is why we run it in a second terminal
and leave the opencode session next to it. It runs both modes with the same model and prints:

- a table: **time, number of calls, tokens, the citation**,
- the **`tool call` list** for each mode — what the agent did step by step.

> 🚀 **The quick variant:** in that same second terminal limit the time of the "without a wiki" mode, so that the wiki has time while raw is still searching:

```bash
TIMEOUT_RAW=60 bash scripts/wiki-compare.sh "<twoje pytanie>"
```

### Conclusion

The wiki changes neither the question nor the model — it changes **the path**: fewer calls, less guessing
and an answer that you **verify by opening one page**. That is why checking it later is faster and cheaper
— during an audit, in team work and when you come back to the topic a week later.

> 🎓 **The trainer walks through:** we look at the `tool call` list. Without a wiki that is often a dozen or so
> steps and dead ends (PDFs, the web); with a wiki — a few and a citation. With the web enabled the agent
> "without a wiki" can shorten the path by fetching the source online — that is part of the observation too.


## Back to the idea of research vs distillation

- **Research** (open) — the web, papers, documentation.
- **Distillation** (closed) — `raw/` only. A trusted, citable source.

## Done when…

- a wiki exists with `AGENTS.md`, `raw/` and `wiki/`,
- at least one page was created from your material,
- the answer comes from a wiki page and is cited,
- you saw the difference between the answer without a wiki and with a wiki,
- you saw the `tool call` list in both modes and the difference in the path to the answer (time, calls, tokens).

---

[← Previous: Agentic research — using agents for research](16-agentic-research.md) · [Agenda](00-agenda.md)
