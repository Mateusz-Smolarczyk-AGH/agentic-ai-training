# Skills

[← Previous: Security](12-security.md) · [Agenda](00-agenda.md) · [Next: MCP ⭐ →](14-mcp.md)

## What a skill is

A skill is an **on-demand instruction** in a `SKILL.md` file. It loads only when it is
needed — that is why it does not take up context for no reason. It tells the agent **how** to
perform a class of tasks: steps, conditions, output format, pitfalls.

A skill lives in the repository, is versioned and works in every session.

## Where a skill lives

opencode discovers project skills **automatically** in:

```text
.opencode/skills/
└── <id>/
    └── SKILL.md
```

`<id>` is the directory name (e.g. `monthly-report`) — that is how you invoke the skill.
The frontmatter `name` is just a label. Next to `SKILL.md` you can keep `scripts/` and `references/`.

## The "before" test

We have a file `examples/finance/transactions.csv` — revenue and costs in **PLN, EUR, USD and GBP**.
The agent is supposed to turn it into a **monthly financial report**. The catch: without instructions
the model does not know that it must (a) **check the current rates online** and (b) **convert
everything to zloty**, or what the result should look like.


> 🚀 **Paste into opencode:** the `build` agent, CHANGE THE MODEL to **Qwen3.6 35B A3B**, paste:
```text
Prepare a monthly financial report from the file examples/finance/transactions.csv.
```

The agent will spit out "something" — but it usually will not fetch the rates, will not convert the
currencies (or will count them separately) and sticks to no format.

## Add the skill

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/apply-skill.sh
```

The script creates `.opencode/skills/monthly-report/SKILL.md` — a skill that describes the **whole
workflow** and enforces a **rule**: convert every amount to PLN at the **current average NBP
rate** fetched with `webfetch`, and at the end give the report in the required format.

> 🛠️ **Do it yourself:** create the file `.opencode/skills/monthly-report/SKILL.md`:

````markdown
---
name: Monthly report
description: Builds a monthly financial report (revenue, costs, result, margin) from multi-currency data, converting every amount to PLN at current NBP rates. Use when asked for a financial report, a spending and profit summary, or a monthly close.
---

# Monthly report

## Workflow
1. Load the data; split income from costs.
2. Sum amounts separately in each currency.
3. RULE: convert every non-PLN amount to PLN at the current average rate of NBP table A, fetched
   with `webfetch` from `https://api.nbp.pl/api/exchangerates/tables/A/?format=json`.
   Never convert from memory.
4. Compute the result and the margin.
5. Build the report in the required format.

## Format
```
# Monthly report: <month YYYY>
## Summary
- Revenue: <P> PLN
- Costs: <K> PLN
- Result: <P−K> PLN (margin <m>%)
## NBP rates (table A, <published date>)
| Currency | Average rate (PLN) |
## Costs by category (PLN)
| Category | Cost (PLN) |
## Recommendation
- <one sentence>
```

## Pitfalls
- Convert to PLN first, only then sum.
- Rates must come from NBP (current); include the table date. If there is no network, say so instead of guessing.
````

Once added, the skill appears **right away** — there is no need to reload or restart opencode. Invoke it in the same session.

## The "after" test
Go to a new session.
> 🚀 **Paste into opencode:** paste the **same** task as in the "before" test

Now the agent follows the workflow: it **fetches the current NBP rates with `webfetch`**, **converts
EUR/USD/GBP to zloty**, shows the rates used with the table date and returns the report in the required
format (summary, rates, costs by category, recommendation). That is the whole difference: the skill
enforces *checking the rates and converting*, which the model would have skipped on its own.


## AGENTS.md — "permanent" instructions, not on demand ⭐

A skill loads **on demand**. There is a second mechanism: **`AGENTS.md`** — a file that opencode
loads **always, right away, into every session**. It does not need to be invoked.

| | Skill (`SKILL.md`) | `AGENTS.md` |
|---|---|---|
| When it enters the context | when the agent reaches for it | **always** |
| What for | "how to do a class of tasks" | permanent project rules |
| Where | `.opencode/skills/<id>/` | the project directory (and subdirectories) |

`AGENTS.md` in the project directory (and nested ones — loaded when the agent enters a subdirectory)
describes: build/test commands, conventions, architecture, what not to touch. The global one lives in
`~/.config/opencode/AGENTS.md`.

An example `AGENTS.md`:

```markdown
# Project instructions

- After changing Python, run `python3 examples/mini-projekt/app.py`.
- We keep the demo data in `examples/`.
- Do not edit the files in `generated/`.
```

> ⭐ **Do it yourself — generate `AGENTS.md` with `/init`:** in opencode type `/init`. That is a
> guided mode in which the agent analyses the repository and proposes `AGENTS.md`
> (build, tests, directory layout). Accept the proposal, then **add your own rule** and
> see that it works right away — edits to `AGENTS.md` are detected on the fly, without a restart.

## Done when…

- without the skill the agent produced the report "its own way", without rates and without converting currencies,
- with the skill it fetched the NBP rates, converted to PLN and stuck to the format,
- you know that project skills live in `.opencode/skills/<id>/SKILL.md`,
- you added your own skill (on your own or with the agent) and invoked it,
- you can tell a skill (on demand) from `AGENTS.md` (always in the context),
- you know that `/init` can write `AGENTS.md` for you.

---

[← Previous: Security](12-security.md) · [Agenda](00-agenda.md) · [Next: MCP ⭐ →](14-mcp.md)
