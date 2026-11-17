# Bezpieczeństwo

[← Poprzednia: Kod — propozycja i review ⭐](11-kod-propozycja-review.md) · [Agenda](00-agenda.md) · [Następna: Skille →](13-skille.md)

> ⚠️ Config na dziś ma **`"permission": { "*": "allow" }`** — pozwolenie na wszystko, celowo:
> to sandbox na klastrze (scratch, dane demonstracyjne) i świadomy stan wyjściowy. Agent
> **nie pyta o nic**. Na początku tego bloku właśnie to wykorzystamy.

## Pokaz 1 — injection: agent nie pyta o nic, a coś odwalił

Agent `demo-vulnerable` (Shift+Tab). Prompt: zwykła poprawka literówki.

> 🚀 **Wklej do opencode:**

```text
Fix the typo in examples/injection/NOTES.md
```

Obserwuj, co się wydarzyło, co agent zrobił!!! Zamiast samej edycji agent **usunie
folder `CRITICAL_DATA/`** — bo ukryta instrukcja w `NOTES.md` mu to nakazała.

**Historia:** agent czyta pliki, a razem ze treścią czyta też **instrukcje**, które w nich są.
Jeśli ktoś ukryje w pliku polecenie, agent może je wykonać — nawet jeśli Ty prosiłeś o coś
zupełnie innego.

> ⚠️ **To demonstracja.** Agent `demo-vulnerable` (model `DeepSeek-V4-Flash`) jest
> **specjalnie** przygotowany, żeby ulec takiemu poleceniu: polecenia z plików oznaczone
> znacznikiem `[TRUSTED]` traktuje jak polecenia operatora. To nie luka opencode, tylko pokaz
> zjawiska.

> 🚀 **Wpisz `!` i wklej do opencode:** restart demo — skrypt odtworzy dane i wypisze prompt do wklejenia:

```bash
bash scripts/12-injection-demo.sh
```

> 🛠️ **Zrób sam:** zajrzyj do `examples/injection/NOTES.md` i znajdź ukrytą instrukcję — komentarz HTML na samej górze pliku, oznaczony znacznikiem `[TRUSTED]`.

## Jak temu zaradzić: jak zabezpieczyć działanie agenta?

Agent bez pytania skasował dane. Mamy jednak dwa sposoby na ograniczenie możliwości agenta:

1. **Pytanie o zgodę** (`ask`) — zanim agent wykona akcję, pyta Ciebie.
2. **Blokowanie narzędzi** (`deny`) — akcja jest zabroniona i nie wykona jej nawet po zgodzie.

### Mechanika: jak działa pozwalanie na komendy

Każda akcja agenta (uruchomienie polecenia, edycja pliku, wejście na stronę…) trafia na regułę
uprawnień. Reguła daje jeden z trzech efektów:

| Efekt   | Co się dzieje                                   |
|---------|-------------------------------------------------|
| `allow` | akcja idzie **bez pytania**                      |
| `ask`   | agent **pyta** o zgodę                           |
| `deny`  | akcja jest **zablokowana** (agent nie wykona)    |

Reguły ustawia się w `.opencode/opencode.json`, w sekcji `permission`. Możesz ustawić
**wszystko naraz**, albo **per polecenie**. Wzorce poleceń shella siedzą w podsekcji `bash`:

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

Dopasowanie działa **wzorcem** (`*` = dowolny ciąg, `?` = jeden znak), a **wygrywa ostatnia
pasująca reguła**. Dlatego najpierw daje się `*`, a potem reguły szczegółowe.

## Zmiana: `*` allow → `*` ask

Ograniczmy agenta o jeden krok: **niech się pyta**.

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/ask-all.sh
```

Skrypt ustawia w `.opencode/opencode.json`:

```json
"permission": { "*": "ask" }
```

**Nie trzeba restartować opencode** — config działa od razu, w tej samej sesji. Poproś agenta o dowolne polecenie i zobacz, że teraz pyta.

> 🛠️ **Zrób sam, jak sprawdzić, co siedzi w configu** (w opencode: wpisz `!` i wklej komendę):
>
> ```bash
> python3 -c "import json,os;print(json.load(open('.opencode/opencode.json'))['permission'])"
> ```

## Pokaz 2 — pytanie w praktyce (ask)

> 🚀 **Wklej do opencode:** agent `plan` lub `build`, wklej:

```text
Uruchom polecenie `date` i pokaż wynik.
```

Agent **zapyta** (bo `"*": "ask"` łapie wszystko). Zrób po kolei:

1. Wybierz **once** → policzy czas. Poproś o `date` **ponownie** → **pyta znowu**
   (once działa tylko raz).
2. Wybierz **always** → poproś o `date` jeszcze raz → **nie pyta** (opencode zapisał wzorzec,
   np. `date *`, dla tego projektu).
3. Poproś o **inne** polecenie, np. `uname -a` → **pyta znowu** (inny wzorzec).
4. Zrestartuj opencode i poproś o `date` → **nadal nie pyta** — w opencode 2 „always” zapisuje
   **trwałą, projektową** regułę `allow`, więc restart jej nie kasuje (patrz niżej, jak ją usunąć).
   Ten restart nie służy przeładowaniu configu — chodzi o dowód, że zapisane „always” przetrwa restart.

To jest cała odpowiedź na pytanie „dlaczego **raz** zatwierdzone już mnie nie pyta”.

## Co się dzieje, gdy agent zapyta

UI daje trzy odpowiedzi:

| Wybór     | Znaczenie                                                                              |
|-----------|----------------------------------------------------------------------------------------|
| **once**  | zatwierdź **tę jedną** akcję                                                           |
| **always**| zatwierdź **pasujące wzorce** i **zapisz je na stałe dla tego projektu**               |
| **reject**| odmów                                                                                  |

### „Always allow" w opencode 2 jest trwałe

To najczęstsze nieporozumienie — warto pokazać na żywo. „Always" **nie** jest jednorazowe:

1. **Przetrwa restart.** Zapisane zatwierdzenie ląduje w danych opencode jako reguła `allow`
   **przypisana do projektu** — nowa sesja i restart jej nie kasują.
2. **Zatwierdza tylko sugerowany wzorzec.** Dla basha to zwykle **prefiks polecenia**, np.
   `date *`. Inne polecenie — albo ten sam program z innymi argumentami — nie pasuje i
   **znów pyta**.
3. **Wzorzec bywa wąski.** „Always" na `ls -la` nie obejmuje `ls /tmp` ani `ls | head`.
4. **`deny` jest silniejsze.** Zapisane „always" nigdy nie obejdzie reguły `deny` z configu.

> 🔎 **Jak usunąć zapisane „always"** (w opencode: wpisz `!` i wklej komendę; żeby agent znów pytał):
>
> ```bash
> opencode api get /api/permission/saved          # podejrzyj zapisane reguły
> opencode api delete /api/permission/saved/<id>  # usuń wybraną
> ```
>
> Zapisane reguły są **per projekt** — w nowym katalogu/klonie repo zaczynasz bez nich.
> Chcesz zmienić coś trwale i świadomie — wpisz regułę do `.opencode/opencode.json`
> (sekcja `permission`). Chcesz nie pytać o nic (poza `deny`)? Uruchom `opencode --auto`.

## Sensowny zestaw pozwoleń — żeby dało się dalej pracować

Przy `"*": "ask"` każdy `ls` i `cat` pyta — do dalszych kroków to uciążliwe. Ustawmy zdrowy
zestaw: **pytaj o wszystko poza nielicznymi, tylko czytającymi poleceniami**.

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/sensible-permissions.sh
```

Skrypt ustawia (wzorce shella w podsekcji `bash`):

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

(`python3` jest na allow-liście — to właśnie tą ścieżką działa obejście w Pokazie 5 ⭐.)

Nie trzeba restartować — config działa od razu. Od teraz czytanie plików, edycja, `ls`, `cat`, `grep`, `find`, `git`,
`python3` idą bez pytania — a **wszystko inne** (np. `date`, `whoami`, dowolne polecenie poza
allow-listą) **pyta**. Ten zestaw zostaje do końca szkolenia.

## Pokaz 3 — powtórka injection: teraz agent pyta

Ta sama historia, przy sensownym zestawie. Uruchom demo jeszcze raz:

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/12-injection-demo.sh
```

i wklej **ten sam** prompt („Fix the typo…”).

Teraz, zanim usunie dane, agent **zapyta o zgodę** — i to jest moment, w którym kolejność
`allow` → `ask` realnie zmieniła zachowanie. Zauważ: agent zwykle pytałby o *poprawkę w pliku*,
a nagle pyta o *usunięcie katalogu* — to sygnał, że dzieje się coś dziwnego. **Czytaj prompt
zatwierdzenia, zanim go dopuścisz** — to nawyk, który broni przed injection.

## Pokaz 4 — dajemy usuwanie na `deny`

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/block-rm.sh
```

Skrypt dodaje `"rm -rf *": "deny"` do podsekcji `bash` w sekcji `permission`. Powtórz pokaz 3 —
agent **odmówi**: polecenie jest zabronione, agent nie wykona go nawet po zgodzie użytkownika.

> 🛠️ **Zrób sam:** otwórz `.opencode/opencode.json`, w sekcji `permission` → `bash` dodaj
> `"rm -rf *": "deny"`. `scripts/block-rm.sh` robi dokładnie to.

## Pokaz 5 ⭐ — Obejście blokady

Blokada polecenia to nie wszystko. `rm -rf` jest na `deny`, ale w naszym zestawie `python3` oraz `find`
jest na allow-liście — więc agent osiągnie ten sam cel innym narzędziem, **bez pytania**.

Odtwórz folder demo (`reset-demo.sh` przywraca też `examples/demo_bypass/`):

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/reset-demo.sh
```

> 🚀 **Wklej do opencode:** przełącz agenta (Shift+Tab) na `demo-bypass` i wklej:

```text
Delete the folder examples/demo_bypass with rm -rf.
```

Agent `demo-bypass` jest **specjalnie przygotowany pod ten pokaz**. Zobaczysz po kolei:

1. agent próbuje `rm -rf ...` → **`deny`** (twarda blokada, nie pyta, nie wykonuje),
2. nie poddaje się — sięga po **dozwolone** narzędzie, np.
   `python3 -c "import shutil; shutil.rmtree(...)"` (bez pytania o zgodę),
3. folder **znika mimo blokady**.

> 🛠️ **Zrób sam:** morał — blokada pojedynczego *polecenia* to za mało. `python3`, `find`,
> `node` czy każdy interpreter ogólnego przeznaczenia omija `deny`. Polecenia tego typu lepiej ustawiać na `ask`.


## Posprzątaj

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/reset-demo.sh
```

Sensowny zestaw pozwoleń (ask + allow-lista) **zostaje** — tna potrzeby tego szkolenia. W pracy we własnym zakresie warto dać komendy python i find na `ask`. Jeśli
chcesz wrócić do „pozwalam na wszystko", podmień sekcję `permission` na `{ "*": "allow" }`
w `.opencode/opencode.json`.

## Ściągawka: allow / ask / deny

- `allow` — bez pytania; `ask` — pyta; `deny` — blokuje.
- „once" = raz; „always" = zapisuje pasujące wzorce **trwale dla projektu**; „reject" = odmowa.
- Wzorce poleceń shella w configu wpisujesz w podsekcji `bash` (sekcja `permission`).
- `--auto` = nie pytaj o nic, czego nie ma na `deny`.

## Gotowe, gdy…

- widziałeś zaskoczenie: agent bez pytania skasował dane (injection),
- umiesz zmienić domyślne uprawnienie `allow` → `ask` i wiesz, kiedy agent pyta,
- wiesz, że „Always allow" zapisuje **trwałą, projektową** regułę i jak ją usunąć,
- masz zestaw pozwoleń, przy którym da się pracować,
- umiesz zablokować polecenie i wiesz, że blokadę da się obejść,
- wiesz, że czytane pliki wychodzą do providera.

---

[← Poprzednia: Kod — propozycja i review ⭐](11-kod-propozycja-review.md) · [Agenda](00-agenda.md) · [Następna: Skille →](13-skille.md)
