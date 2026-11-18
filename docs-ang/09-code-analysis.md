# Code — analysis (plan)

[← Previous: Agent plan — the answer chat could not give](08-agent-plan.md) · [Agenda](00-agenda.md) · [Next: Code — implementation (build) →](10-code-implementation.md)

## From enriching context to changing files

So far we have learned that the agent **has eyes** — it reads files, runs commands, reaches for the network.
Thanks to that it **enriches its context with knowledge**.

We work on a miniature program: `examples/mini-projekt/app.py` — a small
set of statistical and text tools. First we will look at it and ask for an analysis.

## See the program

> 🚀 **Type `!` and paste into opencode:**

```bash
python3 examples/mini-projekt/app.py average 1 2 3
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py mode 1 2 2 3
python3 examples/mini-projekt/app.py count "Hello hello, hello"
```

The program has commands: `average`, `median`, `mode`, `count`.

> **This code deliberately has two edge-case bugs** — nothing crashes, but some results are wrong.
> We will come back to this in part 3.

## Let the agent explain the code

> 🚀 **Paste into opencode:** the `plan` agent:

```text
Explain how examples/mini-projekt/app.py works: what each command does
and how each result is computed. At the end give me one command I can paste
in opencode to see the program run (prefixing it with !).
```

Then **run the command the agent showed in opencode** (first type `!`, then paste the command) and see the result — that is how the agent "has eyes": it reads the code and hands you a ready-made command.

### But it would be nice if the agent could add something itself....

> 🚀 **Paste into opencode:** the `plan` agent, paste:

```text
In the file examples/mini-projekt/app.py add a new command `p95 <numbers>`
that computes the 95th percentile of the given values.
```

You will see that `plan` **will not do it** — it is missing the `edit` tool. It does not guess and does not
make up a result: it will either answer plainly that it cannot, or present a plan with no implementation.

## Done when…

- the agent explained the code and gave a command to run in opencode (via `!`),
- you saw that `plan` **does not change** files (no `edit` tool).

---

[← Previous: Agent plan — the answer chat could not give](08-agent-plan.md) · [Agenda](00-agenda.md) · [Next: Code — implementation (build) →](10-code-implementation.md)
