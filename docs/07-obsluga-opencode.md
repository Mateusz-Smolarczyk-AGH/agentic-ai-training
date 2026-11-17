# Obsługa opencode

[← Poprzednia: Teoria — agent i harness](06-teoria-agent.md) · [Agenda](00-agenda.md) · [Następna: Agent plan — odpowiedź, której chat nie umiał →](08-agent-plan.md)

## opencode = harness

opencode to **harness**: prowadzi pętlę agenta (model → narzędzie → obserwacja), utrzymuje
kontekst sesji, egzekwuje uprawnienia i dostarcza narzędzia. Sam model niczego nie „wykonuje” —
proponuje wywołania, a opencode je realizuje.

## Jak zarządzać sesjami

Każda rozmowa w opencode to **sesja**: Twoje wiadomości, odpowiedzi agenta i wywołania
narzędzi. Sesje zapisują się same — wyjście niczego nie gubi.

Sesjami można zarządzać jak kartami na górze ekranu lub poprzez komendy opencode.

- **Nowa sesja:** `/new` (alias `/clear`) — czysty start, poprzednie nadal istnieją.
- **Powrót do sesji:** `/sessions` (aliasy `/resume`, `/continue`) — lista i przełączanie
  w interfejsie. Z terminala: `opencode --continue` (ostatnia sesja) albo
  `opencode --session <id>`.
- **Za długa sesja:** `/compact` skraca ją, gdy kontekst się zapełnia — agent zachowuje
  istotę, traci szczegóły.
- **Cofanie:** `/undo` cofa ostatnią Twoją wiadomość wraz z odpowiedzią agenta **i zmianami
  w plikach** (używa git, więc działa w repozytorium); `/redo` przywraca cofnięte.

## Jak zarządzać modelami

Model to „mózg” agenta. W opencode nazywa się go `provider/model`, np.
`plgrid/deepseek-ai/DeepSeek-V4.1-Flash`.

- **Zmiana w interfejsie:** `/models` — wybór z listy.

## Jak zarządzać agentami

Agent to model + narzędzia + uprawnienia + prompt systemowy. **Ten sam model może być wykorzystywane przez różnych agentów** — zmienia się to, na co może sobie pozwolić oraz jak się zachowuje.

- **Zmiana w interfejsie:** **Shift+Tab** — przełączanie między agentami.
- **Budowane:** `build` (może edytować pliki) i `plan` (tylko czyta). W tym repo jest dodatkowo
  `chat` (bez narzędzi — używany zaraz w porównaniu) i `demo-vulnerable` (na potrzeby demo
  bezpieczeństwa).

## Ściąga komend

**W interfejsie (wpisz `/`):**

| Komenda    | Działanie                                       |
|------------|--------------------------------------------------|
| `/help`    | lista komend                                      |
| `/models`  | wybór modelu                                      |
| `/sessions`| lista sesji i przełączanie                        |
| `/new`     | nowa sesja                                        |
| `/compact` | skrócenie sesji                                   |
| `/undo`    | cofnięcie ostatniej zmiany (także plików)         |
| `/redo`    | przywrócenie cofniętej zmiany                     |
| `/details` | pokazywanie szczegółów wywołań narzędzi           |
| `/thinking`| podgląd rozumowania modelu                        |
| `/terminal`| terminal obok agenta   |
| `/exit`    | wyjście                                           |


**Elementy rozmowy:**

| Element        | Działanie                                                          |
|----------------|--------------------------------------------------------------------|
| `@plik`        | dodaje zawartość pliku do rozmowy (fuzzy szukanie)                 |
| `!` + polecenie| wpisz `!`, potem wklej polecenie (bez `!`) — wynik idzie do rozmowy|
| **Shift+Tab**  | zmiana agenta                                                      |
| `/exit`, Ctrl+C| wyjście                                                            |

**Komendy w sesji uruchamiasz przez `!`** — najpierw wpisz `!`, potem wklej samo polecenie (bez
`!`); wynik trafia do rozmowy. **Na klastrze to główny sposób**: `/terminal` bywa kapryśny.
Lokalnie możesz zamiast `!` otworzyć osobny terminal — wtedy restart opencode bywa potrzebny,
jeśli Twoje środowisko tego wymaga. Sam opencode restartu nie wymaga: zmiany w konfiguracji
(uprawnienia, skille, MCP, podagenci) działają od razu.

## Gotowe, gdy…

- wiesz, czym jest harness i co robi w pętli,
- umiesz wrócić do poprzedniej sesji (`/sessions`, `opencode --continue`),
- umiesz zmienić model (`/models`) i agenta (**Shift+Tab**),
- wiesz, czym różnią się `build`, `plan` i `chat`.

Dalej — porównanie agenta bez narzędzi z agentem, który ma dostęp do narzędzi.

---

[← Poprzednia: Teoria — agent i harness](06-teoria-agent.md) · [Agenda](00-agenda.md) · [Następna: Agent plan — odpowiedź, której chat nie umiał →](08-agent-plan.md)
