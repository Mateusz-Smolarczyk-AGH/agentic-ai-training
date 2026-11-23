# Własna baza wiedzy (LLM Wiki)

[← Poprzednia: Podagenci ⭐](15-podagenci.md) · [Agenda](00-agenda.md) · [Następna: Instalacja lokalna →](17-instalacja-lokalna.md)

## Krok 1 — tworzenie wiki

> 🚀 **Wklej do opencode:** agent `build`, wklej:

```text
Zbuduj wiki `llm-wiki` w katalogu ./wiki/llm-wiki/ na podstawie danych w /raw
Tryb raw-only, język pl.
```
Następnie agent będzie tworzył wiki. W naszym przypadku ze względu na to, że 20 uczestników spotkania na raz korzysta z tego nie delegujemy zadania tworzenia wiki do podagentów. Jednak pracując samemu warto pozwolić agentowi równolegle delegować zadania do wielu podagentów - przyspiesza to pracę.

Korpus wejściowy jest już przygotowany w `wiki/llm-wiki/raw/` — prace naukowe i wpisy inżynieryjne o „LLM Wiki / agent-native wikis vs RAG" — więc osobny krok researchu nie jest potrzebny.

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
ls -R wiki/llm-wiki
```

Zobaczysz `AGENTS.md`, `raw/` i `wiki/` (z `index.md` i `log.md`).

## Krok 2 — czym jest LLM Wiki

**LLM Wiki** to lokalna baza wiedzy w formacie **OKF** (Open Knowledge Format): strony markdown
z frontmatterem YAML, plus `index.md` i `log.md`. Agent kuratoruje ją skillem `llm-wiki`.

Każda wiki ma `AGENTS.md` (tożsamość i reguły), `raw/` (dokumenty źródłowe) i `wiki/` (bundel OKF).

Jest to baza wiedzy budowana na podstawie plików z folderu /raw. To mogą być artykuły, dokumentacja - cokolwiek. Na podstawie tego agent tworzy wiki - gdzie każda strona to pojedynczy koncept - a koncepty połączone są ze sobą. 

### LLM Wiki a RAG

| | RAG | LLM Wiki |
|---|---|---|
| Kiedy powstaje wiedza | przy każdym zapytaniu | raz, przy budowie wiki |
| Co jest w bazie | fragmenty tekstu w indeksie/wektorach | skuratorowane strony koncepcyjne |
| Wyszukiwanie | podobieństwo | po stronach, katalog w `index.md` |
| Odpowiedź | składana doraźnie z fragmentów | cytuje strony wiki |
| Struktura i pochodzenie | brak, „surowy” tekst | pierwszej klasy (`sources`, linki) |
| Format wyniku | wektory (nieczytelne dla człowieka) | markdown: czytelny, diffowalny, wersjonowalny |
| Infrastruktura | baza wektorowa + pipeline | brak, wystarczy katalog |

Oba odpowiadają z Twoich dokumentów. Wiki dokłada **kurację, strukturę i możliwość
prześledzenia źródła**; RAG — szybkie dopasowanie fragmentów.

## Krok 3 — pokaz: bez wiki vs z wiki

Wiki powstaje **na żywo**, więc pytania mamy przygotowane z góry — ale **pod ten korpus**. Każde
pytanie wymaga **złożenia faktów z kilku różnych artykułów** i to jest sedno pokazu: strona
koncepcyjna wiki robi dokładnie to — scala wiedzę z kilku źródeł w jedno miejsce. W żadnym
pojedynczym pliku `raw/` nie ma całej odpowiedzi, więc tryb „bez wiki" musi przekopać kilka PDF-ów
i posklejać fakty; tryb „z wiki" czyta **jedną stronę**, która już to zrobiła. Odpowiedź ma być
**krótka (jedno zdanie)**. Porównujemy nie treść odpowiedzi, a **drogę do informacji**: co agent po
kolei zrobił (lista `tool call`), ile go to kosztowało i jak szybko da się potem tę odpowiedź sprawdzić.

> 🚀 **Najpierw przełącz model:** `/models` → `plgrid/Qwen/Qwen3.6-27B` (mały, ale sprawnie
> używa narzędzi). Ten sam model zostaje dla obu przebiegów.

### Pytania (wybierz jedno)

Pytania są dobrane pod **ten** korpus: odpowiedź każdego powstaje ze złożenia faktów z kilku
artykułów, a robi to strona koncepcyjna wiki. Odpowiedź zawsze **jedno zdanie**.

| Pytanie |
|---|
| Dlaczego samo wyszukiwanie podobieństwem nie wystarcza w dużym korpusie i co je uzupełnia? |
| Jakie różne ograniczenia RAG ujawniają niezależne prace i co je adresuje? |
| Jak wygląda cykl życia pamięci agenta i dlaczego sama akumulacja nie wystarcza? |
| Czym różnią się benchmarki pamięci od benchmarków multi-hop i dlaczego rozmiar kontekstu ma znaczenie? |
| Kiedy długi kontekst nie zastępuje ani RAG, ani pamięci agenta? |
| Dlaczego indeks wektorowy nie jest jeszcze pamięcią agenta? |
| Czym różnią się dwa znaczenia „GraphRAG" i kiedy które wygrywa? |
| Jak agent utrzymuje jakość wiki w czasie? |


Strony wiki powstają na żywo — przed pytaniem zerknij do `wiki/llm-wiki/wiki/index.md`, czy
temat jest pokryty (i pod którą stroną).

> 🚀 **Bez wiki — agent `plan` (raw i sieć, bez bundla):**

```text
<twoje pytanie> — odpowiedz, korzystając z plików w wiki/llm-wiki/raw/ (możesz też z sieci).
NIE korzystaj z wiki/llm-wiki/wiki/. Na końcu podaj, z czego wzięłaś odpowiedź — plik albo URL
— albo napisz: nie znalazłem. Odpowiedz krótko (jedno zdanie).
```

> 🚀 **Z wiki — agent `plan` (tylko bundle):**

```text
Korzystając WYŁĄCZNIE ze stron w wiki/llm-wiki/wiki/, odpowiedz krótko (jedno zdanie)
i na końcu podaj cytowaną stronę. <twoje pytanie>
```

### Na co patrzeć — droga, nie odpowiedź

Ta sama odpowiedź może wyjść w obu trybach. Różnica jest w **tym, jak agent do niej doszedł**
i ile kosztuje sprawdzenie jej:

- **bez wiki** — długa lista `tool call`: `grep`/`glob`, próby czytania PDF-ów, `bash`
  z `pdftotext` (którego nie ma), własne skrypty, `webfetch`;
- **z wiki** — kilka wywołań: `index.md` → `read` jednej strony → cytat.

> 🚀 **Zobacz obie ścieżki obok siebie** — w drugim terminalu, obok sesji opencode, wklej:

```bash
bash scripts/wiki-compare.sh "<twoje pytanie>"
```

Skrypt sam odpala `opencode run` w trybie headless, dlatego uruchamiamy go w drugim terminalu,
a sesję opencode zostawiamy obok. Odpala oba tryby tym samym modelem i drukuje:

- tabelę: **czas, liczba wywołań, tokeny, cytat**,
- **listę `tool call`** dla każdego trybu — co po kolei zrobił agent.

> 🚀 **Wariant szybki:** w tym samym drugim terminalu ogranicz czas trybu „bez wiki", żeby wiki zdążyła, a raw wciąż szukał:

```bash
TIMEOUT_RAW=60 bash scripts/wiki-compare.sh "<twoje pytanie>"
```

### Wniosek

Wiki nie zmienia pytania ani modelu — zmienia **drogę**: mniej wywołań, mniej zgadywania
i odpowiedź, którą **weryfikujesz, otwierając jedną stronę**. Dlatego szybciej i taniej
sprawdza się ją potem — przy audycie, w pracy zespołowej i przy powrocie do tematu po tygodniu.

> 🎓 **Prowadzący omawia:** patrzymy na listę `tool call`. Bez wiki to często kilkanaście
> kroków i ślepe zaułki (PDF-y, sieć); z wiki — kilka i cytat. Z włączoną siecią agent
> „bez wiki" może skrócić drogę, pobierając źródło online — to też jest część obserwacji.


## Wróć do pojęcia research vs destylacja

- **Research** (otwarty) — web, prace naukowe, dokumentacja. Trwa długo i kosztuje, więc korpus zbieramy z góry, raz.
- **Destylacja** (zamknięta) — wyłącznie `raw/`. Zaufane, cytowalne źródło, z którego wiki wyciąga esencję.

## Gotowe, gdy…

- istnieje wiki z `AGENTS.md`, `raw/` i `wiki/`,
- co najmniej jedna strona powstała z Twojego materiału,
- odpowiedź pochodzi ze strony wiki i jest zacytowana,
- widziałeś różnicę między odpowiedzią bez wiki i z wiki,
- widziałeś listę `tool call` w obu trybach i różnicę w drodze do odpowiedzi (czas, wywołania, tokeny).

---

[← Poprzednia: Podagenci ⭐](15-podagenci.md) · [Agenda](00-agenda.md) · [Następna: Instalacja lokalna →](17-instalacja-lokalna.md)
