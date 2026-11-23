# Instalacja lokalna — opencode + PLGrid

[← Poprzednia: LLM Wiki](16-llm-wiki.md) · [Agenda](00-agenda.md)

Ta strona to krok dla Ciebie **po szkoleniu**, na własnym laptopie. Na zajęciach pracowaliśmy
z klastra przez SSH — [02-setup.md](02-setup.md) — i nic nie instalowaliśmy lokalnie. Tutaj
instalujesz opencode i plugin PLGrid u siebie.

## Krok 1 — klucz API PLGrid

Klucz powstaje w **PLGrid Forge**. Zanim go wygenerujesz, przechodzisz cztery kroki formalne —
w tej kolejności:

1. **Konto, afiliacja, zespół** — przewodnik:
   [guide.plgrid.pl → How to start](https://guide.plgrid.pl/en/portal-for-science/how-to-start/for_beginners).
2. **Grant z kredytami na usługę LLM** — w zakładce Resources. Nowy grant:
   [guide → Proper grants](https://guide.plgrid.pl/en/portal-for-science/grants/plgrid/proper);
   kredyty w istniejącym grancie dodasz, renegocjując zasoby w Portalu PLGrid:
   [guide → Renegotiation](https://guide.plgrid.pl/en/portal-for-science/grants/plgrid/proper/renegotiation).
3. **Aktywacja usługi PLGrid Forge** w Portalu PLGrid:
   [portal.plgrid.pl/services/111](https://portal.plgrid.pl/services/111).
4. **Wygenerowanie klucza** — wejdź na [llmlab.plgrid.pl](https://llmlab.plgrid.pl) → zakładka
   **Grants** → przy wybranym grancie kliknij `Generate API Key` (albo otwórz kafelek grantu →
   `Actions` → `Generate API Key`), a potem `Generate`.

Przy generowaniu wypełniasz:

| Pole | Znaczenie |
|------|-----------|
| **nazwa** | musi być unikalna wśród kluczy tego grantu; to jedyne pole obowiązkowe |
| **data wygaśnięcia** | po tej dacie klucz nie autoryzuje; **tej daty nie da się zmienić po utworzeniu klucza** |
| **miesięczny limit kredytów** i **łączny limit kredytów** | ile kredytów klucz może zużyć z puli grantu; przewodnik zaleca ustawienie limitu miesięcznego, bo ogranicza szkody, gdy klucz wycieknie |

Klikasz `Create`. Treść klucza pojawia się jako `Your API Token` — **skopiuj i zapisz ją od razu**;
ze względów bezpieczeństwa zawartość klucza nie jest przechowywana w systemie PLGrid Forge, więc
zobaczysz ją tylko zaraz po utworzeniu. Klucz ma postać `plg-…`.

Kluczami zarządzasz w zakładce [llmlab.plgrid.pl/auth-keys](https://llmlab.plgrid.pl/auth-keys):
status (active / expired / revoked), zmiana limitów, `Revoke`.

> **Bezpieczeństwo:** każdy, kto zna treść klucza, może wysyłać zapytania do modeli — nawet bez
> konta PLGrid. **Traktuj klucz jak hasło.** Nigdy nie wkładaj go do repozytorium ani do pliku
> konfiguracyjnego. Kredyty zużyte przez klucz obciążają grant i limity osoby, która go wygenerowała — dlatego ograniczone limity mają znaczenie.

## Krok 2 — instalacja opencode 2.x

> 🚀 **Wklej do terminala:**

```bash
curl -fsSL https://opencode.ai/v2/install | bash
```

Na macOS możesz zamiast tego użyć Homebrew:

> 🚀 **Wklej do terminala:**

```bash
brew install anomalyco/tap/opencode-v2
```

Sprawdź wersję: `opencode --version` musi wypisać `opencode v2.…`. Plugin wymaga opencode v2 —
opencode 1.x nie jest przez niego obsługiwany.

## Krok 3 — instalacja pluginu PLGrid

> 🚀 **Wklej do terminala:**

```bash
opencode plugin add https://github.com/cyfronet/opencode-plugin-plgrid.git
```

Instalacja pluginu z GitHuba wymaga `git` w systemie — na macOS doinstaluj narzędzia
deweloperskie (`xcode-select --install`), w Linuksie zainstaluj pakiet `git`.

Plugin:

- rejestruje integrację `plgrid` (nazwa wyświetlana `PLGrid Forge (Cyfronet)`) z metodą logowania
  kluczem, dzięki czemu działa `opencode auth login plgrid`,
- rejestruje providera `plgrid` opartego na pakiecie runtime zgodnym z OpenAI, z `baseURL`
  wskazującym na gateway,
- pobiera listę modeli z gatewaya przy starcie, więc nowe i wycofane modele pojawiają się bez
  reinstalacji.

Sprawdź, że jest zarejestrowany:

> 🚀 **Wklej do terminala:**

```bash
opencode plugin list
```

Plugin instaluje się w **globalnej konfiguracji** opencode, więc działa w każdym katalogu, nie
tylko w jednym projekcie.

## Krok 4 — logowanie kluczem

> 🚀 **Wklej do terminala:**

```bash
opencode auth login plgrid
```

Na pytanie wklej klucz `plg-…`. Ten prompt potrzebuje prawdziwego interaktywnego terminala —
przekazanie klucza potokiem nie działa (opencode zgłasza "API key input requires an interactive
terminal").

Sprawdź:

> 🚀 **Wklej do terminala:**

```bash
opencode auth list
```

Klucz opencode zapisuje we własnym magazynie poświadczeń pod `~/.local/share/opencode/` — nigdy
w repozytorium i nigdy w `opencode.json`. Po zalogowaniu **zrestartuj opencode**: plugin czyta
poświadczenie i pobiera listę modeli, gdy opencode startuje.

Zrestartuj opencode:
> 🚀 **Wklej do terminala:**

```bash
opencode service restart
```

## Krok 5 — sprawdzenie, że działa

> 🚀 **Wklej do terminala:**

```bash
opencode models | grep '^plgrid/'
```

Powinieneś zobaczyć modele `plgrid/…`, których może używać Twój grant.

Pierwsze pytanie:

> 🚀 **Wklej do terminala:**

```bash
opencode run -m plgrid/deepseek-ai/DeepSeek-V4.1-Flash "Napisz jednym zdaniem, co to jest opencode."
```

Możesz też uruchomić `opencode`, wybrać model przez `/models` i zadać to samo pytanie w interfejsie.

Lokalnie — inaczej niż na klastrze — możesz po prostu otworzyć drugie okno terminala, zamiast
wpisywać `!` w opencode.

---

## Config

W repo leży **przykładowy config** — [`opencode.example.json`](../opencode.example.json). To pełny,
gotowy do adaptacji zestaw: domyślny model, serwer MCP context7, kilka komend, zaostrzone reguły
uprawnień i przykładowi podagenci (`reviewer`, `researcher`, `architect`, `editor` i inni).

> **Ważne:** ten plik **nie zawiera** wpisu `plugins` ani bloku `provider` — zakłada, że providera
> `plgrid` i podpięcie do gatewaya daje plugin z kroku 3. Dlatego dodając go, **musisz uważać, żeby
> nie nadpisać podpięcia pluginu**.

Najbezpieczniej użyć go jako **config projektu** — skopiuj go do swojego projektu i uruchamiaj
opencode z katalogu tego projektu:

> 🚀 **Wklej do terminala:**

```bash
mkdir -p <twoj-projekt>/.opencode
cp <repo>/opencode.example.json <twoj-projekt>/.opencode/opencode.json
```

`<repo>` to repozytorium warsztatu na Twoim dysku. Config projektu **łączy się** z globalnym
(listy `plugins` się sumują, a nie nadpisują), więc podpięcie pluginu z kroku 3 zostaje nietknięte.

Jeśli wolisz mieć go **globalnie**, **nie podmieniaj całego** `~/.config/opencode/opencode.json`.
Dopisz tylko sekcje z przykładu do pliku, który już masz, i **zostaw to, co podłącza plugin**: wpis
`"plugins"` dopisany przez `opencode plugin add` oraz katalog `~/.config/opencode/plugins/`.
Przykład nie ma wpisu `"plugins"`, więc zwykłe skopiowanie pliku usuwa podpięcie i gubisz
`opencode auth login plgrid` (trzeba by powtórzyć krok 3).

> **Uwaga:** to przykład — dostosuj go do siebie. Wpisy `permission.skill` i `permission.*_*`
> odwołują się do skilli i narzędzi MCP, których możesz nie mieć, a lista modeli pochodzi z Twojego
> grantu. Uprawnienia są celowo zaostrzone (sekrety na `deny`, `bash` na `ask`) — zostaw je albo
> dostrój ([Bezpieczeństwo](12-bezpieczenstwo.md)).

## Gdy coś nie działa

Plugin drukuje te komunikaty na stderr, a adres gatewaya to
`https://llmlab.plgrid.pl/api/v1/models/opencode-config`.

| Sytuacja | Co widzisz | Co zrobić |
|----------|------------|-----------|
| Brak klucza | `[plgrid] no API key found; run \`opencode auth login plgrid\`` | Nie zalogowałeś się albo nie zrestartowałeś opencode po zalogowaniu. |
| Klucz odrzucony przez bramkę (zły, wygasły albo unieważniony) | `[plgrid] could not fetch https://llmlab.plgrid.pl/api/v1/models/opencode-config: HTTP 401` (bramka może zwrócić też inny kod błędu) | Wygeneruj świeży klucz na [llmlab.plgrid.pl](https://llmlab.plgrid.pl) (Grants → Generate API Key). |
| Gateway nieosiągalny (sieć, proxy, firewall, timeout 10 s) | `[plgrid] could not fetch <adres>: <powód>` | Sprawdź, czy docierasz do llmlab.plgrid.pl, i spróbuj ponownie. |
| Brak modeli w odpowiedzi | `[plgrid] no models returned by <adres>` | Grant nie ma kredytów LLM albo usługa PLGrid Forge nie jest aktywna — wróć do kroku 1. |
| Model odpowiada `not available for grant` | komunikat `not available for grant` | Twój grant nie obejmuje tego modelu; wybierz inny przez `/models`. |
| Plugin nie zdążył się aktywować | `Location plugins did not finish activating` | Gateway odpowiedział zbyt wolno (plugin ma około 5 s na aktywację); uruchom opencode ponownie. |
| Stara wersja opencode | `opencode --version` wypisuje 1.x | Plugin wymaga opencode v2; zaktualizuj (krok 2). |
| Modele są na liście, ale nic nie odpowiada | brak odpowiedzi modelu | Sprawdź konto (`opencode auth list`), zaloguj się ponownie (`opencode auth login plgrid`) i zrestartuj opencode — wywołania modeli potrzebują ważnego klucza. |

Wiedza zaawansowana: plugin rozumie dwie zmienne środowiskowe. `PLGRID_API_KEY` ma pierwszeństwo
przed zapisanym poświadczeniem i przydaje się w skryptach. `PLGRID_API_BASE_URL` zmienia adres
gatewaya (domyślnie `https://llmlab.plgrid.pl/api/v1`).

## Gdy nie możesz użyć `opencode plugin add`

Repozytorium wozi ten sam plugin jako pojedynczy plik: `snippets/plgrid.js` (bajt w bajt kopia
pakietu upstream). Skopiuj go do globalnego katalogu pluginów:

> 🚀 **Wklej do terminala:**

```bash
mkdir -p ~/.config/opencode/plugins
cp <repo>/snippets/plgrid.js ~/.config/opencode/plugins/plgrid.js
```

`<repo>` to repozytorium warsztatu na Twoim dysku. Potem zrestartuj opencode i kontynuuj od
kroku 4 (logowanie) i kroku 5 (sprawdzenie). opencode odkrywa każdy plugin z tego katalogu przy
starcie.

To ostatni krok warsztatu. Konfiguracja klastra to [02-setup.md](02-setup.md), a pozostałe strony
znajdziesz w [00-agenda.md](00-agenda.md).

## Gotowe, gdy…

- masz klucz `plg-…` zapisany poza repozytorium,
- `opencode --version` wypisuje `opencode v2.…`,
- `opencode plugin list` pokazuje plugin PLGrid,
- `opencode auth list` pokazuje `plgrid`,
- `opencode models` wypisuje modele `plgrid/…`,
- zadałeś pytanie i dostałeś odpowiedź.

---

[← Poprzednia: LLM Wiki](16-llm-wiki.md) · [Agenda](00-agenda.md)
