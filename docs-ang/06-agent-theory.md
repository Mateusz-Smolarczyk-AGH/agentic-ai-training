# Theory — the agent and the harness

[← Previous: What chat cannot do — no tools](05-what-chat-cannot-do.md) · [Agenda](00-agenda.md) · [Next: Working with opencode →](07-working-with-opencode.md)

An agent is a chat + **tools** + a **loop**. Tools **enrich the context** — the agent knows more
than the model remembers.

We will use three agents (you switch between them with **Shift+Tab**):

| Agent      | What it can do                                           |
|------------|----------------------------------------------------------|
| `chat`     | **no tools** — conversation only                         |
| `plan`     | **reads** files, runs commands, searches the web         |
| `build`    | like `plan`, but **changes files** (more on that later)  |

## Agents

| Term                  | Meaning                                                                      |
|-----------------------|------------------------------------------------------------------------------|
| **Harness**           | the program that runs the agent loop (here: opencode)                        |
| **Agent**             | model + tools + loop; it decides for itself what to do                       |
| **Agent loop**        | model → decision → tool → observation → model                                |
| **Tool**              | a function the agent can call (read a file, run a command)                   |
| **Function calling**  | the mechanism by which the model proposes a tool call                        |
| **Skill**             | an instruction loaded on request (how to perform a class of tasks)           |
| **MCP**               | a protocol for connecting external tool servers                              |
| **Subagent**          | a separate agent session to which a task is delegated                        |

## Knowledge and context

| Term                  | Meaning                                                                      |
|-----------------------|------------------------------------------------------------------------------|
| **RAG**               | retrieving fragments and attaching them to the prompt                        |
| **Embedding**         | a numeric vector representing the meaning of text                            |
| **LLM Wiki**          | a knowledge base of documents run by the agent (OKF format)                  |

## The concepts will come back in practice

We are not leaving this as theory — once you get onto the cluster you will see each of these concepts in action:

- **tool / loop** → the [Agent plan](08-agent-plan.md) block,
- **skill** → the [Skills](13-skills.md) block,
- **MCP** and **subagent** → the ⭐ tasks ([MCP](14-mcp.md), [Subagents](15-subagents.md)).

## Done when…

- you can explain: harness, agent, agent loop, tool, function calling, skill, MCP, subagent,
- you know that an agent can check things (tools) and chat cannot.

---

[← Previous: What chat cannot do — no tools](05-what-chat-cannot-do.md) · [Agenda](00-agenda.md) · [Next: Working with opencode →](07-working-with-opencode.md)
