# Setup — połączenie i start

[← Poprzednia: Wstęp](01-wstep.md) · [Agenda](00-agenda.md) · [Następna: Teoria — czym jest chat →](03-teoria-chat.md)

Na szkoleniu pracujemy z klastra przez SSH — nic
nie instalujesz, agent działa na węźle obliczeniowym.

## Zanim zaczniesz

Potrzebujesz **własnego laptopa** i **klienta SSH**. Nic więcej — opencode i modele są
przygotowane na klastrze.

### Klient SSH

| System  | Co użyć                                                                |
|---------|------------------------------------------------------------------------|
| Windows | **Windows Terminal** z wbudowanym **OpenSSH** (albo MobaXterm / PuTTY) |
| Linux   | `ssh` z terminala                                                       |
| macOS   | `ssh` z Terminal.app                                                    |

Na Windows 10/11 `ssh` jest już obecny: otwórz Windows Terminal i wpisz `ssh <login>@…`.

> 🛠️ **Zrób sam:** sprawdź, czy masz SSH, wpisując `ssh -V`. Jeśli komenda nie istnieje,
> użyj MobaXterm.

### Konto na klastrze

- Konto zdolne zająć **węzeł obliczeniowy** (nie pracujemy na węźle logowania).
- Dane dostępowe dostaniesz na miejscu.

### Wygodne kopiowanie (zalecane)

opencode działa w pełnym ekranie i sam zarządza kopiowaniem:

- **Windows Terminal / PuTTY:** zaznaczaj z **Shiftem** (Shift + przeciągnięcie myszą),
  kopiuj `Ctrl+Shift+C`, wklejaj `Ctrl+V` (przeglądarka) lub `Ctrl+Shift+V` (terminal).
- **Terminale obsługujące OSC 52** (kitty, WezTerm, Alacritty, foot) kopiują wprost.

> 🚀 **Windows Terminal / PuTTY:** trzymaj **Shift** i zaznaczaj myszą; kopiuj `Ctrl+Shift+C`.


### Czego NIE potrzebujesz

- Dockera ani kontenera,
- instalowania opencode lokalnie,
- komercyjnych kluczy API — używamy modeli PLGrid Forge,
- umiejętności edycji plików — wszystkie zmiany robisz gotowymi komendami.

---

## Setup

### 1. Połącz się z klastrem

> 🚀 **Wklej do terminala:**

```bash
ssh <login>@ares.cyfronet.pl
```

Wpisz hasło. Jesteś na **węźle logowania** — tu wolno tylko przygotować pracę.

> Przy pierwszym
> logowaniu `ssh` pyta, czy zaufać kluczowi hosta — wpisz `yes`. Podczas wpisywania hasła nic
> nie pojawia się na ekranie; to normalne. Po zerwaniu połączenia sesja się kończy — zaloguj się
> ponownie i wykonaj `srun` jeszcze raz; pliki w `$HOME` i `$SCRATCH` zostają. Aby samemu
> opuścić węzeł, wpisz `logout` — wracasz na `login01`, a rdzenie zwalniają się dla innych.

### 2. Zajmij węzeł obliczeniowy

> 🚀 **Wklej do terminala:**

```bash
srun --partition=cpu --nodes=1 --ntasks=1 --cpus-per-task=6 --time=4:00:00 --pty bash -l
```

### 3. Uruchom skrypt prowadzącego

Uruchom go na **węźle obliczeniowym** (po `srun`) —
skrypt **`setup.sh`** - on sam przygotuje środowisko.

> 🚀 **Wklej do terminala:**

```bash
bash setup.sh
```

Plik od prowadzącego ma już wpisany adres repozytorium. Jeżeli skrypt zgłosi komunikat o `REPO_URL`, poproś prowadzącego o poprawny plik.

Skrypt robi po kolei:

| # | Krok | Co się dzieje |
|---|------|---------------|
| 1 | Moduły Lmod | `module load python/3.13.5-gcccore-14.3.0 nodejs/22.17.1-gcccore-14.3.0 opencode/2.1.3` |
| 2 | Clone | `git clone` repozytorium do `$SCRATCH/szkolenie` |
| 3 | Port | `opencode service set port "$(bash scripts/port-helper.sh print)"` — port bazowy to `40000 + UID % 20000`, a gdy jest zajęty, helper sprawdza `bind` na `localhost` i wybiera losowy wolny port z `8000-9999` |
| 4 | Modele | sprawdza, że `opencode models` wypisuje modele `plgrid/…` |
| 5 | Logowanie | `opencode auth login plgrid`  |
| 6 | Start | `cd $SCRATCH/szkolenie` i uruchamia `opencode` |

Katalog docelowy to `$SCRATCH/szkolenie`, a gdy `$SCRATCH` nie jest ustawiony — `$HOME/szkolenie`.

## Test — pierwsze pytanie

> 🚀 **Wklej do opencode:** dowolne pytanie, np.:

```text
Napisz jednym zdaniem, co to jest opencode.
```

Potwierdzeniem sukcesu jest **odpowiedź od modelu**. Jeśli jej nie ma — wróć do sekcji [Setup](#setup).

## Gotowe, gdy…

- jesteś połączony przez SSH,
- widzisz modele `plgrid/…`,
- zadałeś pytanie w opencode i dostałeś odpowiedź.

---

[← Poprzednia: Wstęp](01-wstep.md) · [Agenda](00-agenda.md) · [Następna: Teoria — czym jest chat →](03-teoria-chat.md)
