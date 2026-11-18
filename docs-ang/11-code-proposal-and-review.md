# Code — proposal and review ⭐

[← Previous: Code — implementation (build)](10-code-implementation.md) · [Agenda](00-agenda.md) · [Next: Security →](12-security.md)

> ⭐ **Extra task** — if there is time left.

## Part 2 — propose, choose, implement

The agent will propose on its own what can be added, **ask you to choose** and only then implement it.
That is the **question** tool — the agent shows options and you pick one.

> 🚀 **Paste into opencode:** the `build` agent, paste:

```text
Suggest 4 different new things that could be added to
examples/mini-projekt/app.py. Ask me a question with those four options
to choose from, wait for my choice and only then implement the one I picked.
Keep the style of the existing code.
```

You will see **four options to choose from** — pick one with the arrow keys. After the implementation, check that it works
(🚀 type `!` and paste the command into opencode).

## Part 3 — review: find and fix bugs

Here we will show that the agent can **review code and find bugs** that are not visible at
first glance.

**1. First check yourself.** Run the commands from the beginning again and note down which results seem
suspicious to you (`median 1 2 3 4`? `count "Hello hello, hello"` with three different words for the same
word?).

**2. Review — the agent reads and reports (it changes nothing).**

> 🚀 **Paste into opencode:** the `plan` agent, paste:

```text
Review examples/mini-projekt/app.py and report the bugs in the program.
Do the analysis by reading only this file.
Write commands that will trigger the bugs
```

Compare with what you noted down — what did the agent find more of, and what is missing?

**3. Fix — the agent changes the code.**

> 🚀 **Paste into opencode:** switch (**Shift+Tab**) to the `build` agent, paste:

```text
Fix the bugs found in the previous step, one by one.
With each fix, run its example from the terminal and show the result.
```

**4. Verify.** Run the same commands as at the beginning — the suspicious results should disappear:

> 🚀 **Type `!` and paste into opencode:**

```bash
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py count "Hello hello, hello"
python3 examples/mini-projekt/app.py mode 1 2 2 3
```

After the fix: `median` returns `2.5`, `count` gives one `hello: 3` (in the start version `Hello: 1`,
`hello,: 1`, `hello: 1` — three different tokens for one word), `mode` returns `2` (unchanged — that was not a bug).

> 🛠️ **Do it yourself:** for the review you can also use a read-only subagent (⭐
> [Subagents](15-subagents.md)) or ask for a review of **each function** separately and compare
> whether the reports agree.

## How to get back to the initial state

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/reset-demo.sh
```

> 🛠️ **Do it yourself:** `reset-demo.sh` is `git restore examples/`. You can also undo via
> `/undo` in opencode — together with the files.

## Done when…

- the agent asked you to choose (4 options) and implemented the chosen one,
- the **review** listed the edge-case bugs, and after the fix the commands give correct results.

---

[← Previous: Code — implementation (build)](10-code-implementation.md) · [Agenda](00-agenda.md) · [Next: Security →](12-security.md)
