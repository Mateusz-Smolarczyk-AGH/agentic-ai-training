# Setup — connecting and starting

[← Previous: Introduction](01-introduction.md) · [Agenda](00-agenda.md) · [Next: Theory — what a chat is →](03-chat-theory.md)

On the training we work from the cluster over SSH — you install
nothing, the agent runs on the compute node.

## Before you start

You need **your own laptop** and an **SSH client**. Nothing more — opencode and the models are
prepared on the cluster.

### SSH client

| System  | What to use                                                           |
|---------|-----------------------------------------------------------------------|
| Windows | **Windows Terminal** with built-in **OpenSSH** (or MobaXterm / PuTTY) |
| Linux   | `ssh` from a terminal                                                 |
| macOS   | `ssh` from Terminal.app                                               |

On Windows 10/11 `ssh` is already there: open Windows Terminal and type `ssh <login>@…`.

> 🛠️ **Do it yourself:** check that you have SSH by typing `ssh -V`. If the command does not exist,
> use MobaXterm.

### Account on the cluster

- An account able to take a **compute node** (we do not work on the login node).
- You will get the access credentials on site.

### Comfortable copying (recommended)

opencode runs full screen and manages copying itself:

- **Windows Terminal / PuTTY:** select with **Shift** (Shift + mouse drag),
  copy with `Ctrl+Shift+C`, paste with `Ctrl+V` (browser) or `Ctrl+Shift+V` (terminal).
- **Terminals that support OSC 52** (kitty, WezTerm, Alacritty, foot) copy directly.

> 🚀 **Windows Terminal / PuTTY:** hold **Shift** and select with the mouse; copy with `Ctrl+Shift+C`.


### What you do NOT need

- Docker or a container,
- installing opencode locally,
- commercial API keys — we use the PLGrid Forge models,
- the ability to edit files — you make all changes with ready-made commands.

---

## Setup

### 1. Connect to the cluster

> 🚀 **Paste into the terminal:**

```bash
ssh <login>@ares.cyfronet.pl
```

Type your password. You are on the **login node** — here you may only prepare your work.

> On your first
> login `ssh` asks whether to trust the host key — type `yes`. While you type the password nothing
> appears on the screen; that is normal. When the connection drops, the session ends — log in
> again and run `srun` once more; files in `$HOME` and `$SCRATCH` stay. To
> leave the node yourself, type `logout` — you go back to `login01`, and the cores are freed for others.

### 2. Take a compute node

> 🚀 **Paste into the terminal:**

```bash
srun --partition=cpu --nodes=1 --ntasks=1 --cpus-per-task=6 --time=4:00:00 --pty bash -l
```

### 3. Run the trainer's script

Run it on the **compute node** (after `srun`) —
the **`setup.sh`** script — it prepares the environment itself.

> 🚀 **Paste into the terminal:**

```bash
bash setup.sh
```

The file from the trainer already has the repository address filled in. If the script reports a message about `REPO_URL`, ask the trainer for the correct file.

The script goes through the following, in order:

| # | Step         | What happens                                                                                                                                                                                                             |
|---|--------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | Lmod modules | `module load python/3.13.5-gcccore-14.3.0 nodejs/22.17.1-gcccore-14.3.0 opencode/2.1.3`                                                                                                                                  |
| 2 | Clone        | `git clone` the repository into `$SCRATCH/szkolenie`                                                                                                                                                                     |
| 3 | Port         | `opencode service set port "$(bash scripts/port-helper.sh print)"` — the base port is `40000 + UID % 20000`, and when it is taken, the helper checks `bind` on `localhost` and picks a random free port from `8000-9999` |
| 4 | Models       | checks that `opencode models` lists the `plgrid/…` models                                                                                                                                                                |
| 5 | Login        | `opencode auth login plgrid`                                                                                                                                                                                             |
| 6 | Start        | `cd $SCRATCH/szkolenie` and starts `opencode`                                                                                                                                                                            |

The target directory is `$SCRATCH/szkolenie`, and when `$SCRATCH` is not set — `$HOME/szkolenie`.

## Test — the first question

> 🚀 **Paste into opencode:** any question, for example:

```text
In one sentence, write what opencode is.
```

Success is confirmed by **an answer from the model**. If there is none — go back to the [Setup](#setup) section.

## Done when…

- you are connected over SSH,
- you see the `plgrid/…` models,
- you asked a question in opencode and got an answer.

---

[← Previous: Introduction](01-introduction.md) · [Agenda](00-agenda.md) · [Next: Theory — what a chat is →](03-chat-theory.md)
