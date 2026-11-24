# Agenda (konspekt)

**Pierwsze kroki z agentami AI: research, praca z kodem i własna wiki**
24.11.2026, Kraków · 10:30–14:00 (3,5 h, przerwa ok. 12:30, lunch od 14:00)

> Zacznij od setupu, zobacz różnicę chat vs agent, popracuj na kodzie, zrozum bezpieczeństwo i na końcu zbuduj własną wiki z przygotowanych artykułów.

> Ściągawka — wszystkie rzeczy do skopiowania po kolei (prompty, komendy, agent, model): [sciaga.md](sciaga.md)

## Plan dnia

| Czas        | Blok                                                        | Co robisz                                                          | Gotowe, gdy                                              |
|-------------|-------------------------------------------------------------|--------------------------------------------------------------------|----------------------------------------------------------|
| 10:30–10:40 | [Wstęp](01-wstep.md)                                        | ---                         | Wiesz, co będziemy robić                                 |
| 10:40–10:55 | [Setup — połączenie i start](02-setup.md)                   | SSH, węzeł obliczeniowy, `setup.sh`, logowanie, test               | Widzisz modele `plgrid/…` i masz odpowiedź               |
| 10:55–11:05 | [Teoria — czym jest chat](03-teoria-chat.md)                | Slajd: pojęcia (LLM, token, prompt, okno kontekstu…)               | Znasz podstawowe pojęcia                                 |
| 11:05–11:15 | [Chat w praktyce](04-chat-w-praktyce.md)                    | Pytanie z wiedzy ogólnej → chat odpowiada                          | Rozumiesz: chat odpowiada z wiedzy modelu                |
| 11:15–11:20 | [Czego chat nie umie](05-czego-chat-nie-umie.md)            | Pytanie o stan lokalny/dziś → chat nie może                        | Widzisz brak narzędzi                                    |
| 11:20–11:35 | [Teoria — agent i harness](06-teoria-agent.md)              | Slajd: agent, pętla, narzędzia                                     | Znasz pojęcia agenta                                     |
| 11:35–11:45 | [Obsługa opencode](07-obsluga-opencode.md)                  | Sesje, modele, agenci                                              | Umiesz się poruszać                                      |
| 11:45–11:55 | [Agent plan](08-agent-plan.md)                              | Te same pytania, teraz agent sprawdza                              | Widziałeś surowe wywołanie narzędzia                     |
| 11:55–12:05 | ☕ Przerwa                                                   |                                                                    |                                                          |
| 12:05–12:25 | [Kod — analiza](09-kod-analiza.md)                          | Plan wyjaśnia kod i daje komendę                                   | Agent nie edytuje plików                                 |
| 12:25–12:40 | [Kod — implementacja](10-kod-implementacja.md)              | `build` dodaje `p95`                                               | Kod zmieniony, komendy działają                          |
| --- | [⭐ Kod — propozycja i review](11-kod-propozycja-review.md) | Wybór, implementacja, review                                       | Agent znalazł i poprawił błędy                           |
| 12:40–13:10 | [Bezpieczeństwo](12-bezpieczenstwo.md)                      | injection → allow/ask → deny → obejście → wyciek                   | Rozumiesz ryzyka podczas pracy z agentem i jak bezpiecznie korzystać                                     |
| 13:10–13:25 | [Skille](13-skille.md)                                      | Test przed/po, dodaj skill                                         | Agent ze skillem zachowuje się inaczej                   |
| --- | [MCP](14-mcp.md) ⭐ lub [Podagenci](15-podagenci.md) ⭐      | Dodaj serwer MCP albo podagenta                                    | Narzędzie działa                                         |
| 13:25–14:00 | [LLM Wiki](16-llm-wiki.md)                                  | Wiki z korpusu researchu + porównanie z wiki/bez wiki              | Odpowiedź cytuje stronę wiki                             |

## Strony

1. [Wstęp](01-wstep.md)
2. [Setup — połączenie i start](02-setup.md)
3. [Teoria — czym jest chat](03-teoria-chat.md)
4. [Chat w praktyce — wiedza modelu](04-chat-w-praktyce.md)
5. [Czego chat nie umie — brak narzędzi](05-czego-chat-nie-umie.md)
6. [Teoria — agent i harness](06-teoria-agent.md)
7. [Obsługa opencode](07-obsluga-opencode.md)
8. [Agent plan — odpowiedź, której chat nie umiał](08-agent-plan.md)
9. [Kod — analiza (plan)](09-kod-analiza.md)
10. [Kod — implementacja (build)](10-kod-implementacja.md)
11. [⭐ Kod — propozycja i review](11-kod-propozycja-review.md)
12. [Bezpieczeństwo](12-bezpieczenstwo.md)
13. [Skille](13-skille.md)
14. [MCP ⭐](14-mcp.md)
15. [Podagenci ⭐](15-podagenci.md)
16. [LLM Wiki](16-llm-wiki.md)
17. [Instalacja lokalna — opencode + PLGrid](17-instalacja-lokalna.md)
