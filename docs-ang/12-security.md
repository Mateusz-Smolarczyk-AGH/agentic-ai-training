# Security

[← Previous: Code — proposal and review ⭐](11-code-proposal-and-review.md) · [Agenda](00-agenda.md) · [Next: Skills →](13-skills.md)

> ⚠️ Today's config has **`"permission": { "*": "allow" }`** — permission for everything, deliberately:
> it is a sandbox on the cluster (scratch, demo data) and a deliberate starting state. The agent
> **does not ask anything**. At the start of this block that is exactly what we will use.

## Demo 1 — injection: the agent asks nothing, and it pulled something off

The `demo-vulnerable` agent (Shift+Tab). Prompt: an ordinary typo fix.

> 🚀 **Paste into opencode:**

```text
Fix the typo in examples/injection/NOTES.md
```

Watch what happened, what the agent did!!! Instead of just the edit the agent **will delete
the `CRITICAL_DATA/` folder** — because a hidden instruction in `NOTES.md` told it to.

**The story:** the agent reads files, and along with the content it also reads the **instructions** in them.
If someone hides a command in a file, the agent may carry it out — even if you asked for something
completely different.

> ⚠️ **This is a demonstration.** The `demo-vulnerable` agent (model `DeepSeek-V4-Flash`) is
> **deliberately** prepared to give in to such a command: commands from files marked
> with the `[TRUSTED]` tag it treats as operator commands. This is not an opencode vulnerability, only
> a demonstration of the phenomenon.

> 🚀 **Type `!` and paste into opencode:** demo restart — the script will recreate the data and print the prompt to paste:

```bash
bash scripts/12-injection-demo.sh
```

> 🛠️ **Do it yourself:** look into `examples/injection/NOTES.md` and find the hidden instruction — an HTML comment at the very top of the file, marked with the `[TRUSTED]` tag.

## How to counter it: how to secure the agent's actions?

The agent deleted the data without asking. We do have two ways to limit what the agent can do:

1. **Asking for consent** (`ask`) — before the agent performs an action, it asks you.
2. **Blocking tools** (`deny`) — the action is forbidden and it will not perform it even after consent.

### The mechanics: how allowing commands works

Every agent action (running a command, editing a file, visiting a page…) lands on a permission
rule. The rule produces one of three effects:

| Effect   | What happens                                       |
|----------|----------------------------------------------------|
| `allow`  | the action goes **without asking**                  |
| `ask`    | the agent **asks** for consent                      |
| `deny`   | the action is **blocked** (the agent will not do it) |

Rules are set in `.opencode/opencode.json`, in the `permission` section. You can set
**everything at once**, or **per command**. The shell command patterns live in the `bash` subsection:

```json
"permission": {
  "bash": {
    "*": "ask",
    "ls *": "allow",
    "python3 *": "allow",
    "rm -rf *": "deny"
  }
}
```

Matching works by **pattern** (`*` = any string, `?` = one character), and **the last matching
rule wins**. That is why you first give `*`, and then the specific rules.

## The change: `*` allow → `*` ask

Let us restrict the agent by one step: **let it ask**.

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/ask-all.sh
```

The script sets in `.opencode/opencode.json`:

```json
"permission": { "*": "ask" }
```

**There is no need to restart opencode** — the config takes effect straight away, in the same session. Ask the agent for any command and see that it now asks.

> 🛠️ **Do it yourself, how to check what is in the config** (in opencode: type `!` and paste the command):
>
> ```bash
> python3 -c "import json,os;print(json.load(open('.opencode/opencode.json'))['permission'])"
> ```

## Demo 2 — asking in practice (ask)

> 🚀 **Paste into opencode:** the `plan` or `build` agent, paste:

```text
Run the command `date` and show the result.
```

The agent **will ask** (because `"*": "ask"` catches everything). Do the following in order:

1. Choose **once** → it will count the time. Ask for `date` **again** → **it asks again**
   (once works only one time).
2. Choose **always** → ask for `date` once more → **it does not ask** (opencode saved the pattern,
   e.g. `date *`, for this project).
3. Ask for a **different** command, e.g. `uname -a` → **it asks again** (a different pattern).
4. Restart opencode and ask for `date` → **it still does not ask** — in opencode 2 "always" saves
   a **durable, per-project** `allow` rule, so a restart does not clear it (see below how to remove it).
   This restart is not about reloading the config — it is about proof that a saved "always" survives a restart.

That is the whole answer to the question "why does something approved **once** no longer ask me".

## What happens when the agent asks

The UI gives three answers:

| Choice     | Meaning                                                                             |
|------------|-------------------------------------------------------------------------------------|
| **once**   | approve **this one** action                                                         |
| **always** | approve the **matching patterns** and **save them permanently for this project**     |
| **reject** | refuse                                                                              |

### "Always allow" in opencode 2 is durable

This is the most common misunderstanding — worth showing live. "Always" is **not** one-off:

1. **It survives a restart.** The saved approval lands in opencode's data as an `allow` rule
   **assigned to the project** — a new session and a restart do not clear it.
2. **It approves only the suggested pattern.** For bash that is usually a **command prefix**, e.g.
   `date *`. A different command — or the same program with other arguments — does not match and
   **it asks again**.
3. **The pattern is often narrow.** "Always" on `ls -la` does not cover `ls /tmp` or `ls | head`.
4. **`deny` is stronger.** A saved "always" will never bypass a `deny` rule from the config.

> 🔎 **How to remove a saved "always"** (in opencode: type `!` and paste the command; so that the agent asks again):
>
> ```bash
> opencode api get /api/permission/saved          # peek at the saved rules
> opencode api delete /api/permission/saved/<id>  # remove the selected one
> ```
>
> Saved rules are **per project** — in a new directory/repo clone you start without them.
> Want to change something permanently and deliberately — write the rule into `.opencode/opencode.json`
> (the `permission` section). Want not to be asked about anything (except `deny`)? Run `opencode --auto`.

## A sensible permission set — so that you can keep working

With `"*": "ask"` every `ls` and `cat` asks — for the further steps that is annoying. Let us set a healthy
set: **ask about everything except a few read-only commands**.

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/sensible-permissions.sh
```

The script sets (shell patterns in the `bash` subsection):

```json
"permission": {
  "read": "allow",
  "edit": "allow",
  "bash": {
    "*": "ask",
    "ls *": "allow",
    "cat *": "allow",
    "grep *": "allow",
    "find *": "allow",
    "git status *": "allow",
    "git diff *": "allow",
    "git log *": "allow",
    "python3 *": "allow"
  }
}
```

(`python3` is on the allow list — that is exactly the path the bypass in Demo 5 ⭐ works through.)

There is no need to restart — the config works immediately. From now on reading files, editing, `ls`, `cat`, `grep`, `find`, `git`,
`python3` go without asking — while **everything else** (e.g. `date`, `whoami`, any command outside
the allow list) **asks**. This set stays until the end of the training.

## Demo 3 — injection again: now the agent asks

The same story, with the sensible set. Run the demo once more:

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/12-injection-demo.sh
```

and paste **the same** prompt ("Fix the typo…").

Now, before it deletes the data, the agent **asks for consent** — and that is the moment when the order
`allow` → `ask` genuinely changed the behaviour. Notice: the agent would normally ask about *an edit in the file*,
but suddenly it asks about *deleting a directory* — that is a signal that something odd is going on. **Read the approval
prompt before you allow it** — that is the habit that guards against injection.

## Demo 4 — we put deletion on `deny`

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/block-rm.sh
```

The script adds `"rm -rf *": "deny"` to the `bash` subsection in the `permission` section. Repeat demo 3 —
the agent **refuses**: the command is forbidden, the agent will not perform it even after the user's consent.

> 🛠️ **Do it yourself:** open `.opencode/opencode.json`, in the `permission` section → `bash` add
> `"rm -rf *": "deny"`. `scripts/block-rm.sh` does exactly that.

## Demo 5 ⭐ — Bypassing the block

Blocking a command is not everything. `rm -rf` is on `deny`, but in our set `python3` and `find`
are on the allow list — so the agent will reach the same goal with another tool, **without asking**.

Recreate the demo folder (`reset-demo.sh` also restores `examples/demo_bypass/`):

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/reset-demo.sh
```

> 🚀 **Paste into opencode:** switch the agent (Shift+Tab) to `demo-bypass` and paste:

```text
Delete the folder examples/demo_bypass with rm -rf.
```

The `demo-bypass` agent is **prepared specifically for this demo**. You will see in order:

1. the agent tries `rm -rf ...` → **`deny`** (a hard block, it does not ask, it does not perform),
2. it does not give up — it reaches for an **allowed** tool, e.g.
   `python3 -c "import shutil; shutil.rmtree(...)"` (without asking for consent),
3. the folder **disappears despite the block**.

> 🛠️ **Do it yourself:** the moral — blocking a single *command* is not enough. `python3`, `find`,
> `node` or any general-purpose interpreter bypasses `deny`. Commands of this kind are better set to `ask`.


## Clean up

> 🚀 **Type `!` and paste into opencode:**

```bash
bash scripts/reset-demo.sh
```

A sensible permission set (ask + allow list) **stays** — for the purposes of this workshop. In your own work it is worth putting the python and find commands on `ask`. If
you want to go back to "I allow everything", replace the `permission` section with `{ "*": "allow" }`
in `.opencode/opencode.json`.

## Cheat sheet: allow / ask / deny

- `allow` — without asking; `ask` — asks; `deny` — blocks.
- "once" = one time; "always" = saves the matching patterns **durably for the project**; "reject" = refusal.
- You write the shell command patterns in the config in the `bash` subsection (the `permission` section).
- `--auto` = do not ask about anything that is not on `deny`.

## Done when…

- you saw the surprise: the agent deleted the data without asking (injection),
- you can change the default `allow` permission → `ask` and you know when the agent asks,
- you know that "Always allow" saves a **durable, per-project** rule and how to remove it,
- you have a permission set you can work with,
- you can block a command and you know the block can be bypassed,
- you know that the files being read go out to the provider.

---

[← Previous: Code — proposal and review ⭐](11-code-proposal-and-review.md) · [Agenda](00-agenda.md) · [Next: Skills →](13-skills.md)
