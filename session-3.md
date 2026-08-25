---
title: "Use Your Data and Capture Context"
teaching: 50
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- How do I replace the included example with my own source files?
- How do I represent one dataset that contains several CSVs or workbook sheets?
- What belongs in structured metadata versus a README/context note?
- How can context improve later term mapping without being sent to an unapproved service?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Read learner-owned source files from `raw_data/` using reproducible relative paths.
- Pass either one table or a named list of tables to `create_sdp()`.
- Keep a multi-table dataset distinct from its individual tables.
- Write useful dataset, table, column, and code descriptions.
- Draft a compact README/context note for reviewers and mapping tools.

::::::::::::::::::::::::::::::::::::::::::::::::

## Replace the quickstart with your data

Session 2 used an included dataset, ID, table name, and output folder. For personal data, replace all four together:

| Example element | Replace with |
| --- | --- |
| Bundled `system.file()` path | A relative path under `raw_data/` |
| `fraser_coho` object | An object name that describes your table |
| `fraser-coho-example` and `escapement` IDs | Stable IDs for your dataset and table |
| `output/fraser-coho-example-sdp` | A new output folder for your package |

Keep source files unchanged under `raw_data/`, explanatory files under `context/`, and generated packages under `output/`.

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  raw_data/
    my-salmon-data.csv
    related-sites.csv
    my-salmon-workbook.xlsx
  context/
    source-data-dictionary.csv
    methods-and-caveats.md
  output/
    my-salmon-sdp/
```

Use only files you are allowed to bring to the workshop. Do not send source or context files to an external service unless that use is approved.

## Create the package in your software lane

Choose the same R, Python, or Spreadsheet lane you used for the quickstart. The code lanes create the package for you. The spreadsheet lane shows how to assemble the same standard files manually when you cannot run either package.

::::::::::::::::::::::::::::::::::::: group-tab

## R

**One flat CSV**

This is the direct replacement for the quickstart:

```r
library(metasalmon)

# Read one rectangular source table from the project folder.
own_data_path <- file.path(
  "raw_data",
  "my-salmon-data.csv"
)

own_data <- readr::read_csv(
  own_data_path,
  show_col_types = FALSE
)

# Use a new output path. Do not overwrite the reviewed example or an older package.
pkg_path <- create_sdp(
  own_data,
  path = file.path("output", "my-salmon-sdp"),
  dataset_id = "my-salmon-data",
  table_id = "observations",
  seed_semantics = FALSE,
  check_updates = TRUE,
  overwrite = FALSE
)
```

**Several CSV tables in one dataset**

A dataset can contain several related tables. Read each one, give each a safe unique `table_id`, and pass a **named list**. The list names become table IDs, so use letters, numbers, and underscores rather than workbook display labels with spaces.

```r
# Each list element is one rectangular table in the same dataset.
tables <- list(
  escapement = readr::read_csv(
    file.path("raw_data", "escapement.csv"),
    show_col_types = FALSE
  ),
  sites = readr::read_csv(
    file.path("raw_data", "sites.csv"),
    show_col_types = FALSE
  )
)

multi_pkg_path <- create_sdp(
  tables,
  path = file.path("output", "my-multi-table-sdp"),
  dataset_id = "my-multi-table-dataset",
  seed_semantics = FALSE,
  check_updates = TRUE,
  overwrite = FALSE
)
```

The package gets one `dataset.csv` row, two `tables.csv` rows, one data CSV per table, and one `column_dictionary.csv` row for every column in both tables.

**Excel workbook with several sheets**

An Excel workbook is a container. Read each rectangular sheet separately and pass the resulting named list just as you did for several CSVs.

```r
workbook_path <- file.path(
  "raw_data",
  "my-salmon-workbook.xlsx"
)

# Use explicit sheet names so the import is reviewable and reproducible.
workbook_tables <- list(
  escapement = readxl::read_excel(
    workbook_path,
    sheet = "Escapement"
  ),
  sites = readxl::read_excel(
    workbook_path,
    sheet = "Sites"
  )
)

workbook_pkg_path <- create_sdp(
  workbook_tables,
  path = file.path("output", "my-workbook-sdp"),
  dataset_id = "my-workbook-dataset",
  seed_semantics = FALSE,
  check_updates = TRUE,
  overwrite = FALSE
)
```

## Python

Start Python from the same project root and use the same folder layout.

**One flat CSV**

```python
from pathlib import Path

import pandas as pd
from metasalmonpy import create_sdp

project_root = Path.cwd()
own_data_path = project_root / "raw_data" / "my-salmon-data.csv"

own_data = pd.read_csv(own_data_path)

pkg_path = create_sdp(
    own_data,
    path=project_root / "output" / "my-salmon-sdp",
    dataset_id="my-salmon-data",
    table_id="observations",
    seed_semantics=False,
    check_updates=True,
    overwrite=False,
)
```

**Several CSV tables in one dataset**

Use a dictionary whose keys are safe table IDs and whose values are pandas DataFrames.

```python
tables = {
    "escapement": pd.read_csv(
        project_root / "raw_data" / "escapement.csv"
    ),
    "sites": pd.read_csv(
        project_root / "raw_data" / "sites.csv"
    ),
}

multi_pkg_path = create_sdp(
    tables,
    path=project_root / "output" / "my-multi-table-sdp",
    dataset_id="my-multi-table-dataset",
    seed_semantics=False,
    check_updates=True,
    overwrite=False,
)
```

**Excel workbook with several sheets**

Pandas uses `openpyxl` to read `.xlsx` workbooks. Read each rectangular sheet explicitly and give it a safe table ID.

```python
workbook_path = project_root / "raw_data" / "my-salmon-workbook.xlsx"

workbook_tables = {
    "escapement": pd.read_excel(
        workbook_path,
        sheet_name="Escapement",
    ),
    "sites": pd.read_excel(
        workbook_path,
        sheet_name="Sites",
    ),
}

workbook_pkg_path = create_sdp(
    workbook_tables,
    path=project_root / "output" / "my-workbook-sdp",
    dataset_id="my-workbook-dataset",
    seed_semantics=False,
    check_updates=True,
    overwrite=False,
)
```

## Spreadsheet

Copy the [blank SDP CSV template][sdp-template] into a new folder under `output/`. Keep your original table unchanged under `raw_data/`, save a rectangular CSV copy under the package's `data/` folder, and fill the canonical CSVs under `metadata/` using the [SDP field reference][sdp-field-reference].

For a dataset with several tables, add one row per table to `metadata/tables.csv`, one dictionary row per column to `metadata/column_dictionary.csv`, and one CSV per table under `data/`. Preserve the template headers and folder structure. Spreadsheet review can prepare the package metadata, but it does not run automated validation.

::::::::::::::::::::::::::::::::::::::::::::::::

The R and Python implementations create the same current SDP structure. The spreadsheet lane edits that structure directly.

Clean presentation artifacts before packaging: repeated headings, merged cells, notes above the header, subtotals, and two unrelated tables on one sheet are not one flat table. Keep the original workbook unchanged in `raw_data/` and document any transformation.

NetCDF is not an Excel-like multi-table container. Its dimensions, coordinates, arrays, and attributes are not preserved by this workflow, so do not present a flattened extract as the complete source unless that derivative has been explicitly reviewed and described.

## Protect reviewed work when you rerun

The safest rule is: **generate a draft once, then treat the package you review as the current source state**.

| Situation | Safe action |
| --- | --- |
| The output folder does not exist | Generate the draft with `overwrite = FALSE` / `overwrite=False`. |
| A disposable quickstart folder already exists | Use a new output name, or deliberately remove that disposable example outside the lesson before recreating it. |
| You manually edited `metadata/*.csv` | Do not rerun `create_sdp()` on the same path. Continue with `read_salmon_datapackage()` and validation. |
| You need a new version after review | Read the reviewed package and write a new versioned folder; Chapter 6 shows this workflow. |

In both language implementations, `overwrite = TRUE` / `overwrite=True` re-infers and replaces files owned by the package writer. That can erase manual edits to canonical metadata or declared data resources. `prune = TRUE` / `prune=True` is more destructive because it empties the package before rewriting it. Neither option replaces a versioned backup or Git history.

## Read supporting context separately

Source dictionaries, methods notes, and provenance documents help people review the inferred templates. Reading these files does not automatically merge them into `column_dictionary.csv`; you still decide which statements belong in canonical metadata.

::::::::::::::::::::::::::::::::::::: group-tab

## R

```r
source_dictionary <- readr::read_csv(
  file.path("context", "source-data-dictionary.csv"),
  show_col_types = FALSE
)

context_note <- readr::read_file(
  file.path("context", "methods-and-caveats.md")
)

context_paths <- list.files(
  "context",
  full.names = TRUE,
  recursive = TRUE
)
```

## Python

```python
from pathlib import Path

import pandas as pd

context_dir = Path("context")

source_dictionary = pd.read_csv(
    context_dir / "source-data-dictionary.csv"
)
context_note = (
    context_dir / "methods-and-caveats.md"
).read_text(encoding="utf-8")
context_paths = sorted(
    path for path in context_dir.rglob("*") if path.is_file()
)
```

## Spreadsheet

Open the source dictionary beside the package metadata, and keep the methods/caveats note visible while reviewing dataset, table, column, and code descriptions. Copy only reviewed statements into canonical metadata; preserve longer narrative context in the note.

::::::::::::::::::::::::::::::::::::::::::::::::

`context_paths` can be reviewed directly and can later be supplied to optional, approved LLM-assisted review. Merely creating the vector does not send the files anywhere.

## Context is part of the data

Many data holders hesitate to share data because they know the spreadsheet can be misread. A Salmon Data Package should make that local knowledge visible.

Use metadata tables for structured facts. Use a README/context note for the narrative a reviewer needs before interpreting the package.

## What goes where?

| Context | Best place |
| --- | --- |
| Dataset purpose, contact, license, coverage | `metadata/dataset.csv` |
| What each row represents | `metadata/tables.csv` |
| What each column means | `metadata/column_dictionary.csv` |
| What stored code values mean | `metadata/codes.csv` |
| Caveats, known exclusions, methods, unusual values | README/context note |

## Description checks

A useful column description usually answers:

- What is this field?
- What does each value represent?
- What unit or format is expected?
- How was the value created, observed, or derived?
- What should a reviewer not assume?

Example:

| Too brief | More useful |
| --- | --- |
| `Count` | Estimated count of naturally spawning adult coho salmon for the listed population and return year. |
| `Date` | Date when the field observation occurred, recorded as `YYYY-MM-DD`. |
| `Origin` | Stored code describing whether fish were classified as natural-origin, hatchery-origin, mixed, or unknown. |

## README/context note

Keep the note short enough that a contributor will actually write it.

Suggested sections:

```text
# Context for <dataset name>

## What this dataset is for
## What each row represents
## Methods and source documents
## Constraints, caveats, and known exclusions
## Codes, unusual values, and missing values
## Questions for reviewers
```

This note is useful for people and for optional LLM-assisted review. It gives mapping tools evidence that is not visible from column names alone.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Move from the example to your data

Choose the single-CSV, multi-CSV, or workbook pattern that matches your source.

Then:

1. confirm the dataset ID and every table ID;
2. generate a package at a new path with `overwrite = FALSE`;
3. improve the dataset description, one table description, and five column descriptions; and
4. write one README/context-note section.

Mark anything you are unsure about as a reviewer question rather than hiding it.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Replace the example input, IDs, object name, and output path together.
- One dataset may contain one or many tables; pass multiple tables as a named list.
- CSV and rectangular Excel sheets are supported after import to data frames; NetCDF is not directly supported.
- Metadata tables hold structured facts; README/context notes hold narrative caveats.
- A clear description is more valuable than an uncertain link to a shared definition.

::::::::::::::::::::::::::::::::::::::::::::::::
