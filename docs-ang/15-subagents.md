# Subagents ⭐ (extra task)

[← Previous: MCP ⭐](14-mcp.md) · [Agenda](00-agenda.md) · [Next: Your own knowledge base (LLM Wiki) →](16-llm-wiki.md)

> **⭐ Extra, optional task** — for people who go faster.

## What it is

A **subagent** is a **separate agent session** to which you delegate a task. It has its own context,
its own permissions and its own model.

## Why

- **a separate context** — a large task does not clutter your session,
- **limited permissions** — e.g. the subagent only reads,
- **a separate model** — cheap for simple tasks, strong for hard ones.

## How it works

In `.opencode/opencode.json`, in the `agent` section, you define an agent with `"mode": "subagent"`. The main agent
can **delegate** a task to it through a special tool.

## How to add it (example: a read-only researcher)

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/apply-subagent.sh
```

The script adds this to `.opencode/opencode.json`:

```json
{
  "agent": {
    "researcher": {
      "description": "Investigates how something works in the repository. Read-only.",
      "mode": "subagent",
      "prompt": "Trace real code paths. Cite file:line. Distinguish what you verified from what you inferred. Answer the question you were asked; do not summarise the whole repository.",
      "permission": {
        "edit": "deny",
        "bash": { "*": "deny", "grep *": "allow", "ls *": "allow" }
      }
    }
  }
}
```

> 🛠️ **Do it yourself:** add the fragment above to `.opencode/opencode.json`. Note the `edit: deny` —
> the subagent cannot change files.

## How to test it

> The config works immediately — **no restart**. In the same session:

1. Paste into the main agent:

```text
Investigate the structure of this repository and describe what each directory does.
Use the `researcher` subagent.
```

## How to check it works

The subagent will be visible as `Researcher Subagent — Investigate the structure of this repository`. If we click on it we can see its session. The main agent that did the delegating does not see that session — it sees only the result. This saves tokens and lets you have dedicated agents for various tasks (by choosing the models accordingly).
E.g. a separate agent as a code review on a different model.

## Done when…

- you have a subagent defined in `.opencode/opencode.json`,
- you delegated a task to it,
- you found `subagent_type` in the session export.

---

[← Previous: MCP ⭐](14-mcp.md) · [Agenda](00-agenda.md) · [Next: Your own knowledge base (LLM Wiki) →](16-llm-wiki.md)
