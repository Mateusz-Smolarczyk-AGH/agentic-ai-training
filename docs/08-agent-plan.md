# Agent plan — odpowiedź, której chat nie umiał

[← Poprzednia: Obsługa opencode](07-obsluga-opencode.md) · [Agenda](00-agenda.md) · [Następna: Kod — analiza (plan) →](09-kod-analiza.md)

Te same pytania co w [Czego chat nie umie](05-czego-chat-nie-umie.md), ale teraz agent `plan` ma
narzędzia.

> 🚀 **Wklej do opencode:** przełącz się (Shift+Tab) na agenta `plan` i wklej **te same**
> pytania, co w [Czego chat nie umie](05-czego-chat-nie-umie.md).

Teraz `plan` **wywołuje narzędzia**. Zobaczysz surowe **wywołanie narzędzia** (np. `bash` z
poleceniem, `read` z plikiem, `webfetch` z adresem) — zatwierdź je i patrz na wynik.

## Co obserwować

- **Jakie narzędzie** wybrał (`bash`, `read`, `webfetch`) i **z jakimi argumentami**.

Agent **ma oczy** — szuka i czyta, **wzbogaca kontekst**.

## Gotowe, gdy…

- widziałeś różnicę: chat zgaduje, plan sprawdza,
- rozpoznajesz surowe wywołanie narzędzia w sesji,
- umiesz narysować pętlę model → narzędzie → obserwacja.

---

[← Poprzednia: Obsługa opencode](07-obsluga-opencode.md) · [Agenda](00-agenda.md) · [Następna: Kod — analiza (plan) →](09-kod-analiza.md)
