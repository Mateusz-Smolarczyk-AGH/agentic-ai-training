# Skille

[← Poprzednia: Bezpieczeństwo](12-bezpieczenstwo.md) · [Agenda](00-agenda.md) · [Następna: MCP ⭐ →](14-mcp.md)

## Czym jest skill

Skill to **instrukcja na żądanie** w pliku `SKILL.md`. Ładuje się tylko wtedy, gdy jest
potrzebna — dlatego nie zajmuje kontekstu bez powodu. Mówi agentowi **jak** wykonać klasę
zadań: kroki, warunki, format wyniku, pułapki.

Skill leży w repozytorium, jest wersjonowany i działa w każdej sesji.

## Gdzie leży skill

Projektowe skille opencode odkrywa **automatycznie** w:

```text
.opencode/skills/
└── <id>/
    └── SKILL.md
```

`<id>` to nazwa katalogu (np. `monthly-report`) — po niej wywołujesz skill. Frontmatter
`name` to tylko etykieta. Obok `SKILL.md` możesz trzymać `scripts/` i `references/`.

## Test „przed”

Mamy plik `examples/finance/transactions.csv` — przychody i koszty w **PLN, EUR, USD i GBP**.
Agent ma zrobić z tego **miesięczny raport finansowy**. Haczyk: bez instrukcji model nie wie,
że trzeba (a) **sprawdzić aktualne kursy w sieci** i (b) **przeliczyć wszystko na złotówki**,
ani jak ma wyglądać wynik.


> 🚀 **Wklej do opencode:** agent `build`, ZMIEŃ MODEL na **Qwen3.6 35B A3B**, wklej:
```text
Przygotuj miesięczny raport finansowy z pliku examples/finance/transactions.csv.
```

Agent „coś” wyrzuci — ale zwykle nie pobierze kursów, nie przeliczy walut (albo policzy je
osobno) i nie trzyma się żadnego formatu.

## Dodaj skill

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/apply-skill.sh
```

Skrypt tworzy `.opencode/skills/monthly-report/SKILL.md` — skill, który opisuje **cały
workflow** i wymusza **zasadę**: przelicz każdą kwotę na PLN po **aktualnym kursie średnim
NBP** pobranym przez `webfetch`, a na końcu daj raport w ustalonym formacie.

> 🛠️ **Zrób sam:** utwórz plik `.opencode/skills/monthly-report/SKILL.md`:

````markdown
---
name: Monthly report
description: Builds a monthly financial report (revenue, costs, result, margin) from multi-currency data, converting every amount to PLN at current NBP rates. Use when asked for a financial report, a spending and profit summary, or a monthly close.
---

# Monthly report

## Workflow
1. Load the data; split income from costs.
2. Sum amounts separately in each currency.
3. RULE: convert every non-PLN amount to PLN at the current average rate of NBP table A, fetched
   with `webfetch` from `https://api.nbp.pl/api/exchangerates/tables/A/?format=json`.
   Never convert from memory.
4. Compute the result and the margin.
5. Build the report in the required format.

## Format
```
# Monthly report: <month YYYY>
## Summary
- Revenue: <P> PLN
- Costs: <K> PLN
- Result: <P−K> PLN (margin <m>%)
## NBP rates (table A, <published date>)
| Currency | Average rate (PLN) |
## Costs by category (PLN)
| Category | Cost (PLN) |
## Recommendation
- <one sentence>
```

## Pitfalls
- Convert to PLN first, only then sum.
- Rates must come from NBP (current); include the table date. If there is no network, say so instead of guessing.
````

Po dodaniu skill pojawia się **od razu** — nie trzeba przeładowywać ani restartować opencode. Wywołaj go w tej samej sesji.

## Test „po”
Przejdź do nowej sesji.
> 🚀 **Wklej do opencode:** wklej **to samo** zadanie co w teście „przed”

Teraz agent przechodzi workflow: **pobiera aktualne kursy NBP przez `webfetch`**, **przelicza
EUR/USD/GBP na złotówki**, pokazuje użyte kursy z datą tabeli i zwraca raport w ustalonym
formacie (podsumowanie, kursy, koszty wg kategorii, rekomendacja). To jest cała różnica: skill
wymusza *sprawdzenie kursów i przeliczenie*, które model sam by pominął.


## AGENTS.md — instrukcje „na stałe”, nie na żądanie ⭐

Skill ładuje się **na żądanie**. Jest drugi mechanizm: **`AGENTS.md`** — plik, który opencode
wczytuje **zawsze, od razu, do każdej sesji**. Nie trzeba go wywoływać.

| | Skill (`SKILL.md`) | `AGENTS.md` |
|---|---|---|
| Kiedy trafia do kontekstu | gdy agent po niego sięgnie | **zawsze** |
| Po co | „jak zrobić klasę zadań” | stałe reguły projektu |
| Gdzie | `.opencode/skills/<id>/` | katalog projektu (i podkatalogi) |

`AGENTS.md` w katalogu projektu (oraz zagnieżdżone — ładowane, gdy agent wchodzi w podkatalog)
opisuje: komendy build/test, konwencje, architekturę, czego nie ruszać. Globalny leży w
`~/.config/opencode/AGENTS.md`.

Przykład `AGENTS.md`:

```markdown
# Instrukcje projektu

- Po zmianie Pythona uruchom `python3 examples/mini-projekt/app.py`.
- Dane demonstracyjne trzymamy w `examples/`.
- Nie edytuj plików w `generated/`.
```

> ⭐ **Zrób sam — wygeneruj `AGENTS.md` przez `/init`:** w opencode wpisz `/init`. To
> prowadzony tryb, w którym agent przeanalizuje repozytorium i zaproponuje `AGENTS.md`
> (build, testy, układ katalogów). Przyjmij propozycję, potem **dopisz własną regułę** i
> zobacz, że działa od razu — edycje `AGENTS.md` są wykrywane w locie, bez restartu.

## Gotowe, gdy…

- bez skilla agent zrobił raport „po swojemu”, bez kursów i bez przeliczenia walut,
- ze skillem pobrał kursy NBP, przeliczył na PLN i trzymał się formatu,
- wiesz, że projektowe skille leżą w `.opencode/skills/<id>/SKILL.md`,
- dodałeś własny skill (sam albo z agentem) i go wywołałeś,
- odróżniasz skill (na żądanie) od `AGENTS.md` (zawsze w kontekście),
- wiesz, że `/init` potrafi napisać `AGENTS.md` za Ciebie.

---

[← Poprzednia: Bezpieczeństwo](12-bezpieczenstwo.md) · [Agenda](00-agenda.md) · [Następna: MCP ⭐ →](14-mcp.md)
