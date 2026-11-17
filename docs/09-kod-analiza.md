# Kod — analiza (plan)

[← Poprzednia: Agent plan — odpowiedź, której chat nie umiał](08-agent-plan.md) · [Agenda](00-agenda.md) · [Następna: Kod — implementacja (build) →](10-kod-implementacja.md)

## Od wzbogacania kontekstu do zmieniania plików

Do tej pory poznaliśmy, że agent **ma oczy** — czyta pliki, uruchamia polecenia, sięga po sieć.
Dzięki temu **wzbogaca kontekst o wiedzę**.

Pracujemy na miniaturowym programie: `examples/mini-projekt/app.py` — małym
zestawie narzędzi statystyczno-tekstowych. Najpierw go obejrzymy i zlecimy analizę.

## Zobacz program

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
python3 examples/mini-projekt/app.py average 1 2 3
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py mode 1 2 2 3
python3 examples/mini-projekt/app.py count "Hello hello, hello"
```

Program ma komendy: `average`, `median`, `mode`, `count`.

> **Ten kod celowo ma dwa błędy brzegowe** — nic się nie wysypuje, ale niektóre wyniki są złe.
> Wrócimy do tego w części 3.

## Niech agent wyjaśni kod

> 🚀 **Wklej do opencode:** agent `plan`:

```text
Wyjaśnij, jak działa examples/mini-projekt/app.py: co robią poszczególne komendy
i jak liczony jest każdy wynik. Na koniec podaj jedną komendę, którą mogę wkleić
w opencode, żeby zobaczyć działanie programu (poprzedzając ją znakiem !).
```

Potem **uruchom pokazaną komendę w opencode** (najpierw wpisz `!`, potem wklej komendę) i zobacz wynik — tak agent „ma oczy”: czyta kod i podaje Ci gotowe polecenie.

### Ale fajnie, jakby agent mógł coś sam dodać....

> 🚀 **Wklej do opencode:** agent `plan`, wklej:

```text
W pliku examples/mini-projekt/app.py dodaj nową komendę `p95 <liczby>`,
która oblicza 95. percentyl podanych wartości.
```

Zobaczysz, że `plan` **tego nie zrobi** — brakuje mu narzędzia `edit`. Nie zgaduje i nie
wymyśli wyniku: albo odpowie wprost, że nie może, albo przedstawi plan bez implementacji.

## Gotowe, gdy…

- agent wyjaśnił kod i dał komendę do uruchomienia w opencode (przez `!`),
- widziałeś, że `plan` **nie zmienia** plików (brak narzędzia `edit`).

---

[← Poprzednia: Agent plan — odpowiedź, której chat nie umiał](08-agent-plan.md) · [Agenda](00-agenda.md) · [Następna: Kod — implementacja (build) →](10-kod-implementacja.md)
