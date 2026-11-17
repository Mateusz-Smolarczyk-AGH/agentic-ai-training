# Teoria — agent i harness

[← Poprzednia: Czego chat nie umie — brak narzędzi](05-czego-chat-nie-umie.md) · [Agenda](00-agenda.md) · [Następna: Obsługa opencode →](07-obsluga-opencode.md)

Agent to czat + **narzędzia** + **pętla**. Narzędzia **wzbogacają kontekst** — agent wie więcej,
niż pamięta model.

Użyjemy trzech agentów (przełączasz je klawiszem **Shift+Tab**):

| Agent    | Co potrafi                                              |
|----------|--------------------------------------------------------|
| `chat`   | **bez narzędzi** — tylko rozmowa                        |
| `plan`   | **czyta** pliki, uruchamia polecenia, szuka w sieci     |
| `build`  | jak `plan`, ale **zmienia pliki** (o tym później)       |

## Agenci

| Pojęcie             | Znaczenie                                                                  |
|---------------------|----------------------------------------------------------------------------|
| **Harness**         | program prowadzący pętlę agenta (tu: opencode)                             |
| **Agent**           | model + narzędzia + pętla; sam decyduje, co zrobić                         |
| **Pętla agenta**    | model → decyzja → narzędzie → obserwacja → model                           |
| **Narzędzie (tool)**| funkcja, którą agent może wywołać (czytaj plik, uruchom polecenie)          |
| **Function calling**| mechanizm, w którym model proponuje wywołanie narzędzia                     |
| **Skill**           | instrukcja ładowana na żądanie (jak wykonać klasę zadań)                    |
| **MCP**             | protokół podłączania zewnętrznych serwerów narzędzi                        |
| **Podagent**        | osobna sesja agenta, do której deleguje się zadanie                         |

## Wiedza i kontekst

| Pojęcie             | Znaczenie                                                                  |
|---------------------|----------------------------------------------------------------------------|
| **RAG**             | wyszukanie fragmentów i dołączenie ich do promptu                           |
| **Embedding**       | wektor liczbowy reprezentujący znaczenie tekstu                            |
| **LLM Wiki**        | prowadzona przez agenta baza wiedzy z dokumentów (format OKF)              |

## Pojęcia wrócą w praktyce

Nie zostawiamy tego jako teorii — po wejściu na klaster zobaczysz każde z tych pojęć w akcji:

- **narzędzie / pętla** → blok [Agent plan](08-agent-plan.md),
- **skill** → blok [Skille](13-skille.md),
- **MCP** i **podagent** → zadania ⭐ ([MCP](14-mcp.md), [Podagenci](15-podagenci.md)).

## Gotowe, gdy…

- umiesz wyjaśnić: harness, agent, pętla agenta, narzędzie, function calling, skill, MCP, podagent,
- wiesz, że agent potrafi sprawdzać (narzędzia), a chat nie.

---

[← Poprzednia: Czego chat nie umie — brak narzędzi](05-czego-chat-nie-umie.md) · [Agenda](00-agenda.md) · [Następna: Obsługa opencode →](07-obsluga-opencode.md)
