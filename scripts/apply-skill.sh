#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "$ROOT/.opencode/skills/monthly-report"
cat > "$ROOT/.opencode/skills/monthly-report/SKILL.md" <<'MD'
---
name: Monthly report
description: Builds a monthly financial report (revenue, costs, result, margin) from multi-currency data, converting every amount to PLN at current NBP rates. Use when asked for a financial report, a spending and profit summary, or a monthly close.
---

# Monthly report

## When to use
When the user asks for a monthly financial report, a spending and profit summary, or a
monthly close based on data.

## Input
By default `examples/finance/transactions.csv` (columns: date, description, category, type, amount, currency).
If the user points to another file — use theirs.

## Workflow
1. Load the data. Split **income** (`type=income`) from **costs** (`type=expense`).
2. Sum the amounts **separately in each currency** (do not mix currencies in one sum).
3. **Mandatory rule — convert to PLN at the CURRENT NBP rate.** Every amount
   in a currency other than PLN convert to złoty at the **average rate of NBP table A**. Fetch the rates
   with the `webfetch` tool from the NBP API:
   `https://api.nbp.pl/api/exchangerates/tables/A/?format=json`
   Never convert from memory and never leave an amount in a foreign currency. Remember the publication
   date of the table and the rates you used.
4. Compute the result (`revenue − costs`) and the margin (`result / revenue`).
5. Build the report exactly in the format below.

## Format (follow exactly)

```
# Monthly report: <month YYYY>

## Summary
- Revenue: <P> PLN
- Costs: <K> PLN
- Result: <P−K> PLN (margin <m>%)

## NBP rates (table A, <published date>)
| Currency | Average rate (PLN) |
|----------|--------------------|
| EUR | <rate> |
| USD | <rate> |
| GBP | <rate> |

## Costs by category (PLN)
| Category | Cost (PLN) |

## Recommendation
- <one sentence>
```

In the rates table list only the currencies that actually appeared in the data. Remove the rows for
unused currencies.

## Pitfalls
- Do not sum different currencies together — convert to PLN first, only then sum.
- The rates MUST come from NBP (current); give the table date. If there is no internet, report it
  plainly instead of guessing a rate.
- Round amounts to 2 decimals, the margin to 1 decimal.
- Exactly one bullet in "Recommendation".
- No sections outside the format and no preamble ("Here is the report…").
MD

echo "Created .opencode/skills/monthly-report/SKILL.md"
