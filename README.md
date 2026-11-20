# Pierwsze kroki z agentami AI: research, praca z kodem i własna wiki

> Język / Language: **Polski** · [English ↓](#english)

## Polski

> Uwaga o języku: dokumentacja warsztatu w `docs/` jest po polsku (wersja angielska w
> przygotowaniu). Reszta repozytorium — skrypty, przykłady, komentarze — jest po angielsku.

Repo warsztatu na **24.11.2026, Kraków** (10:30–14:00). Uczestnicy dostają to repozytorium na
klastrze i przeglądają je na GitHubie. Wszystko, czego potrzebujesz, jest tutaj — nie musisz
nic instalować poza klientem SSH.

### Jak czytać to repo

Każdy krok ma **trzy ścieżki**:

> **🚀 Wklej do opencode** — gotowy prompt dla agenta.
>
> **🚀 Wpisz `!` i wklej do opencode** — gotowa komenda shell: wpisz `!` w sesji opencode, a
> potem wklej samo polecenie (bez `!`). **Na klastrze to główny sposób** — `/terminal` bywa
> kapryśny; lokalnie możesz użyć osobnego terminala.
>
> **🛠️ Zrób sam (jak to działa)** — dokładny opis i surowe komendy. Dla osób, które chcą
> zrobić coś bardziej kreatywnie same.

**🚀 Wklej do terminala** występuje tylko na starcie, przed uruchomieniem opencode (SSH, `srun`,
`bash setup.sh`, `opencode auth login`). Zmiany w konfiguracji opencode (uprawnienia, skille,
MCP, podagenci) działają **od razu, bez restartu**.

**Nie edytujesz plików ręcznie.** Zmiany robisz gotowymi komendami — tak, żeby nawet bez
znajomości terminala wszystko działało.

Zadania oznaczone **⭐** są **dodatkowe, opcjonalne** — dla osób, które pójdą szybciej.
Opisujemy je dokładnie: co to jest, jak działa, jak dodać, jak przetestować.

### Start

1. [Wstęp](docs/01-wstep.md)
2. [Setup — połączenie i start](docs/02-setup.md)
3. Dalej — kolejne kroki z [Agendy](docs/00-agenda.md)

Na klastrze prowadzący rozdaje plik **`setup.sh`**. Leży on w **katalogu głównym repozytorium**
i jest **gitignorowany** — nie trafia do repo. Uruchomiony przez `bash setup.sh` robi po kolei:
moduły Lmod → clone do `$SCRATCH/szkolenie` → port → modele `plgrid/…` → logowanie
`opencode auth login plgrid` → start opencode. Katalog `scripts/` zawiera tylko komendy dla
uczestników.

### Plan dnia (konspekt)

Pełna agenda z czasami, komendami i kryteriami „Gotowe, gdy…” jest w
[docs/00-agenda.md](docs/00-agenda.md).

### Układ repozytorium

```
szkolenie/
├── docs/                 # konspekt i kroki ćwiczeń (00..17)
├── scripts/              # gotowe komendy dla uczestników
├── setup.sh              # bootstrap klastra (rozdawany, gitignorowany)
├── snippets/             # fragmenty konfiguracji do wklejenia
├── docker/               # kontener testowy
├── .opencode/            # konfiguracja opencode warsztatu (commitowana)
├── examples/             # mini-projekt, demo injection, źródło do wiki
├── wiki/                 # korpus źródłowy (raw/) + wiki budowana w ćwiczeniu
├── trainer/              # materiały tylko dla prowadzącego
```

### Konfiguracja (w repo)

Konfiguracja z **wszystkimi modelami PLGrid** i agentami startowymi (`chat`,
`demo-vulnerable`) leży w [`.opencode/opencode.json`](.opencode/opencode.json), jest
**commitowana** i wczytuje się automatycznie, gdy opencode startuje z katalogu repo — na
klastrze.

### Narzędzie

Używamy wyłącznie **opencode** i modeli **PLGrid Forge** w ramach PLGrid — bez komercyjnych
kluczy API. Inne harnessy są poza zakresem warsztatu. Wersja to **opencode 2.1.3** — z modułu
`opencode/2.1.3` na klastrze.

---

## English

> A note on language: the workshop documentation in `docs/` is in Polish (an English version is
> in preparation). The rest of the repository — scripts, examples, comments — is in English.

Workshop repo for **24.11.2026, Krakow** (10:30–14:00). Participants get this repository on the
cluster and browse it on GitHub. Everything you need is here — you do not have to install
anything beyond an SSH client.

### How to read this repo

Every step has **three paths**:

> **🚀 Paste into opencode** — a ready-made prompt for the agent.
>
> **🚀 Type `!` and paste into opencode** — a ready-made shell command: type `!` in the opencode
> session, then paste the bare command (without `!`). **On the cluster this is the main way** —
> `/terminal` is flaky; locally you can use a separate terminal.
>
> **🛠️ Do it yourself (how it works)** — a precise description and the raw commands. For people
> who want to do something more creatively on their own.

**🚀 Paste into the terminal** appears only at the start, before opencode starts (SSH, `srun`,
`bash setup.sh`, `opencode auth login`). Changes to the opencode configuration (permissions,
skills, MCP, subagents) take effect **immediately, with no restart**.

**You do not edit files by hand.** You make changes with ready-made commands — so that
everything works even without knowing the terminal.

Tasks marked **⭐** are **extra, optional** — for people who move ahead faster. We describe them
in detail: what it is, how it works, how to add it, how to test it.

### Start

1. [Introduction](docs/01-wstep.md)
2. [Setup — connection and start](docs/02-setup.md)
3. Then — the following steps from the [Agenda](docs/00-agenda.md)

On the cluster the trainer hands out the **`setup.sh`** file. It sits in the **repository root**
and is **gitignored** — it is not committed to the repo. Run with `bash setup.sh`, it goes
through: Lmod modules → clone into `$SCRATCH/szkolenie` → port → `plgrid/…` models →
`opencode auth login plgrid` → start opencode. The `scripts/` directory holds only the
participant commands.

### Agenda (outline)

The full agenda with times, commands and "Done when…" criteria is in
[docs/00-agenda.md](docs/00-agenda.md).

### Repository layout

```
szkolenie/
├── docs/                 # outline and exercise steps (00..17)
├── scripts/              # ready-made commands for participants
├── setup.sh              # cluster bootstrap (distributed, gitignored)
├── snippets/             # configuration fragments to paste
├── docker/               # test container
├── .opencode/            # workshop opencode configuration (committed)
├── examples/             # mini-project, injection demo, source for the wiki
├── wiki/                 # source corpus (raw/) + the wiki built in the exercise
├── trainer/              # trainer-only materials
```

### Configuration (in the repo)

The configuration with **all PLGrid models** and the starter agents (`chat`,
`demo-vulnerable`) lives in [`.opencode/opencode.json`](.opencode/opencode.json), is
**committed** and loads automatically when opencode starts from the repo directory — on the
cluster.

### Tooling

We use only **opencode** and the **PLGrid Forge** models within PLGrid — no commercial API keys.
Other harnesses are out of scope for the workshop. The version is **opencode 2.1.3** — from the
`opencode/2.1.3` module on the cluster.
