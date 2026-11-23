# Local install — opencode + PLGrid

[← Previous: LLM Wiki](16-llm-wiki.md) · [Agenda](00-agenda.md)

This page is a step for you **after the workshop**, on your own laptop. During the sessions we
worked from the cluster over SSH — [02-setup.md](02-setup.md) — and installed nothing locally.
Here you install opencode and the PLGrid plugin on your own machine.

Scope: **macOS and Linux**. Windows is out of scope for this step.

## Step 1 — the PLGrid API key

The key is created in **PLGrid Forge**. Before you can generate it, you go through four formal
steps — in this order:

1. **Account, affiliation, team** — guide:
   [guide.plgrid.pl → How to start](https://guide.plgrid.pl/en/portal-for-science/how-to-start/for_beginners).
2. **A grant with credits for the LLM service** — in the Resources tab. New grant:
   [guide → Proper grants](https://guide.plgrid.pl/en/portal-for-science/grants/plgrid/proper);
   to add credits to an existing grant, renegotiate the resources in the PLGrid Portal:
   [guide → Renegotiation](https://guide.plgrid.pl/en/portal-for-science/grants/plgrid/proper/renegotiation).
3. **Activating the PLGrid Forge service** in the PLGrid Portal:
   [portal.plgrid.pl/services/111](https://portal.plgrid.pl/services/111).
4. **Generating the key** — go to [llmlab.plgrid.pl](https://llmlab.plgrid.pl) → the **Grants**
   tab → next to the selected grant click `Generate API Key` (or open the grant tile →
   `Actions` → `Generate API Key`), then `Generate`.

When generating, you fill in:

| Field | Meaning |
|-------|---------|
| **name** | must be unique among the keys of that grant; this is the only mandatory field |
| **expiration date** | after that date the key will not authorize; **this date cannot be changed after the key is created** |
| **monthly credit limit** and **total credit limit** | how many credits the key may use from the grant's pool; the guide recommends setting a monthly limit, because it minimises damage if the key leaks |

You click `Create`. The key content appears as `Your API Token` — **copy and save it immediately**;
for security the key content is not stored in the PLGrid Forge system, so you can only see it right
after creation. The key has the form `plg-…`.

You manage keys in the tab [llmlab.plgrid.pl/auth-keys](https://llmlab.plgrid.pl/auth-keys):
status (active / expired / revoked), changing limits, `Revoke`.

> **Security:** anyone who knows the key content can send requests to the models — even without a
> PLGrid account. **Treat the key like a password.** Never put it in a repository or in a config
> file. The credits a key uses are charged to the grant and the limits of the person who generated it —
> that is why scoped limits matter.

## Step 2 — installing opencode 2.x

> 🚀 **Paste into the terminal:**

```bash
curl -fsSL https://opencode.ai/v2/install | bash
```

On macOS you can use Homebrew instead:

> 🚀 **Paste into the terminal:**

```bash
brew install anomalyco/tap/opencode-v2
```

Check the version: `opencode --version` must print `opencode v2.…`. The plugin requires opencode
v2 — opencode 1.x is not supported by this plugin.

## Step 3 — installing the PLGrid plugin

> 🚀 **Paste into the terminal:**

```bash
opencode plugin add https://github.com/cyfronet/opencode-plugin-plgrid.git
```

Installing the plugin from GitHub needs `git` on the system — on macOS install the developer
tools (`xcode-select --install`), on Linux install the `git` package.

The plugin:

- registers the integration `plgrid` (display name `PLGrid Forge (Cyfronet)`) with a key login
  method, so `opencode auth login plgrid` works,
- registers the provider `plgrid` built on the OpenAI-compatible runtime package, with `baseURL`
  pointing at the gateway,
- fetches the model list from the gateway at startup, so new or retired models appear without
  reinstalling.

Check that it is registered:

> 🚀 **Paste into the terminal:**

```bash
opencode plugin list
```

The plugin installs into the **global opencode configuration**, so it applies to every directory,
not just one project.

## Step 4 — logging in with the key

> 🚀 **Paste into the terminal:**

```bash
opencode auth login plgrid
```

When asked, paste the `plg-…` key. This prompt needs a real interactive terminal — piping the key
in does not work (opencode reports "API key input requires an interactive terminal").

Check:

> 🚀 **Paste into the terminal:**

```bash
opencode auth list
```

opencode stores the key in its own credential store under `~/.local/share/opencode/` — never in the
repository and never in `opencode.json`. After logging in, **restart opencode**: the plugin reads
the credential and fetches the model list when opencode starts.

## Step 5 — checking it works

> 🚀 **Paste into the terminal:**

```bash
opencode models | grep '^plgrid/'
```

You should see the `plgrid/…` models your grant can use.

The first question:

> 🚀 **Paste into the terminal:**

```bash
opencode run -m plgrid/deepseek-ai/DeepSeek-V4.1-Flash "Write in one sentence what opencode is."
```

You can also start `opencode`, pick a model with `/models`, and ask the same question in the
interface.

Locally — unlike on the cluster — you can simply use a second terminal window, instead of typing
`!` inside opencode.

---

## Config

The repo ships an **example config** — [`opencode.example.json`](../opencode.example.json). It is a
full, ready-to-adapt setup: a default model, the context7 MCP server, a few commands, tightened
permission rules and example subagents (`reviewer`, `researcher`, `architect`, `editor`, and more).

> **Important:** the file contains **no `plugins` entry and no `provider` block** — it assumes the
> plugin from step 3 provides the `plgrid` provider and the connection. So when you add it, **be
> careful not to overwrite the plugin wiring**.

The safest way to use it is as a **project config** — copy it into your own project and start
opencode from that project's directory:

> 🚀 **Paste into the terminal:**

```bash
mkdir -p <your-project>/.opencode
cp <repo>/opencode.example.json <your-project>/.opencode/opencode.json
```

`<repo>` is the workshop repository on your disk. A project config **merges** with the global one
(the `plugins` lists add up rather than replace each other), so the plugin wiring from step 3 stays
untouched.

If you would rather have it **globally**, **do not replace the whole**
`~/.config/opencode/opencode.json`. Add only the sections from the example to the file you already
have, and **keep whatever connects the plugin**: the `"plugins"` entry written by
`opencode plugin add` and the `~/.config/opencode/plugins/` directory. The example has no
`"plugins"` entry, so a plain copy of the file drops the wiring and you lose
`opencode auth login plgrid` (you would have to repeat step 3).

> **Note:** it is an example — adapt it to yourself. The `permission.skill` and `permission.*_*`
> entries reference skills and MCP tools you may not have, and the model list comes from your grant.
> The permissions are deliberately tight (secrets `deny`, `bash` `ask`) — keep them or tune them
> ([Security](12-security.md)).

## When something does not work

The plugin prints these messages to stderr, and the gateway URL is
`https://llmlab.plgrid.pl/api/v1/models/opencode-config`.

| Situation | What you see | What to do |
|-----------|--------------|------------|
| No key at all | `[plgrid] no API key found; run \`opencode auth login plgrid\`` | You did not log in, or you did not restart opencode after logging in. |
| Key rejected by the gateway (bad, expired or revoked) | `[plgrid] could not fetch https://llmlab.plgrid.pl/api/v1/models/opencode-config: HTTP 401` (the gateway may return another error code) | Generate a fresh key in [llmlab.plgrid.pl](https://llmlab.plgrid.pl) (Grants → Generate API Key). |
| Unreachable gateway (network, proxy, firewall, 10 s timeout) | `[plgrid] could not fetch <address>: <reason>` | Check that you can reach llmlab.plgrid.pl and retry. |
| No models in the response | `[plgrid] no models returned by <address>` | The grant has no LLM credits or the PLGrid Forge service is not active — go back to step 1. |
| A model replies with `not available for grant` | the `not available for grant` message | Your grant does not cover that model; pick another one with `/models`. |
| The plugin did not finish activating | `Location plugins did not finish activating` | The gateway answered too slowly (the plugin has about 5 s during activation); run opencode again. |
| An old opencode version | `opencode --version` prints 1.x | The plugin needs opencode v2; upgrade (step 2). |
| Models are listed but nothing answers | no answer from the model | Check the account (`opencode auth list`), log in again (`opencode auth login plgrid`) and restart opencode — model calls need a valid key. |

Advanced knowledge: the plugin understands two environment variables. `PLGRID_API_KEY` takes
precedence over the stored credential and is useful in scripts. `PLGRID_API_BASE_URL` changes the
gateway address (default `https://llmlab.plgrid.pl/api/v1`).

## When you cannot use `opencode plugin add`

The repository ships the same plugin as a single file: `snippets/plgrid.js` (a byte-identical copy
of the upstream package). Copy it into the global plugins directory:

> 🚀 **Paste into the terminal:**

```bash
mkdir -p ~/.config/opencode/plugins
cp <repo>/snippets/plgrid.js ~/.config/opencode/plugins/plgrid.js
```

`<repo>` is the workshop repository on your disk. Then restart opencode and continue with step 4
(login) and step 5 (check). opencode discovers every plugin in that directory at startup.

This is the last step of the workshop. The cluster setup is [02-setup.md](02-setup.md), and the
rest of the workshop pages are listed in [00-agenda.md](00-agenda.md).

## Done when…

- you have the `plg-…` key saved outside the repository,
- `opencode --version` prints `opencode v2.…`,
- `opencode plugin list` shows the PLGrid plugin,
- `opencode auth list` shows `plgrid`,
- `opencode models` lists the `plgrid/…` models,
- you asked a question and got an answer.

---

[← Previous: LLM Wiki](16-llm-wiki.md) · [Agenda](00-agenda.md)
