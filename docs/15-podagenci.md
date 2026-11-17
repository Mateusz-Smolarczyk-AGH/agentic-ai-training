# Podagenci ⭐ (zadanie dodatkowe)

[← Poprzednia: MCP ⭐](14-mcp.md) · [Agenda](00-agenda.md) · [Następna: Research agentowy →](16-agent-research.md)

> **⭐ Zadanie dodatkowe, opcjonalne** — dla osób, które pójdą szybciej.

## Co to jest

**Podagent** to **osobna sesja agenta**, do której delegujesz zadanie. Ma własny kontekst,
własne uprawnienia i własny model.

## Po co

- **osobny kontekst** — duże zadanie nie zaśmieca Twojej sesji,
- **ograniczone uprawnienia** — np. podagent tylko czyta,
- **osobny model** — tani do prostych zadań, mocny do trudnych.

## Jak działa

W `.opencode/opencode.json`, w sekcji `agent`, definiujesz agenta z `"mode": "subagent"`. Agent główny
może mu **delegować** zadanie przez specjalne narzędzie.

## Jak dodać (przykład: read-only rewiever)

> 🚀 **Wpisz `!` i wklej do opencode:**

```bash
bash scripts/apply-subagent.sh
```

Skrypt dodaje do `.opencode/opencode.json`:

```json
{
  "agent": {
    "rewiever": {
      "description": "Investigates how something works in the repository. Read-only.",
      "mode": "subagent",
      "prompt": "Trace real code paths. Cite file:line. Distinguish what you verified from what you inferred. Answer the question you were asked; do not summarise the whole repository.",
      "permission": {
        "edit": "deny",
        "bash": { "*": "deny", "grep *": "allow", "ls *": "allow" }
      }
    }
  }
}
```

> 🛠️ **Zrób sam:** dopisz powyższy fragment do `.opencode/opencode.json`. Zwróć uwagę na `edit: deny` —
> podagent nie może zmieniać plików.

## Jak przetestować

> Config działa od razu — **bez restartu**. W tej samej sesji:

1. Wklej do agenta głównego:

```text
Zbadaj strukturę tego repozytorium i opisz, co robi każdy katalog.
Użyj podagenta `rewiever`.
```

## Jak sprawdzić, że działa

Podagent będzie widoczny jako `Rewiever Subagent — Zbadaj strukturę repozytorium`. Jeżeli w niego klikniemy możemy zobaczyć jego sesję. Główny agent, który dokonał delegacji nie widzi tej sesji - widzi tylko wynik. Pozwala to oszczędzać tokeny, mieć dedykowanych agentów do różnych zadań (dobierając odpowiednio modele).
Np. Osobny agent jako rewiev kodu na innym modelu.

## Gotowe, gdy…

- masz zdefiniowanego podagenta w `.opencode/opencode.json`,
- delegowałeś do niego zadanie,
- znalazłeś `subagent_type` w eksporcie sesji.

---

[← Poprzednia: MCP ⭐](14-mcp.md) · [Agenda](00-agenda.md) · [Następna: Research agentowy →](16-agent-research.md)
