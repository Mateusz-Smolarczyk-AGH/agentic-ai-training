# Kod — implementacja (build)

[← Poprzednia: Kod — analiza (plan)](09-kod-analiza.md) · [Agenda](00-agenda.md) · [Następna: Kod — propozycja i review ⭐ →](11-kod-propozycja-review.md)

Teraz dajemy agentowi **ręce** — `build` to ten sam agent, ale z narzędziem edycji; on
**wprowadza zmiany**.

> „Agent może zmieniać pliki" nie znaczy „każdy agent". To kwestia **konkretnego narzędzia i
> uprawnienia**.

### build zmienia plik

> 🚀 **Wklej do opencode:** przełącz się (**Shift+Tab**) na agenta `build` i wklej **to samo**
> polecenie.

```text
W pliku examples/mini-projekt/app.py dodaj nową komendę `p95 <liczby>`,
która oblicza 95. percentyl podanych wartości.
```

`build` poprosi o zgodę na **edycję** — zatwierdź i zobacz gotową zmianę. Potem sprawdź:

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
python3 examples/mini-projekt/app.py p95 10 20 30 40 50
python3 examples/mini-projekt/app.py median 10 20 30 40 50
```

Wynik `p95` powinien być **między medianą (30) a maksimum (50)**, bliżej maksimum — a `median`
już wcześniej zwracał `30`. Widzisz oba: plan **co najwyżej opisuje**, build **zmienia kod**.

## Gotowe, gdy…

- `build` dodał komendę `p95`,
- wynik `p95` jest między medianą a maksimum.

---

[← Poprzednia: Kod — analiza (plan)](09-kod-analiza.md) · [Agenda](00-agenda.md) · [Następna: Kod — propozycja i review ⭐ →](11-kod-propozycja-review.md)
