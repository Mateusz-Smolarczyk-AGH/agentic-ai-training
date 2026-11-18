# MCP ⭐

[← Previous: Skills](13-skills.md) · [Agenda](00-agenda.md) · [Next: Subagents ⭐ →](15-subagents.md)

> **⭐ Extra, optional task** — for people who go faster. If there is no time,
> do it after the workshop.

## What it is

**MCP (Model Context Protocol)** is a standard for connecting **external tool servers**.
Instead of writing a tool yourself, you run an MCP server, and opencode sees its tools
just like the built-in ones. The server can run locally or remotely.

## How it works

1. You add the server to the `mcp` section in `.opencode/opencode.json`.
2. opencode starts the server (e.g. via `npx`).
3. The agent receives **new tools** from that server and can use them.

## How to add it (example: context7)

`context7` is a server that gives the agent up-to-date library documentation. It does not require a key.

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/apply-mcp.sh
```

The script adds this to `.opencode/opencode.json`:

```json
{
  "mcp": {
    "context7": {
      "type": "local",
      "enabled": true,
      "command": ["npx", "-y", "@upstash/context7-mcp"]
    }
  }
}
```

> 🛠️ **Do it yourself:** add the fragment above to `.opencode/opencode.json` (keep the JSON valid).
> If you want your own server, change `command` to the command that starts your MCP server.

## How to test it

> The config works immediately — **no restart**. In the same session:

1. Ask the `plan` agent:

```text
Use context7 to check the current way of building an application in FastAPI.
Give a short example and cite the documentation.
```

2. See that the agent **calls the MCP tool** (it does not guess).

## How to check it works

- in the session you can see a call to a tool coming from the `context7` server,
- the answer cites the documentation, not the model's "memory".

## A note

`context7` starts via `npx`, so Node.js must be available on the node. If it is not — the trainer
will suggest another MCP server.

## Done when…

- `.opencode/opencode.json` contains a working `mcp` section,
- the agent called an MCP tool and got a result,
- you can explain how MCP differs from a built-in tool.

---

[← Previous: Skills](13-skills.md) · [Agenda](00-agenda.md) · [Next: Subagents ⭐ →](15-subagents.md)
