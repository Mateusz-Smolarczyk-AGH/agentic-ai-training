# Working with opencode

[← Previous: Theory — the agent and the harness](06-agent-theory.md) · [Agenda](00-agenda.md) · [Next: Agent plan — the answer chat could not give →](08-agent-plan.md)

## opencode = harness

opencode is a **harness**: it runs the agent loop (model → tool → observation), maintains the
session context, enforces permissions and supplies the tools. The model itself does not "execute"
anything — it proposes calls, and opencode carries them out.

## How to manage sessions

Every conversation in opencode is a **session**: your messages, the agent's answers and the tool
calls. Sessions save themselves — exiting loses nothing.

You can manage sessions like tabs at the top of the screen or through opencode commands.

- **New session:** `/new` (alias `/clear`) — a clean start, the previous ones still exist.
- **Returning to a session:** `/sessions` (aliases `/resume`, `/continue`) — a list and switching
  in the interface. From the terminal: `opencode --continue` (last session) or
  `opencode --session <id>`.
- **Session too long:** `/compact` shortens it when the context fills up — the agent keeps
  the essence, loses the details.
- **Undo:** `/undo` reverts your last message together with the agent's answer **and the changes
  to files** (it uses git, so it works in a repository); `/redo` restores what was undone.

## How to manage models

The model is the agent's "brain". In opencode it is called `provider/model`, e.g.
`plgrid/deepseek-ai/DeepSeek-V4.1-Flash`.

- **Change in the interface:** `/models` — choose from a list.

## How to manage agents

An agent is a model + tools + permissions + a system prompt. **The same model can be used by different agents** — what it is allowed to do and how it behaves change.

- **Change in the interface:** **Shift+Tab** — switching between agents.
- **Built in:** `build` (can edit files) and `plan` (read only). In this repo there are additionally
  `chat` (no tools — used right away in the comparison) and `demo-vulnerable` (for the security
  demo).

## Command cheat sheet

**In the interface (type `/`):**

| Command      | Action                                             |
|--------------|----------------------------------------------------|
| `/help`      | list of commands                                   |
| `/models`    | choosing a model                                   |
| `/sessions`  | list of sessions and switching                     |
| `/new`       | new session                                        |
| `/compact`   | shortening the session                             |
| `/undo`      | undoing the last change (files as well)            |
| `/redo`      | restoring the undone change                        |
| `/details`   | showing the details of tool calls                  |
| `/thinking`  | preview of the model's reasoning                   |
| `/terminal`  | terminal next to the agent                         |
| `/exit`      | exit                                               |


**Conversation elements:**

| Element          | Action                                                                                 |
|------------------|----------------------------------------------------------------------------------------|
| `@plik`          | adds the file's contents to the conversation (fuzzy search)                            |
| `!` + command    | type `!`, then paste the command (without `!`) — the result goes into the conversation |
| **Shift+Tab**    | changing the agent                                                                     |
| `/exit`, Ctrl+C  | exit                                                                                   |

**You run in-session commands with `!`** — first type `!`, then paste the command alone (without
`!`); the result goes into the conversation. **On the cluster this is the main way**: `/terminal` is
sometimes flaky. Locally, instead of `!` you can open a separate terminal — then a restart of
opencode is sometimes needed, if your environment requires it. opencode itself needs no restart:
changes in the configuration (permissions, skills, MCP, subagents) take effect at once.

## Done when…

- you know what a harness is and what it does in the loop,
- you can return to a previous session (`/sessions`, `opencode --continue`),
- you can change the model (`/models`) and the agent (**Shift+Tab**),
- you know how `build`, `plan` and `chat` differ.

Next — a comparison of an agent without tools with an agent that has access to tools.

---

[← Previous: Theory — the agent and the harness](06-agent-theory.md) · [Agenda](00-agenda.md) · [Next: Agent plan — the answer chat could not give →](08-agent-plan.md)
