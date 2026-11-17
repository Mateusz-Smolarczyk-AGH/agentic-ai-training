# Czego chat nie umie — brak narzędzi

[← Poprzednia: Chat w praktyce — wiedza modelu](04-chat-w-praktyce.md) · [Agenda](00-agenda.md) · [Następna: Teoria — agent i harness →](06-teoria-agent.md)

Teraz coś, czego model **nie ma w wiedzy**: stan lokalny, dzisiejsza pogoda, zawartość pliku.

> 🚀 **Wklej do opencode:** uruchom opencode, przełącz się na agenta `chat` (Shift+Tab) i
> wklej jedno z pytań:

```text
Jaka wersja opencode jest tu zainstalowana? Sprawdź poleceniem, nie zgaduj.
```

```text
Co jest w pliku README.md? Podaj pierwszą linię.
```

```text
Jaka jest dziś pogoda w Krakowie?
```

`chat` **nie może** tego sprawdzić — zgaduje albo odmawia.

> Uwaga: agent `chat` ma w prompcie jasny rozkaz: nie ma narzędzi, więc ma **powiedzieć wprost**,
> że tego nie sprawdzi, i nie próbować. To nie jest usterka — to właśnie różnica, którą
> pokazujemy: rozmowa bez narzędzi nie może zweryfikować niczego.

## Gotowe, gdy…

- widziałeś, że bez narzędzi chat nie sprawdzi niczego lokalnego ani bieżącego.

---

[← Poprzednia: Chat w praktyce — wiedza modelu](04-chat-w-praktyce.md) · [Agenda](00-agenda.md) · [Następna: Teoria — agent i harness →](06-teoria-agent.md)
