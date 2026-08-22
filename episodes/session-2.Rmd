---
title: "Create a Draft Salmon Data Package"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- What must I set up before running the demo?
- Should I run the included example or substitute my own files?
- What input structures does `create_sdp()` support?
- What happens if I rerun package generation after manual edits?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Confirm the project, `raw_data/`, `context/`, and `output/` layout before the demo.
- Run the included example unchanged, using it only to generate and inspect templates.
- Distinguish the example path from the learner-owned data path.
- Identify supported single-table, multi-table, and workbook inputs.
- Protect reviewed metadata by choosing deliberate rerun behavior.

::::::::::::::::::::::::::::::::::::::::::::::::

## Before the demo: open the project and create folders

Work from one project root so every path in the lesson is relative and reproducible.

1. R users: in RStudio choose **File > New Project**, then create a new project or open the folder you prepared during setup.
2. Confirm that the working project is `salmon-data-workshop/`; do not call `setwd()` to jump elsewhere.
3. Create the input, context, and output folders before calling `create_sdp()`.

```r
# Run from the open RStudio Project root.
dir.create("raw_data", showWarnings = FALSE)
dir.create("context", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
```

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  raw_data/                   # unchanged source files
  context/                    # codebooks, methods, and caveats
  output/                     # generated package folders
```

## Choose one of two paths

| Path | What to do now | What to change |
| --- | --- | --- |
| A: included example | Run the first code block exactly as written. | Change nothing. This is the fastest way to see the generated metadata templates. |
| B: personal data | First read Path A, then move to Session 3. Put your source files in `raw_data/`. | Replace the input path, object name, dataset/table IDs, and output folder with values for your files. |

Do not partly combine the two paths by reading the example but assigning your real dataset ID, or by reading your own data and leaving the example output folder. That makes review and reruns difficult to interpret.

## What "draft" means

A draft package is allowed to contain blanks, placeholders, and review markers. The first example has one purpose: generate the package structure and starter metadata so you can inspect it. It is not a finished description of the source dataset and it does not export EML yet.

## Path A: generate the simple R example

`metasalmon` includes a small NuSEDS-derived practice table. Generate its templates with semantic searching turned off so the first result is fast and local.

```r
library(metasalmon)

# Locate and read the small example bundled with metasalmon.
data_path <- system.file(
  "extdata",
  "nuseds-fraser-coho-sample.csv",
  package = "metasalmon"
)

fraser_coho <- readr::read_csv(
  data_path,
  show_col_types = FALSE
)

# Generate a new package once. overwrite = FALSE protects an existing folder.
pkg_path <- create_sdp(
  fraser_coho,
  path = file.path("output", "fraser-coho-example-sdp"),
  dataset_id = "fraser-coho-example",
  table_id = "escapement",
  seed_semantics = FALSE,
  check_updates = FALSE,
  overwrite = FALSE
)

list.files(pkg_path, recursive = TRUE)
```

`seed_semantics = FALSE` is the fast classroom option. It skips live searches for links to shared definitions. Session 4 shows how to run those searches after the starter metadata has been reviewed.

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent for Path A

Run this block instead of the R block if you are following the Python companion path.

```python
from importlib.resources import files
from pathlib import Path

import pandas as pd
from metasalmonpy import create_sdp

data_path = files("metasalmonpy.data").joinpath(
    "nuseds-fraser-coho-sample.csv"
)

fraser_coho = pd.read_csv(data_path)

pkg_path = create_sdp(
    fraser_coho,
    path=Path("output") / "fraser-coho-example-sdp",
    dataset_id="fraser-coho-example",
    table_id="escapement",
    seed_semantics=False,
    check_updates=False,
    overwrite=False,
)

for path in sorted(
    path for path in pkg_path.rglob("*") if path.is_file()
):
    print(path.relative_to(pkg_path))
```

The R and Python packages bundle separate practice fixtures. They demonstrate the same core package structure, but do not use their row counts to test cross-language parity. Each writer also leaves a hidden bookkeeping file (`.metasalmon-package` in R, `.metasalmonpy-package` in Python). Note that `metasalmonpy` 0.2.1 writes the earlier `sdp-0.2.0` package shape; the final EML and KNB workflow taught here runs in R against the current `sdp-0.3.0` specification.

::::::::::::::::::::::::::::::::::::::::::::::::

## Inspect the generated templates

Open these files in this order:

1. `README-review.txt`
2. `metadata/column_dictionary.csv`
3. `metadata/tables.csv`
4. `metadata/dataset.csv`
5. `metadata/codes.csv`, when present
6. `semantic_suggestions.csv`, when present

Expected structure:

```text
output/fraser-coho-example-sdp/
  README-review.txt
  datapackage.json
  .metasalmon-package          # hidden writer bookkeeping file; leave it alone
  metadata/
    dataset.csv
    tables.csv
    column_dictionary.csv
    codes.csv                  # present when categorical columns exist
  data/
    escapement.csv
```

If semantic seeding is enabled later, the package may also include `semantic_suggestions.csv`, and metadata fields may contain `REVIEW: <iri>` draft values. An **IRI** is a stable web identifier for a shared term. The `REVIEW:` prefix means that the proposed match has not been accepted.

## What input structures are supported?

`create_sdp()` does not open an arbitrary source file by itself. First use an appropriate reader to create R data frames; then pass one data frame or a named list of data frames.

| Source | Preparation | `create_sdp()` input |
| --- | --- | --- |
| One CSV or flat table | `readr::read_csv()` | One data frame; `table_id` supplies its table name. |
| Multiple CSVs | Read each CSV separately. | A named list such as `list(escapement = ..., sites = ...)`. |
| Excel workbook with several sheets | Use `readxl::read_excel()` once per rectangular sheet/table. | A named list, with safe unique table IDs as names. |
| NetCDF, raster, nested arrays | Not directly supported by this tabular workflow. | Use a format-specific packaging workflow, or a reviewed tabular derivative that does not misrepresent the source. |

The output data resources are CSV. Keep merged headings, presentation-only rows, subtotals, and multiple tables on one sheet out of the rectangular data frames passed to `create_sdp()`.

## Reruns and manual edits

The safest rule is: **generate once, then review the package you generated**.

| Situation | Safe action |
| --- | --- |
| The output folder does not exist | Run with `overwrite = FALSE`. |
| The example folder already exists and you have not edited it | Use a new output name, or deliberately remove the disposable example outside the lesson before recreating it. |
| You manually edited `metadata/*.csv` | Do not rerun `create_sdp()` on the same path. Continue with `read_salmon_datapackage()` and validation. |
| You need a new version after review | Read the reviewed package and write a new versioned folder; Session 6 shows this later workflow. |

In current R/`metasalmon`, `overwrite = TRUE` re-infers and replaces package files owned by the writer, including canonical metadata and declared data resources. Manual edits to those files can therefore be lost. Version 0.2.0 and later preserve non-owned sidecars by default, but `prune = TRUE` empties the package first and can remove them. Neither option is a substitute for a versioned backup or Git history.

Python participants should use the same conservative rule: after manual review, choose a new output path instead of assuming that R and Python overwrite behavior is identical.

## Field definitions and accepted values

Use the [SDP field reference][sdp-field-reference] while editing. Four fields that commonly cause confusion are:

| Field | Meaning | Accepted values or rule |
| --- | --- | --- |
| `column_role` | What the column does in the table | `identifier`, `attribute`, `temporal`, `categorical`, or `measurement` |
| `value_type` | The basic type of values in the source column | `integer`, `number`, `string`, `boolean`, `date`, or `datetime` |
| `required` | Whether every data row must contain a value in this source column | `TRUE`, `FALSE`, or blank; this is different from whether an SDP metadata field itself is required. |
| `unit_label` / `unit_iri` | A readable unit and its stable identifier | `unit_label` is text; `unit_iri` is required for measurement rows and must be a valid absolute IRI. |

Validation messages identify the file, field, and row context when possible. Fix the source metadata rather than suppressing the error or adding a non-standard header.

In R/`metasalmon` 0.2.0 and later, the column dictionary's `value_type` is the type authority when a package is read. A token that does not satisfy the declared type is retained for diagnosis instead of being silently converted to `NA`; validation reports the mismatch. This makes accurate `value_type` review part of data preservation, not cosmetic documentation.

## Spreadsheet/CSV-template path

Download or clone the `smn-data-pkg` repository and copy the [blank SDP CSV template][sdp-template], then open its metadata CSV files in Excel, LibreOffice Calc, or another spreadsheet editor. There is no standalone workbook or template ZIP. Keep the folder structure and header rows exactly as provided.

Minimum steps:

1. Export each source table as a CSV under `data/`.
2. Fill one row in `metadata/dataset.csv`.
3. Fill one row in `metadata/tables.csv` for each data table.
4. Fill one row in `metadata/column_dictionary.csv` for each data column.
5. When any column has `column_role = categorical`, document every observed non-empty value in `metadata/codes.csv`.
6. Optionally write a short README/context note with caveats, methods, and known limitations.
7. Hand the package to `metasalmon` to generate and check `datapackage.json`, run strict validation, and later export EML.

The spreadsheet path is valid when it produces the same canonical CSV metadata that the code packages use. The blank template intentionally omits `datapackage.json`; a complete or published package needs the generated descriptor as well.

## Review-state validation

Early validation should catch structure problems without requiring all links to shared definitions to be complete.

```r
review_check <- validate_salmon_datapackage(
  pkg_path,
  require_iris = FALSE
)

review_check$semantic_validation$issues
review_check$semantic_validation$missing_terms
```

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

```python
from metasalmonpy import validate_salmon_datapackage

review_check = validate_salmon_datapackage(
    pkg_path,
    require_iris=False,
)

print(review_check["semantic_validation"]["issues"])
print(review_check["semantic_validation"]["missing_terms"])
```

::::::::::::::::::::::::::::::::::::::::::::::::

`require_iris = FALSE` allows links to shared definitions to remain unfinished during draft review. Warnings about missing measurement links, placeholders, or `REVIEW:` markers can be acceptable in review state. Use strict R validation only when the package is publication-ready.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Generate and inspect the example templates

Run Path A unchanged, then answer:

- Where is the data table?
- Which metadata file describes the dataset, each table, each column, and categorical codes?
- Which fields still need human review?
- What would you replace when moving to your own data?
- Why would `overwrite = TRUE` be risky after manual edits?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Prepare the project and folders before the demo.
- Run the included example unchanged to learn the generated package shape.
- `create_sdp()` accepts one data frame or a named list of tabular data frames, not arbitrary scientific file structures.
- The field reference is the source for definitions and allowed values.
- Protect manual edits: do not casually rerun `create_sdp(..., overwrite = TRUE)` on a reviewed package.

::::::::::::::::::::::::::::::::::::::::::::::::
