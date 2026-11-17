# Kod — propozycja i review ⭐

[← Poprzednia: Kod — implementacja (build)](10-kod-implementacja.md) · [Agenda](00-agenda.md) · [Następna: Bezpieczeństwo →](12-bezpieczenstwo.md)

> ⭐ **Zadanie dodatkowe** — jeśli zostanie czas.

## Część 2 — zaproponuj, wybierz, zaimplementuj

Agent sam zaproponuje, co można dodać, **zapyta Cię o wybór** i dopiero wtedy zaimplementuje.
To narzędzie **question** — agent wyświetla opcje, a Ty wybierasz.

> 🚀 **Wklej do opencode:** agent `build`, wklej:

```text
Zaproponuj 4 różne nowe rzeczy, które można dodać do
examples/mini-projekt/app.py. Zadaj mi pytanie z tymi czterema opcjami
do wyboru, poczekaj na mój wybór i dopiero wtedy zaimplementuj wybraną.
Zachowaj styl istniejącego kodu.
```

Zobaczysz **cztery opcje do wyboru** — wybierz strzałkami. Po implementacji sprawdź działanie
(🚀 wpisz `!` i wklej komendę w opencode).

## Część 3 — review: znajdź i popraw błędy

Tu pokażemy, że agent potrafi **przejrzeć kod i znaleźć błędy**, których nie widać na
pierwszy rzut oka.

**1. Najpierw sam sprawdź.** Uruchom znowu komendy z początku i zapisz, które wyniki wydają Ci się
podejrzane (`median 1 2 3 4`? `count "Hello hello, hello"` z trzema różnymi słowami dla tego samego
słowa?).

**2. Review — agent czyta i zgłasza (nic nie zmienia).**

> 🚀 **Wklej do opencode:** agent `plan`, wklej:

```text
Zrób rewiev examples/mini-projekt/app.py i zgłoś błędy występujące w programie.
Zrób analizę czytając tylko ten plik.
Napisz komendy które spowodują błędy
```

Porównaj z tym, co zapisałeś — czego agent znalazł więcej, a czego brakuje?

**3. Poprawa — agent zmienia kod.**

> 🚀 **Wklej do opencode:** przełącz się (**Shift+Tab**) na agenta `build`, wklej:

```text
Popraw błędy znalezione w poprzednim kroku, jeden po drugim.
Przy każdej poprawce uruchom jej przykład z terminala i pokaż wynik.
```

**4. Zweryfikuj.** Uruchom te same komendy co na początku — podejrzane wyniki powinny zniknąć:

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py count "Hello hello, hello"
python3 examples/mini-projekt/app.py mode 1 2 2 3
```

Po poprawce: `median` zwraca `2.5`, `count` daje jedno `hello: 3` (w wersji startowej `Hello: 1`,
`hello,: 1`, `hello: 1` — trzy różne tokeny dla jednego słowa), `mode` zwraca `2` (bez zmian — to nie był błąd).

> 🛠️ **Zrób sam:** do review możesz też użyć podagenta read-only (⭐
> [Podagenci](15-podagenci.md)) albo poprosić o przegląd osobno **każdej funkcji** i porównać, 
> czy raporty się zgodzą.

## Jak wróć do stanu początkowego

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/reset-demo.sh
```

> 🛠️ **Zrób sam:** `reset-demo.sh` to `git restore examples/`. Możesz też cofnąć przez
> `/undo` w opencode — razem z plikami.

## Gotowe, gdy…

- agent zapytał Cię o wybór (4 opcje) i zaimplementował wybraną,
- **review** wypisało błędy brzegowe, a po poprawce komendy dają poprawne wyniki.

---

[← Poprzednia: Kod — implementacja (build)](10-kod-implementacja.md) · [Agenda](00-agenda.md) · [Następna: Bezpieczeństwo →](12-bezpieczenstwo.md)
