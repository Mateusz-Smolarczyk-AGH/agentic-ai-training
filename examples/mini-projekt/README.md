# Mini-project

A small set of statistics and text tools (`app.py`) that we use to practise: changing code
with the `build` agent, proposals with a choice (the `question` tool) and **review with bug
fixes**.

## See how it works

```bash
python3 examples/mini-projekt/app.py average 1 2 3
python3 examples/mini-projekt/app.py median 1 2 3 4
python3 examples/mini-projekt/app.py mode 1 2 2 3
python3 examples/mini-projekt/app.py count "Hello hello, hello"
```

## Important: the code has deliberate bugs

`app.py` **works**, but it has a few deliberate **corner-case** bugs — nothing crashes, the
results are simply wrong in some situations. We do not list them here: you will find them with
the agent in the review block — [docs/11-kod-propozycja-review.md, part 3](../../docs/11-kod-propozycja-review.md).

> For the instructor: the bugs are known and intentional; after the review participants fix
> them, and `bash scripts/reset-demo.sh` restores the original. The reset restores from the git
> **index** — so after editing `examples/` you must `git add` or commit for the reset to be a
> real reset.

## Back to the initial state

```bash
bash scripts/reset-demo.sh
```
