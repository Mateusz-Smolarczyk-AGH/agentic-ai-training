# How an AI agent works — a note

Source material for the llm-wiki exercise (raw-only mode). All the facts below come from this
document; nothing outside it is a source.

## Agent loop

The agent runs a loop: **model → decision → tool → observation → model**. The model proposes
a tool call, the harness executes it, and the result returns to the model as an observation.

## Harness

The harness is the program that drives the loop. It keeps the session context, enforces
permissions and exposes a set of tools to the model.

## Tool

A tool is a function with a description and an argument schema. Typical tools are reading
files, running commands and searching the repository.

## Skill

A skill is an instruction loaded on demand, stored in a `SKILL.md` file. It loads only when it
is needed — which is why it does not take up context for no reason.

## MCP

MCP (Model Context Protocol) is a standard for connecting external tool servers. Thanks to it
the agent sees a server's tools just like built-in tools.

## Subagent

A subagent is a separate agent session to which a task is delegated. It has its own context and
its own permissions, which makes it possible to limit what it can do.
