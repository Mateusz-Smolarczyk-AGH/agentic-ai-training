# MCP ⭐

[← Poprzednia: Skille](13-skille.md) · [Agenda](00-agenda.md) · [Następna: Podagenci ⭐ →](15-podagenci.md)

> **⭐ Zadanie dodatkowe, opcjonalne** — dla osób, które pójdą szybciej. Jeśli brakuje czasu,
> zrób je po szkoleniu.

## Co to jest

**MCP (Model Context Protocol)** to standard podłączania **zewnętrznych serwerów narzędzi**.
Zamiast pisać narzędzie samodzielnie, uruchamiasz serwer MCP, a opencode widzi jego narzędzia
tak samo, jak wbudowane. Serwer może działać lokalnie albo zdalnie.

## Jak działa

1. Dopisujesz serwer do sekcji `mcp` w `.opencode/opencode.json`.
2. opencode uruchamia serwer (np. przez `npx`).
3. Agent dostaje **nowe narzędzia** od tego serwera i może ich używać.

## Jak dodać (przykład: context7)

`context7` to serwer, który daje agentowi aktualną dokumentację bibliotek. Nie wymaga klucza.

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/apply-mcp.sh
```

Skrypt dodaje do `.opencode/opencode.json`:

```json
{
  "mcp": {
    "context7": {
      "type": "local",
      "enabled": true,
      "command": ["npx", "-y", "@upstash/context7-mcp"]
    }
  }
}
```

> 🛠️ **Zrób sam:** dopisz powyższy fragment do `.opencode/opencode.json` (zachowaj poprawny JSON).
> Jeśli chcesz własny serwer, zmień `command` na polecenie startujące Twój serwer MCP.

## Jak przetestować

> Config działa od razu — **bez restartu**. W tej samej sesji:

1. Zapytaj agenta `plan`:

```text
Użyj context7, żeby sprawdzić aktualny sposób tworzenia aplikacji w FastAPI.
Podaj krótki przykład i powołaj się na dokumentację.
```

2. Zobacz, że agent **wywołuje narzędzie MCP** (nie zgaduje).

## Jak sprawdzić, że działa

- w sesji widać wywołanie narzędzia pochodzącego z serwera `context7`,
- odpowiedź powołuje się na dokumentację, a nie na „pamięć” modelu.

## Uwaga

`context7` startuje przez `npx`, więc na węźle musi być Node.js. Jeśli nie ma — instruktor
podpowie inny serwer MCP.

## Gotowe, gdy…

- `.opencode/opencode.json` zawiera działającą sekcję `mcp`,
- agent wywołał narzędzie MCP i dostał wynik,
- umiesz wyjaśnić, czym MCP różni się od wbudowanego narzędzia.

---

[← Poprzednia: Skille](13-skille.md) · [Agenda](00-agenda.md) · [Następna: Podagenci ⭐ →](15-podagenci.md)
