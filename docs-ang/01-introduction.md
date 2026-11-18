# Introduction

[Agenda](00-agenda.md) · [Next: Setup — connecting and starting →](02-setup.md)

## What we do

This is the workshop **"First steps with AI agents: research, working with code and your own wiki"**.
You will see the difference between an ordinary chat and an agent that uses tools on its own. You will work
on real code, learn the security rules of working with an agent and in the end build
your own knowledge base (LLM Wiki). Everything happens in opencode, on the PLGrid models.

## How we run it

Every step follows the pattern **"first I demo — then you do it yourself"**. Prompts for the agent
we marked **🚀 Paste into opencode**, and shell commands — **🚀 Type `!` and paste into opencode**; next to it
there is a **🛠️ Do it yourself (how it works)** explanation. Tasks **⭐** are optional, for the faster ones.

**We run commands in the opencode session with `!`**: first you type `!`, and only then
you paste the bare command — without `!`, because pasting `!command` will not work — and press Enter;
the result lands in the conversation. **On the cluster this is the main way** — `/terminal` is often
flaky. Changes to the configuration (permissions, skills, MCP, subagents) take effect **immediately, with no
restart**. The **🚀 Paste into the terminal** marker stayed where a command must go before
opencode starts (SSH, `srun`, `bash setup.sh`) — see
[Setup](02-setup.md). Locally, instead of `!`, you can use a separate terminal — then a
restart of opencode may be needed if your environment requires it.
If the training contains ready-made prompts, you are not obliged to copy them — you can write a prompt of a similar meaning yourself, in your own words.

## Agenda

The full outline of the day is in the [Agenda](00-agenda.md).

## Done when…

- you know what we will be doing and how we mark the steps (🚀 demo / 🛠️ do it yourself / ⭐ optional).

---

[Agenda](00-agenda.md) · [Next: Setup — connecting and starting →](02-setup.md)
