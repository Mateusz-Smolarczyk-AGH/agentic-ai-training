# Research agentowy — jak wykorzystać agentów w research

[← Poprzednia: Podagenci ⭐](15-podagenci.md) · [Agenda](00-agenda.md) · [Następna: Własna baza wiedzy (LLM Wiki) →](17-llm-wiki.md)

W tym ćwiczeniu zajmiemy się researchem wspieranym agentem. Agent będzie miał na celu znalezienie kilku artykułów na dany temat spełniających podane przez nas kryteria i zapisanie ich lokalnie do katalogu `wiki/llm-wiki/raw/`. W tym bloku robimy to
**wyłącznie promptem** — bez skilla i bez dodatkowych narzędzi. Do właściwego research warto wspomagać się gotowymi narzędziami (jak np. paper-search). Na potrzeby tego ćwiczenia jednak z nich zrezygnowano. Tutaj tylko pobieramy pliki - nie robimy ich pełnej analizy. Ten krok będzie w następnym punkcie szkolenia.


## Research tylko na podstawie promptu

W tym bloku research to **prompt i nic więcej** — bez skilla, bez `paper-search` i innych
zewnętrznych narzędzi. Wystarczą **wbudowane narzędzia agenta**:

- `webfetch` — strona wyszukiwania, API arXiv, treść bloga/dokumentacji,
- `bash` (`curl`) — pobranie PDF-a i zapytania do API arXiv,
- `read` / `write` — zapis oczyszczonego `.md` w `raw/`.

Prompt to cały „program” researchu: mówi, ile materiałów zebrać, gdzie je zapisać i jak je nazwać.

## Pętla Research Scouta

1. **KROK 0 — podział tematu** na 3–5 podtematów, które razem go pokrywają.
2. **Wyszukiwanie** — arXiv, repozytoria techniczne, blogi inżynieryjne.
3. **Pobieranie** — sekwencyjne, **jedno źródło po drugim** (jedna sesja, bez delegowania).
4. **Weryfikacja** — czy plik istnieje i ma sens (PDF > 50 KB).
5. **Raport** — co zapisano (nazwa, rozmiar, URL) i czego brakuje.

## Jak wygląda prompt

Prompt (pełna treść w ćwiczeniu poniżej) niesie reguły:

- źródła przede wszystkim z **2026** (SOTA); starsze tylko jako cytowany fundament,
- łącznie **4–8 materiałów** (prace naukowe + kluczowe wpisy inżynieryjne),
- prace naukowe jako **oryginalny `.pdf`**, rozmiar **> 50 KB**,
- treści HTML jako **oczyszczony `.md`**,
- nazwy plików `slug-nazwa`, **każdy plik = jedno źródło**.

## Pułapki

- **Marketing i powierzchowne wpisy** — odrzucaj; liczy się treść techniczna, nie landing page.
- **„Puste”/zepsute PDF-y** — dlatego kontrola rozmiaru (> 50 KB); brak pliku zgłoś wprost.
- **Wymyślone linki/DOI** — model potrafi „dopisać” cytat; weryfikuj każdy URL.
- **Mieszanie researchu z syntezą** — w tym bloku **tylko pobieramy**; streszczanie i strony wiki
  to osobny blok.

## Ćwiczenie — research na żywo

> 🚀 **Wklej do opencode:** agent `build`, wklej:

```text
Jesteś autonomicznym agentem badawczym (Research Scout). Twoim jedynym zadaniem jest
zidentyfikowanie najlepszych technicznych źródeł na podany temat i fizyczne pobranie ich do
katalogu `wiki/llm-wiki/raw/`.

Topic: LLM Wiki / agent-native wikis and knowledge bases for LLMs — SOTA 2026: capabilities, advantages and limitations, comparison with RAG (GraphRAG, agentic retrieval, long context, agent memory)

KRYTERIA ZASOBÓW — łącznie 4-8 materiałów:
1. Prace naukowe / whitepapery: MUSZĄ być zapisane jako oryginalny plik `.pdf`.
2. Kluczowe wpisy inżynieryjne / dokumentacja: pobrane i zapisane jako oczyszczony `.md`.

KRYTERIA CZASOWE:
- Prace przede wszystkim z 2026 roku (SOTA). Minimum 4 z 4-8 materiałów muszą być z 2026.
- Starsze (2020-2024) tylko jako fundament cytowany przez nowsze prace, oznaczone jako
  „klasyk/referencja" — nie więcej niż 1-2.

KROK 0 — Podział tematu:
- Rozbij temat na 3-5 podtematów, które razem go pokrywają.
- Wypisz plan (podtematy + po jednym zdaniu, czego w każdym szukasz).
- Pobieraj źródła PO KOLEI, jedno po drugim (jedna sesja, bez delegowania).

KROK 1 — Inicjalizacja:
- Upewnij się, że katalog `wiki/llm-wiki/raw/` istnieje; jeśli nie, utwórz go (`mkdir -p`).

KROK 2 — Wyszukiwanie i selekcja:
- Szukaj na arXiv, w repozytoriach technicznych i na blogach inżynieryjnych.
- Użyj `webfetch` na stronach wyszukiwania oraz API arXiv przez `bash`, sortując po dacie:
  `curl -sk "https://export.arxiv.org/api/query?search_query=all:%22<fraza>%22&sortBy=submittedDate&sortOrder=descending&max_results=20"`,
  i bierz najnowsze z 2026 (rok potwierdź w polu `<published>`).
- Odrzuć materiały czysto marketingowe i powierzchowne wpisy.
- Wybierz najbardziej przełomowe pozycje i przypisz każdą do podtematu.

KROK 3 — Pobieranie:
- Prace naukowe (PDF): ustal bezpośredni link do pliku (dla arXiv zamień `/abs/` na `/pdf/`
  i dodaj `.pdf`), potem: `curl -L -o wiki/llm-wiki/raw/<slug>.pdf "URL"`.
  Sprawdź, że plik istnieje i ma rozmiar > 50 KB.
- Blogi / dokumentacja (HTML): pobierz treść (`webfetch`) i zapisz jako oczyszczony Markdown
  w `wiki/llm-wiki/raw/<slug>.md`.

KROK 4 — Weryfikacja i raport:
- Wypisz, co zapisałeś: dla każdego pliku nazwę, rozmiar i źródłowy URL.
- Jeśli czegoś nie udało się pobrać — powiedz wprost, którego źródła brakuje i dlaczego.
- NIE streszczaj i NIE buduj stron wiki — tylko pobierz pliki.

Zasady: każdy plik w `raw/` to jedno źródło; nie wymyślaj źródeł ani linków; nazwy plików
w formacie `slug-nazwa` (małe litery, myślniki).
```

> 🎓 **Prowadzący omawia:** patrzymy, jak agent dzieli temat na podtematy, czym szuka
> (`webfetch`/`curl`), jak weryfikuje rozmiar plików i raportuje braki.

> 🛠️ **Zrób sam:** podmień temat na **własny**; możesz też wskazać inne źródła.

> ⭐ **Skala:** przy większym researchu dzieli się podtematy między **równoległe podagenty**
> (blok [Podagenci](15-podagenci.md)); w warsztacie robimy to sekwencyjnie.

## Wynik → wejście do następnego bloku

`wiki/llm-wiki/raw/` (PDF + `.md`) staje się źródłem dla bloku **LLM Wiki**
([Własna baza wiedzy (LLM Wiki)](17-llm-wiki.md)). Research zbiera materiał, wiki go destyluje.

## Gotowe, gdy…

- agent pokazał podział na podtematy,
- w `wiki/llm-wiki/raw/` jest 4–8 plików źródeł,
- każdy plik ma źródłowy URL, a braki są nazwane wprost.

---

[← Poprzednia: Podagenci ⭐](15-podagenci.md) · [Agenda](00-agenda.md) · [Następna: Własna baza wiedzy (LLM Wiki) →](17-llm-wiki.md)
