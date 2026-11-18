# Agentic research — using agents for research

[← Previous: Subagents ⭐](15-subagents.md) · [Agenda](00-agenda.md) · [Next: Your own knowledge base (LLM Wiki) →](17-llm-wiki.md)

In this exercise we will look at agent-supported research. The agent's goal will be to find a few papers on a given topic that meet the criteria we have set and to save them locally in the `wiki/llm-wiki/raw/` directory. In this block we do it
**with a prompt only** — no skill and no extra tools. For real research it is worth using ready-made tools (such as paper-search). For the purposes of this exercise, however, they were dropped. Here we only download the files - we do not analyse them in full. That step will come in the next point of the training.


## Research based on the prompt alone

In this block research is **a prompt and nothing more** — no skill, no `paper-search` and other
external tools. The agent's **built-in tools** are enough:

- `webfetch` — a search page, the arXiv API, the content of a blog/doc,
- `bash` (`curl`) — downloading a PDF and queries to the arXiv API,
- `read` / `write` — saving the cleaned `.md` in `raw/`.

The prompt is the whole "program" of the research: it says how many materials to collect, where to save them and how to name them.

## The Research Scout loop

1. **STEP 0 — splitting the topic** into 3–5 subtopics that together cover it.
2. **Search** — arXiv, technical repositories, engineering blogs.
3. **Download** — sequential, **one source after another** (a single session, no delegation).
4. **Verification** — whether the file exists and makes sense (PDF > 50 KB).
5. **Report** — what was saved (name, size, URL) and what is missing.

## What the prompt looks like

The prompt (full text in the exercise below) carries the rules:

- sources mainly from **2026** (SOTA); older ones only as a cited foundation,
- **4–8 materials** in total (papers + key engineering posts),
- papers as the **original `.pdf`**, size **> 50 KB**,
- HTML content as a **cleaned `.md`**,
- filenames `slug-name`, **one file = one source**.

## Pitfalls

- **Marketing and superficial posts** — reject them; technical content matters, not a landing page.
- **"Empty"/broken PDFs** — hence the size check (> 50 KB); report a missing file outright.
- **Made-up links/DOIs** — the model can "add" a citation; verify every URL.
- **Mixing research with synthesis** — in this block we **only download**; summarising and wiki pages
  are a separate block.

## Exercise — live research

> 🚀 **Paste into opencode:** the `build` agent, paste:

```text
You are an autonomous research agent (Research Scout). Your only task is to
identify the best technical sources on the given topic and physically download them into
the `wiki/llm-wiki/raw/` directory.

Topic: LLM Wiki / agent-native wikis and knowledge bases for LLMs — SOTA 2026: capabilities, advantages and limitations, comparison with RAG (GraphRAG, agentic retrieval, long context, agent memory)

RESOURCE CRITERIA — 4-8 materials in total:
1. Papers / whitepapers: they MUST be saved as the original `.pdf` file.
2. Key engineering posts / documentation: downloaded and saved as a cleaned `.md`.

TIME CRITERIA:
- Papers mainly from 2026 (SOTA). At least 4 of the 4-8 materials must be from 2026.
- Older ones (2020-2024) only as a foundation cited by newer papers, marked as
  "classic/reference" — no more than 1-2.

STEP 0 — Splitting the topic:
- Break the topic into 3-5 subtopics that together cover it.
- Write out a plan (subtopics + one sentence on what you are looking for in each).
- Download the sources ONE AFTER ANOTHER, one by one (a single session, no delegation).

STEP 1 — Initialisation:
- Make sure the `wiki/llm-wiki/raw/` directory exists; if not, create it (`mkdir -p`).

STEP 2 — Search and selection:
- Search on arXiv, in technical repositories and on engineering blogs.
- Use `webfetch` on search pages and the arXiv API via `bash`, sorting by date:
  `curl -sk "https://export.arxiv.org/api/query?search_query=all:%22<fraza>%22&sortBy=submittedDate&sortOrder=descending&max_results=20"`,
  and take the newest from 2026 (confirm the year in the `<published>` field).
- Reject purely marketing materials and superficial posts.
- Pick the most groundbreaking items and assign each to a subtopic.

STEP 3 — Download:
- Papers (PDF): determine the direct link to the file (for arXiv replace `/abs/` with `/pdf/`
  and add `.pdf`), then: `curl -L -o wiki/llm-wiki/raw/<slug>.pdf "URL"`.
  Check that the file exists and is larger than 50 KB.
- Blogs / documentation (HTML): fetch the content (`webfetch`) and save it as cleaned Markdown
  in `wiki/llm-wiki/raw/<slug>.md`.

STEP 4 — Verification and report:
- List what you saved: for each file the name, size and source URL.
- If something could not be downloaded — say outright which source is missing and why.
- Do NOT summarise and do NOT build wiki pages — just download the files.

Rules: every file in `raw/` is one source; do not invent sources or links; filenames
in the `slug-name` format (lowercase letters, hyphens).
```

> 🎓 **The trainer walks through:** we watch how the agent splits the topic into subtopics, what it searches
> with (`webfetch`/`curl`), how it verifies file sizes and reports what is missing.

> 🛠️ **Do it yourself:** replace the topic with **your own**; you can also point to other sources.

> ⭐ **Scale:** in a bigger research task you split the subtopics between **parallel subagents**
> (the [Subagents ⭐](15-subagents.md) block); in the workshop we do it sequentially.

## Output → input to the next block

`wiki/llm-wiki/raw/` (PDF + `.md`) becomes the source for the **LLM Wiki** block
([Your own knowledge base (LLM Wiki)](17-llm-wiki.md)). Research collects the material, the wiki distils it.

## Done when…

- the agent showed the split into subtopics,
- there are 4–8 source files in `wiki/llm-wiki/raw/`,
- every file has a source URL, and anything missing is named outright.

---

[← Previous: Subagents ⭐](15-subagents.md) · [Agenda](00-agenda.md) · [Next: Your own knowledge base (LLM Wiki) →](17-llm-wiki.md)
