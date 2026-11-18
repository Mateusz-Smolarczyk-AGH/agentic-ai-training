# Code — implementation (build)

[← Previous: Code — analysis (plan)](09-code-analysis.md) · [Agenda](00-agenda.md) · [Next: Code — proposal and review ⭐ →](11-code-proposal-and-review.md)

Now we give the agent **hands** — `build` is the same agent, but with the edit tool; it
**makes changes**.

> "An agent can change files" does not mean "every agent". It is a matter of a **specific tool and
> permission**.

### build changes the file

> 🚀 **Paste into opencode:** switch (**Shift+Tab**) to the `build` agent and paste **the same**
> command.

```text
In the file examples/mini-projekt/app.py add a new command `p95 <numbers>`
that computes the 95th percentile of the given values.
```

`build` will ask for permission to **edit** — approve it and see the finished change. Then check:

> 🚀 **Type `!` and paste into opencode:**

```bash
python3 examples/mini-projekt/app.py p95 10 20 30 40 50
python3 examples/mini-projekt/app.py median 10 20 30 40 50
```

The `p95` result should be **between the median (30) and the maximum (50)**, closer to the maximum — and `median`
already returned `30` before. You see both: plan **at most describes**, build **changes the code**.

## Done when…

- `build` added the `p95` command,
- the `p95` result is between the median and the maximum.

---

[← Previous: Code — analysis (plan)](09-code-analysis.md) · [Agenda](00-agenda.md) · [Next: Code — proposal and review ⭐ →](11-code-proposal-and-review.md)
