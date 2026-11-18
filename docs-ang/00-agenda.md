# Agenda (outline)

**First steps with AI agents: research, working with code and your own wiki**
24.11.2026, Krakow · 10:30–14:00 (3.5 h, break around 12:00, lunch from 14:00)

> Start with the setup, see the difference between chat and agent, work on real code, understand security and in the end build your own wiki from articles found by the agent.

## Agenda

| Time        | Block                                                              | What you do                                                       | Done when                                                                  |
|-------------|--------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------|
| 10:30–10:40 | [Introduction](01-introduction.md)                                 | ---                                                               | You know what we will be doing                                             |
| 10:40–10:55 | [Setup — connecting and starting](02-setup.md)                     | SSH, compute node, `setup.sh`, login, test                        | You see the `plgrid/…` models and get an answer                            |
| 10:55–11:05 | [Theory — what a chat is](03-chat-theory.md)                       | Slide: concepts (LLM, token, prompt, context window…)             | You know the basic concepts                                                |
| 11:05–11:15 | [Chat in practice — the model's knowledge](04-chat-in-practice.md) | Question from general knowledge → chat answers                    | You understand: chat answers from the model's knowledge                    |
| 11:15–11:20 | [What chat cannot do — no tools](05-what-chat-cannot-do.md)        | Question about local state/today → chat cannot                    | You see the missing tools                                                  |
| 11:20–11:35 | [Theory — the agent and the harness](06-agent-theory.md)           | Slide: agent, loop, tools                                         | You know the agent concepts                                                |
| 11:35–11:45 | [Working with opencode](07-working-with-opencode.md)               | Sessions, models, agents                                          | You can find your way around                                               |
| 11:45–11:55 | [Agent plan](08-agent-plan.md)                                     | The same questions, now the agent checks                          | You saw a raw tool call                                                    |
| 11:55–12:05 | ☕ Break                                                            |                                                                   |                                                                            |
| 12:05–12:25 | [Code — analysis](09-code-analysis.md)                             | Plan explains the code and gives a command                        | The agent does not edit files                                              |
| 12:25–12:40 | [Code — implementation](10-code-implementation.md)                 | `build` adds `p95`                                                | Code changed, commands work                                                |
| ---         | [⭐ Code — proposal and review](11-code-proposal-and-review.md)     | Selection, implementation, review                                 | The agent found and fixed bugs                                             |
| 12:40–13:10 | [Security](12-security.md)                                         | injection → allow/ask → deny → workaround → leak                  | You understand the risks of working with an agent and how to use it safely |
| 13:10–13:25 | [Skills](13-skills.md)                                             | Test before/after, add a skill                                    | The agent with a skill behaves differently                                 |
| ---         | [MCP](14-mcp.md) ⭐ or [Subagents](15-subagents.md) ⭐               | Add an MCP server or a subagent                                   | The tool works                                                             |
| 13:25–13:40 | [Agentic research](16-agentic-research.md)                         | The agent fetches source documents into `wiki/llm-wiki/raw/`      | Source corpus in `raw/`                                                    |
| 13:40–14:00 | [LLM Wiki](17-llm-wiki.md)                                         | Wiki from the research corpus + comparison with wiki/without wiki | The answer cites a wiki page                                               |

## Pages

1. [Introduction](01-introduction.md)
2. [Setup — connecting and starting](02-setup.md)
3. [Theory — what a chat is](03-chat-theory.md)
4. [Chat in practice — the model's knowledge](04-chat-in-practice.md)
5. [What chat cannot do — no tools](05-what-chat-cannot-do.md)
6. [Theory — the agent and the harness](06-agent-theory.md)
7. [Working with opencode](07-working-with-opencode.md)
8. [Agent plan — the answer chat could not give](08-agent-plan.md)
9. [Code — analysis (plan)](09-code-analysis.md)
10. [Code — implementation (build)](10-code-implementation.md)
11. [⭐ Code — proposal and review](11-code-proposal-and-review.md)
12. [Security](12-security.md)
13. [Skills](13-skills.md)
14. [MCP ⭐](14-mcp.md)
15. [Subagents ⭐](15-subagents.md)
16. [Agentic research](16-agentic-research.md)
17. [LLM Wiki](17-llm-wiki.md)
