# Known bugs in the mini-project (start version)

`examples/mini-projekt/app.py` in the start version has **two deliberate corner-case bugs**.
This is the instructor's checklist — do not give it to the agent before its own review.

## Bug 1 — `median`: even-length list

`median` picks only the middle element and does not average the two middle ones.

- **Call that shows it:** `python3 examples/mini-projekt/app.py median 1 2 3 4`
- **Start version returns:** `3`
- **Expected:** `2.5`
- **Fix:** for an even length, average `ordered[mid - 1]` and `ordered[mid]`.

## Bug 2 — `count`: case and punctuation

`word_counts` splits on whitespace and keeps words **as they arrived** — case and punctuation
make them different words.

- **Call that shows it:** `python3 examples/mini-projekt/app.py count "Hello hello, hello"`
- **Start version returns:** `Hello: 1`, `hello,: 1`, `hello: 1` (three different "words" for the same one)
- **Expected:** `hello: 3`
- **Fix:** normalise the word — `lower()` and strip punctuation (e.g. `re.sub(r"[^\w]", "", word)`).

## These are NOT bugs (deliberate behaviour)

- `average` with no arguments returns `0.0` — the boundary is deliberately quiet, "nothing crashes".
- `mode 1 2 2 3` returns `2` — the first largest number of occurrences; ties are broken by
  ascending order. This content must be the same before and after the review.

## Version after the review

After the fixes the program has the commands `average`, `median`, `mode`, `count` plus **`p95`**
added earlier in part 1 (the exercise "the plan cannot, build changes"). `p95 10 20 30 40 50`
should return a value between the median (30) and the maximum (50) — with the linear method
`48.0`.
