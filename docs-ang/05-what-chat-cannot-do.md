# What chat cannot do — no tools

[← Previous: Chat in practice — the model's knowledge](04-chat-in-practice.md) · [Agenda](00-agenda.md) · [Next: Theory — the agent and the harness →](06-agent-theory.md)

Now something the model **does not have in its knowledge**: local state, today's weather, the contents of a file.

> 🚀 **Paste into opencode:** start opencode, switch to the `chat` agent (Shift+Tab) and
> paste one of the questions:

```text
What version of opencode is installed here? Check with a command, do not guess.
```

```text
What is in the README.md file? Give the first line.
```

```text
What is the weather in Krakow today?
```

`chat` **cannot** check this — it guesses or refuses.

> Note: the `chat` agent has a clear order in its prompt: it has no tools, so it has to **say
> plainly** that it cannot check this, and not try. This is not a defect — this is exactly the
> difference we are showing: a conversation without tools cannot verify anything.

## Done when…

- you saw that without tools chat will not check anything local or current.

---

[← Previous: Chat in practice — the model's knowledge](04-chat-in-practice.md) · [Agenda](00-agenda.md) · [Next: Theory — the agent and the harness →](06-agent-theory.md)
