# Reading sources without losing any of it

Companion to `SKILL.md` ("Ingest — turn sources into concept pages"). Load this the first time you touch a non-markdown source.

## Why fragments (the anti-truncation guarantee)

Reading a very large document in one shot truncates or silently skips sections. That is
exactly how material gets lost and the wiki ends up with a shallow, shortened version of a
source. So for anything long: **read it in small, ordered chunks and distil each chunk before
reading the next** — do not jump ahead, do not skim the middle.

The unit of fragmentation is the format's own structure:

| Format | Fragment = |
|---|---|
| PDF / legal or normative text | the structural unit — `Article N`, `§`, `Chapter`, `Annex`, numbered clause |
| PDF / report, manual, spec | the heading-styled section |
| `.docx` | the `Heading*`-styled block |
| `.xlsx` | the **sheet**, then coherent row-blocks within it |
| `.md` / `.txt` / unknown | a bounded number of lines (a few hundred), start to finish |

**Verify completeness explicitly.** After distilling a large source, re-open the raw/extracted
text and cross-check: every structural unit you intended to cover has a matching concept page,
body section, or index note. Do not declare a source "ingested" until every unit is accounted
for.

## Extract to a working file first (never read a big source through `read` alone)

OpenCode's `read` can pass a PDF (and images) to the model, but it rejects `.docx`/`.xlsx` (they
are ZIP containers, so `read` fails with a binary error) and any other binary, and it truncates
large files. So for a real ingest **extract the text to a working file OUTSIDE the bundle and
outside `raw/`** (e.g. with `python-docx`/`openpyxl`/`pypdf`, written to `/tmp/<name>.txt`), then
slice that file. Extraction output is working material, not wiki content — never write it into
`raw/`.

## PDF (`pypdf`)

Some hosts have no `pdftotext`. A venv with `pypdf` may live at `/home/$USER/.pdfvenv` (that path
is an example, not a guarantee — check what your host has before assuming):

```bash
source /home/$USER/.pdfvenv/bin/activate   # if present; else use your PDF tooling
python3 - <<'EOF'
from pypdf import PdfReader
r = PdfReader('<path/to/raw/pdf>')
print('pages =', len(r.pages))
open('/tmp/out.txt','w').write("".join(
      "\n\n===== PAGE %d =====\n%s" % (i+1, (p.extract_text() or ""))
      for i,p in enumerate(r.pages)))
EOF
```

Then **slice the extracted text by its structural units** and read every slice. Map the
headings to line indexes and slice from one heading to the next; adapt the pattern to whatever
structure the source actually has (chapters, sections, spec sections, deliverable parts):

```python
import re
lines = open('/tmp/out.txt').read().split('\n')
# collect heading -> line index, e.g. Article N / Annex X / Chapter Y / § N
heads = []
for i,l in enumerate(lines):
    s = l.strip()
    m = (re.match(r'^(Article|Chapter|Section)\s+[\w]+', s)
         or re.match(r'^(Annex)\s+([IVX]+)\s*$', s)
         or re.match(r'^§\s*\d+', s))
    if m:
        heads.append((i, s))
print(heads)  # ordered (line, heading) — slice between consecutive entries
```

**PDF extraction mangles text in ways that break naive matching.** Whitespace inside words can
appear out of nowhere (`traci moc` → `traci mo c`), so **normalise before matching** (strip all
whitespace, or match on a whitespace-insensitive pattern). A strict clause pattern that ignored
this missed 19 files in one measured corpus.

## `.docx` (`python-docx`)

Walk the **body element** rather than `doc.paragraphs` + `doc.tables` separately — that keeps
paragraphs and tables in their true document order, and a table's placement often carries
meaning:

```bash
source /home/$USER/.pdfvenv/bin/activate
python3 - <<'EOF'
from docx import Document
from docx.table import Table
from docx.text.paragraph import Paragraph
doc = Document('<path/to/raw/file.docx>')
out = []
for child in doc.element.body.iterchildren():
    tag = child.tag.rsplit('}', 1)[-1]
    if tag == 'p':
        p = Paragraph(child, doc)
        style = (p.style.name or '') if p.style is not None else ''
        if p.text.strip():
            out.append(('## ' if style.startswith('Heading') else '') + p.text.strip())
    elif tag == 'tbl':
        t = Table(child, doc)
        out.append('===== TABLE =====')
        for row in t.rows:
            out.append(' | '.join(c.text.strip() for c in row.cells))
open('/tmp/out.txt','w').write('\n'.join(out))
print('lines =', len(out))
EOF
```

`Heading*` styles became `## ` lines: those are your **slicing headings** — slice from one to
the next, distil, continue.

**Stated limits of the extraction:** `python-docx` ignores footnotes, comments, tracked
changes, text boxes, headers/footers and embedded images. If the document materially depends on
those (say, comments carrying decisions), **say so** instead of presenting the extracted text as
"the whole document".

## `.xlsx` (`openpyxl`)

Read it **sheet by sheet, then row-block by row-block** — a workbook is a bundle of tables and
each sheet is the analogue of a chapter. Do not flatten the whole workbook into one blob and
skim it:

```bash
source /home/$USER/.pdfvenv/bin/activate
python3 - <<'EOF'
import openpyxl
wb = openpyxl.load_workbook('<path/to/raw/file.xlsx>', data_only=True, read_only=True)
for ws in wb.worksheets:
    print('===== SHEET:', ws.title, '| dims:', ws.calculate_dimension(), '=====')
    for r, row in enumerate(ws.iter_rows(values_only=True), 1):
        vals = [str(v).strip() for v in row if v is not None and str(v).strip()]
        if vals:
            print(r, '|', ' | '.join(vals))
EOF
```

Spreadsheet-specific care — this is where xlsx ingestion silently goes wrong:

- **A `None` from a formula is not an empty cell.** `data_only=True` returns the *cached* result,
  which is absent if the workbook was never opened/calculated in Excel. Re-run with
  `data_only=False`, read both views, and say which one you used.
- **Cells, not tables.** Anything can be anywhere: merged cells, blank columns as separators,
  several stacked tables on one sheet, repeated header rows. Never assume row 1 is the header
  or that a column is a clean field.
- **Formulas, hidden rows/columns and number formats are not semantics.** If a figure is
  critical and its origin is a formula, record the formula text, not only the computed number.
- **Write each sheet (or coherent block) as its own concept page/section**, with the sheet name
  and row range in the provenance (`Sheet!A12:D40`), so a claim is traceable.

## Unreadable formats — flag them, never fake them

- **Images** (`.png`/`.jpg`/`.tiff`, scans embedded in PDFs): no OCR is set up on this machine.
  Do **not** guess what an image says and do **not** paraphrase a picture from the model's own
  reading of it. Record the file as unreadable (`unreadable: no OCR`), and tell the user it
  needs OCR or a text version.
- **Legacy binary Office** (`.doc`, `.xls`, `.ppt` — pre-2007): `python-docx`/`openpyxl` read
  **only** OOXML (`.docx`, `.xlsx`) and will fail to open these. Flag the file and ask for a
  re-save/convert (LibreOffice, if installed). Never silently skip it and never treat a
  document as empty because a library refused it.
- A file under ~300 alphanumeric characters of extracted text is almost always a scan without a
  text layer — list it as unreadable **up front** instead of rediscovering it per source.

## Any other local file

Markdown, plain text, unknown extensions: read in bounded chunks (a few hundred lines) from
start to finish so no tail or middle section is lost.
