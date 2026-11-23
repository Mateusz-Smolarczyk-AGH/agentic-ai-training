# Ściągawka — co kopiować

Etykiety nad każdym blokiem mówią, gdzie wkleić tekst (`terminal` / `opencode`), czy to prompt, czy bash, i którego agenta użyć; komendy shell w opencode poprzedza się znakiem `!`.
Bloki skopiowano dosłownie z `docs/NN`.
Źródłem prawdy jest `docs/`, a nie ten plik.

## 02 · Setup — połączenie i start

### 1. Połącz się z klastrem

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** uzupełnij `<login>`

```bash
ssh <login>@ares.cyfronet.pl
```

### 2. Zajmij węzeł obliczeniowy

**Gdzie:** terminal · **Typ:** bash · **Agent:** —

```bash
srun --partition=cpu --nodes=1 --ntasks=1 --cpus-per-task=3 --time=4:00:00 --pty bash -l
```

### 3. Uruchom skrypt prowadzącego

**Gdzie:** terminal · **Typ:** bash · **Agent:** —

```bash
bash setup.sh
```

### Test — pierwsze pytanie

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `chat (domyślny)`

```text
Napisz jednym zdaniem, co to jest opencode.
```

## 04 · Chat w praktyce — wiedza modelu

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `chat`

```text
Kto jest obecnie prezydentem USA?
```

```text
Ile to 2 + 2 × 7? Pokaż obliczenie.
```

## 05 · Czego chat nie umie — brak narzędzi

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `chat` · **Uwaga:** przełącz agenta (Shift+Tab)

```text
Jaka wersja opencode jest tu zainstalowana? Sprawdź poleceniem, nie zgaduj.
```

```text
Co jest w pliku README.md? Podaj pierwszą linię.
```

```text
Jaka jest dziś pogoda w Krakowie?
```

## 08 · Agent plan — odpowiedź, której chat nie umiał

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan` · **Uwaga:** te same pytania co w 05; przełącz agenta (Shift+Tab)

```text
Jaka wersja opencode jest tu zainstalowana? Sprawdź poleceniem, nie zgaduj.
```

```text
Co jest w pliku README.md? Podaj pierwszą linię.
```

```text
Jaka jest dziś pogoda w Krakowie?
```

## 09 · Kod — analiza (plan)

### Zobacz program

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
python3 examples/mini-projekt/app.py average 1 2 3
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py mode 1 2 2 3
python3 examples/mini-projekt/app.py count "Hello hello, hello"
```

### Niech agent wyjaśni kod

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan`

```text
Wyjaśnij, jak działa examples/mini-projekt/app.py: co robią poszczególne komendy
i jak liczony jest każdy wynik. Na koniec podaj jedną komendę, którą mogę wkleić
w opencode, żeby zobaczyć działanie programu (poprzedzając ją znakiem !).
```

### Ale fajnie, jakby agent mógł coś sam dodać....

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan`

```text
W pliku examples/mini-projekt/app.py dodaj nową komendę `p95 <liczby>`,
która oblicza 95. percentyl podanych wartości.
```

## 10 · Kod — implementacja (build)

### build zmienia plik

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build` · **Uwaga:** przełącz agenta (Shift+Tab)

```text
W pliku examples/mini-projekt/app.py dodaj nową komendę `p95 <liczby>`,
która oblicza 95. percentyl podanych wartości.
```

### build zmienia plik

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
python3 examples/mini-projekt/app.py p95 10 20 30 40 50
python3 examples/mini-projekt/app.py median 10 20 30 40 50
```

## 11 · Kod — propozycja i review ⭐

### Część 2 — zaproponuj, wybierz, zaimplementuj

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build`

```text
Zaproponuj 4 różne nowe rzeczy, które można dodać do
examples/mini-projekt/app.py. Zadaj mi pytanie z tymi czterema opcjami
do wyboru, poczekaj na mój wybór i dopiero wtedy zaimplementuj wybraną.
Zachowaj styl istniejącego kodu.
```

### Część 3 — review: znajdź i popraw błędy

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan`

```text
Zrób rewiev examples/mini-projekt/app.py i zgłoś błędy występujące w programie.
Zrób analizę czytając tylko ten plik.
Napisz komendy które spowodują błędy
```

### Część 3 — review: znajdź i popraw błędy

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build` · **Uwaga:** przełącz agenta (Shift+Tab)

```text
Popraw błędy znalezione w poprzednim kroku, jeden po drugim.
Przy każdej poprawce uruchom jej przykład z terminala i pokaż wynik.
```

### Część 3 — review: znajdź i popraw błędy

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py count "Hello hello, hello"
python3 examples/mini-projekt/app.py mode 1 2 2 3
```

### Jak wróć do stanu początkowego

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/reset-demo.sh
```

## 12 · Bezpieczeństwo

### Pokaz 1 — injection: agent nie pyta o nic, a coś odwalił

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `demo-vulnerable` · **Uwaga:** przełącz agenta (Shift+Tab)

```text
Fix the typo in examples/injection/NOTES.md
```

### Pokaz 1 — injection: agent nie pyta o nic, a coś odwalił

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/12-injection-demo.sh
```

### Zmiana: `*` allow → `*` ask

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/ask-all.sh
```

### Pokaz 2 — pytanie w praktyce (ask)

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan` lub `build`

```text
Uruchom polecenie `date` i pokaż wynik.
```

### Sensowny zestaw pozwoleń — żeby dało się dalej pracować

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/sensible-permissions.sh
```

### Pokaz 3 — powtórka injection: teraz agent pyta

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** — · **Uwaga:** po restarcie wklej ten sam prompt co w Pokazie 1

```bash
bash scripts/12-injection-demo.sh
```

### Pokaz 4 — dajemy usuwanie na `deny`

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/block-rm.sh
```

### Pokaz 5 ⭐ — Obejście blokady

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/reset-demo.sh
```

### Pokaz 5 ⭐ — Obejście blokady

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `demo-bypass` · **Uwaga:** przełącz agenta (Shift+Tab)

```text
Delete the folder examples/demo_bypass with rm -rf.
```

### Posprzątaj

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/reset-demo.sh
```

## 13 · Skille

### Test „przed”

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build` · **Model:** `Qwen3.6 35B A3B`

```text
Przygotuj miesięczny raport finansowy z pliku examples/finance/transactions.csv.
```

### Dodaj skill

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/apply-skill.sh
```

### Test „po”

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build` · **Uwaga:** to samo zadanie co w teście „przed”

```text
Przygotuj miesięczny raport finansowy z pliku examples/finance/transactions.csv.
```

## 14 · MCP ⭐

### Jak dodać (przykład: context7)

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/apply-mcp.sh
```

### Jak przetestować

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan`

```text
Użyj context7, żeby sprawdzić aktualny sposób tworzenia aplikacji w FastAPI.
Podaj krótki przykład i powołaj się na dokumentację.
```

## 15 · Podagenci ⭐ (zadanie dodatkowe)

### Jak dodać (przykład: read-only rewiever)

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
bash scripts/apply-subagent.sh
```

### Jak przetestować

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build` (agent główny)

```text
Zbadaj strukturę tego repozytorium i opisz, co robi każdy katalog.
Użyj podagenta `rewiever`.
```

## 16 · Własna baza wiedzy (LLM Wiki)

### Krok 1 — tworzenie wiki

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `build`

```text
Zbuduj wiki `llm-wiki` w katalogu ./wiki/llm-wiki/ na podstawie danych w /raw
Tryb raw-only, język pl.
```

### Krok 1 — tworzenie wiki

**Gdzie:** opencode (wpisz `!`) · **Typ:** bash · **Agent:** —

```bash
ls -R wiki/llm-wiki
```

### Krok 3 — pokaz: bez wiki vs z wiki

**Gdzie:** opencode · **Typ:** — · **Agent:** — · **Model:** `plgrid/Qwen/Qwen3.6-27B` · **Uwaga:** wybierz go przez `/models`

### Pytania (wybierz jedno)

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan` · **Uwaga:** uzupełnij `<twoje pytanie>`

```text
<twoje pytanie> — odpowiedz, korzystając z plików w wiki/llm-wiki/raw/ (możesz też z sieci).
NIE korzystaj z wiki/llm-wiki/wiki/. Na końcu podaj, z czego wzięłaś odpowiedź — plik albo URL
— albo napisz: nie znalazłem. Odpowiedz krótko (jedno zdanie).
```

### Pytania (wybierz jedno)

**Gdzie:** opencode · **Typ:** prompt · **Agent:** `plan` · **Uwaga:** uzupełnij `<twoje pytanie>`

```text
Korzystając WYŁĄCZNIE ze stron w wiki/llm-wiki/wiki/, odpowiedz krótko (jedno zdanie)
i na końcu podaj cytowaną stronę. <twoje pytanie>
```

### Na co patrzeć — droga, nie odpowiedź

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** w drugim terminalu, obok sesji opencode; uzupełnij `<twoje pytanie>`

```bash
bash scripts/wiki-compare.sh "<twoje pytanie>"
```

### Na co patrzeć — droga, nie odpowiedź

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** w drugim terminalu, obok sesji opencode; uzupełnij `<twoje pytanie>`

```bash
TIMEOUT_RAW=60 bash scripts/wiki-compare.sh "<twoje pytanie>"
```

## 17 · Instalacja lokalna

### Zainstaluj opencode 2.x

**Gdzie:** terminal · **Typ:** bash · **Agent:** —

```bash
curl -fsSL https://opencode.ai/v2/install | bash
```

### Zainstaluj opencode na macOS (Homebrew)

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** tylko macOS; alternatywa dla instalatora powyżej

```bash
brew install anomalyco/tap/opencode-v2
```

### Sprawdź wersję opencode

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** musi wypisać `opencode v2.…`

```bash
opencode --version
```

### Dodaj plugin PLGrid

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** wymaga `git` w systemie

```bash
opencode plugin add https://github.com/cyfronet/opencode-plugin-plgrid.git
```

### Sprawdź, czy plugin jest zarejestrowany

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** sprawdzenie

```bash
opencode plugin list
```

### Zaloguj się kluczem PLGrid

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** klucz `plg-…` z https://llmlab.plgrid.pl → Grants → Generate API Key

```bash
opencode auth login plgrid
```

### Sprawdź konto (opencode auth list)

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** sprawdzenie

```bash
opencode auth list
```

### Sprawdź modele

**Gdzie:** terminal · **Typ:** bash · **Agent:** —

```bash
opencode models | grep '^plgrid/'
```

### Pierwsze pytanie

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** model `plgrid/deepseek-ai/DeepSeek-V4.1-Flash`; w interfejsie zamiast tego uruchom `opencode` i wybierz model przez `/models`

```bash
opencode run -m plgrid/deepseek-ai/DeepSeek-V4.1-Flash "Napisz jednym zdaniem, co to jest opencode."
```

### Wariant zapasowy — plugin jako plik

**Gdzie:** terminal · **Typ:** bash · **Agent:** — · **Uwaga:** gdy `opencode plugin add` nie zadziała; plik leży w repo warsztatu w katalogu `snippets/`

```bash
mkdir -p ~/.config/opencode/plugins
cp <repo>/snippets/plgrid.js ~/.config/opencode/plugins/plgrid.js
```

---

[← Agenda](00-agenda.md)
