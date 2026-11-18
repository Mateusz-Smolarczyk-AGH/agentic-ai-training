# Agent plan — the answer chat could not give

[← Previous: Working with opencode](07-working-with-opencode.md) · [Agenda](00-agenda.md) · [Next: Code — analysis (plan) →](09-code-analysis.md)

The same questions as in [What chat cannot do](05-what-chat-cannot-do.md), but now the `plan` agent
has tools.

> 🚀 **Paste into opencode:** switch (Shift+Tab) to the `plan` agent and paste **the same**
> questions as in [What chat cannot do](05-what-chat-cannot-do.md).

Now `plan` **calls tools**. You will see the raw **tool call** (e.g. `bash` with a
command, `read` with a file, `webfetch` with an address) — approve it and watch the result.

## What to observe

- **Which tool** it chose (`bash`, `read`, `webfetch`) and **with which arguments**.

The agent **has eyes** — it searches and reads, it **enriches the context**.

## Done when…

- you saw the difference: chat guesses, plan checks,
- you recognise a raw tool call in the session,
- you can draw the loop model → tool → observation.

---

[← Previous: Working with opencode](07-working-with-opencode.md) · [Agenda](00-agenda.md) · [Next: Code — analysis (plan) →](09-code-analysis.md)
