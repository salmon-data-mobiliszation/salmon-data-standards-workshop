---
title: "Use Your Data and Capture Context"
teaching: 50
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- How do I replace the included example with my own source and context files?
- How do I represent one dataset that contains several CSVs or workbook sheets?
- What belongs in structured metadata versus a README/context note?
- How do I start a reproducible package-building script without automatically invoking an LLM?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Read learner-owned source files from `raw_data/` using reproducible relative paths.
- Build an R or Python script that recreates the package from its declared inputs.
- Pass either one table or a named list of tables to `create_sdp()`.
- Keep a multi-table dataset distinct from its individual tables.
- Write useful dataset, table, column, and code descriptions.
- Make context available to an optional, explicitly enabled LLM review.

::::::::::::::::::::::::::::::::::::::::::::::::

## Replace the quickstart with your data

Session 2 used the dataset included with the package. For this chapter, put your new dataset and its supporting context files in `raw_data/`. Context can include an existing data dictionary, methods notes, or a short description of caveats that are not visible in the table itself.

Create `scripts/build_sdp.R` if you are working in R, or `scripts/build_sdp.py` if you are working in Python. Run the script from the workshop project root. From this point onward, that script records how the unchanged source tables and context inputs in `raw_data/` become a Salmon Data Package under `output/`.

## Create the SDP Using a Reproducible Script

The R and Python tabs show the same reproducible workflow. The Spreadsheet tab explains how to prepare the corresponding tidy inputs and inspect the package structure.

::::::::::::::::::::::::::::::::::::: group-tab

### R

Put this shared setup at the top of `scripts/build_sdp.R`. Listing the context files now makes the optional LLM-assisted route available later, but the `FALSE` toggle keeps that route off.

```r
library(metasalmon)

# Keep this FALSE unless you deliberately choose the optional LLM-assisted route.
use_llm_review <- FALSE

# Pass file paths, not data frames or parsed document objects, as LLM context.
context_files <- c(
  file.path("raw_data", "source-data-dictionary.csv"),
  file.path("raw_data", "methods-and-caveats.md")
)

# Declared inputs should fail clearly rather than disappear from the workflow.
stopifnot(all(file.exists(context_files)))
```

[One flat CSV]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

This is the direct replacement for the quickstart:

```r
# Read one rectangular source table from the project folder.
my_data <- readr::read_csv(
  file.path("raw_data", "my-salmon-data.csv"),
  show_col_types = FALSE
)

# Rebuild writer-managed package files from the script on each run.
pkg_path <- create_sdp(
  my_data,
  path = file.path("output", "my-salmon-sdp"),
  dataset_id = "my-salmon-data",
  table_id = "observations",
  seed_semantics = TRUE,
  llm_assess = use_llm_review,
  llm_context_files = if (use_llm_review) context_files else NULL,
  check_updates = FALSE,
  overwrite = TRUE
)
```

[Several CSV tables in one dataset]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

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
  seed_semantics = TRUE,
  llm_assess = use_llm_review,
  llm_context_files = if (use_llm_review) context_files else NULL,
  check_updates = FALSE,
  overwrite = TRUE
)
```

The package gets one `dataset.csv` row, two `tables.csv` rows, one data CSV per table, and one `column_dictionary.csv` row for every column in both tables.

[Excel workbook with several sheets]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

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
  seed_semantics = TRUE,
  llm_assess = use_llm_review,
  llm_context_files = if (use_llm_review) context_files else NULL,
  check_updates = FALSE,
  overwrite = TRUE
)
```

### Python

Put this shared setup at the top of `scripts/build_sdp.py` and run it from the same project root.

```python
from pathlib import Path

import pandas as pd
from metasalmonpy import create_sdp

project_root = Path.cwd()

# Keep this False unless you deliberately choose the optional LLM-assisted route.
use_llm_review = False

# Pass file paths, not DataFrames or parsed document objects, as LLM context.
context_files = [
    project_root / "raw_data" / "source-data-dictionary.csv",
    project_root / "raw_data" / "methods-and-caveats.md",
]

missing_context_files = [
    path for path in context_files if not path.is_file()
]
if missing_context_files:
    raise FileNotFoundError(
        f"Missing declared context files: {missing_context_files}"
    )
```

[One flat CSV]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

```python
my_data = pd.read_csv(
    project_root / "raw_data" / "my-salmon-data.csv"
)

pkg_path = create_sdp(
    my_data,
    path=project_root / "output" / "my-salmon-sdp",
    dataset_id="my-salmon-data",
    table_id="observations",
    seed_semantics=True,
    llm_assess=use_llm_review,
    llm_context_files=context_files if use_llm_review else None,
    check_updates=False,
    overwrite=True,
)
```

[Several CSV tables in one dataset]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

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
    seed_semantics=True,
    llm_assess=use_llm_review,
    llm_context_files=context_files if use_llm_review else None,
    check_updates=False,
    overwrite=True,
)
```

[Excel workbook with several sheets]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

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
    seed_semantics=True,
    llm_assess=use_llm_review,
    llm_context_files=context_files if use_llm_review else None,
    check_updates=False,
    overwrite=True,
)
```

### Spreadsheet

[One flat CSV]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

Copy the [blank SDP CSV template][sdp-template] into a new folder under `output/`. Keep your original table unchanged under `raw_data/`, save a rectangular CSV copy under the package's `data/` folder, and fill the canonical CSVs under `metadata/` using the [SDP field reference][sdp-field-reference].

[Several CSV tables in one dataset]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

For a dataset with several tables, add one row per table to `metadata/tables.csv`, one dictionary row per column to `metadata/column_dictionary.csv`, and one CSV per table under `data/`. Preserve the template headers and folder structure. Spreadsheet review can prepare the package metadata, but it does not run automated validation.

[Excel workbook with several sheets]{.h4 .d-block .mt-4 role="heading" aria-level="4"}

Treat each rectangular sheet as a separate table in the same dataset. Give every sheet a stable table ID, save it as a CSV under `data/`, and describe its columns in `metadata/column_dictionary.csv`.

::::::::::::::::::::::::::::::::::::::::::::::::

The R and Python implementations create the same current SDP structure. The spreadsheet lane edits that structure directly.

Before building the package, make each working table tidy: one variable per column, one observation per row, and one value per cell. Keep the original files in `raw_data/`, and perform any reshaping or removal of decorative spreadsheet content in the reproducible script so another person can see exactly how the package-ready table was produced.

## Grow the script into the review workflow

From this chapter onward, the files in `raw_data/` and the script are the reproducible source for the derived package. Do not rely on an unexplained manual edit inside `output/`: encode each accepted cleaning or metadata decision in the script so it is reapplied on the next run.

The data transformations and accepted review decisions can therefore be rerun deterministically from declared inputs. Candidate lookup is a separate step: shared vocabularies can evolve, so a later search may return different candidates. Record the IRI decisions you accept in the script rather than depending on a live search to make the same choice forever.

The complete workflow will grow across the remaining chapters:

| Stage | Reproducible action |
| --- | --- |
| Read and transform | Read unchanged source files and express every tidy-data transformation in R or Python. |
| Create a draft | Run `create_sdp()` with `seed_semantics = TRUE` / `seed_semantics=True`. |
| Review free text | Read the package with `read_salmon_datapackage()` and represent accepted description, contact, and licence decisions as code. |
| Review semantics | In R, decide each suggested IRI with `review_semantics()` and `accept_suggestion()` in Chapter 4, and write them with `apply_sdp_semantics()`. |
| Write | Write reviewed free-text state with `write_salmon_datapackage()`. Use a versioned path when the earlier package must be preserved. |
| Check | Run `validate_salmon_datapackage()` and fix the script or its declared inputs, then rerun. |

Two writers appear in that table, and they are not interchangeable. `write_salmon_datapackage()` rebuilds a whole package from in-memory objects, which is what a free-text edit needs. `apply_sdp_semantics()`, introduced in Chapter 4, changes only the decided cells and leaves every data CSV byte untouched, which is what a semantic decision needs.

In this script-backed workflow, `overwrite = TRUE` / `overwrite=True` deliberately rebuilds writer-managed files and then reapplies the decisions encoded below it. A manual edit that exists only in the generated folder can be replaced, which is why reviewed changes belong in the script or in a preserved, versioned package.

Do not use `prune = TRUE` / `prune=True` here, and Chapter 4 is where you would find out why: pruning deletes `semantic_suggestions.csv`, and with it the entire evidence base the semantic review reads. `review_semantics()` then reports that there is nothing to review, and the only way back is a full reseeding search.

The following small extension shows the free-text pattern. Later chapters add semantic review, EML export, and publication steps to the same workflow.

::::::::::::::::::::::::::::::::::::: group-tab

### R

```r
reviewed_pkg <- read_salmon_datapackage(pkg_path)

# Replace this example with the description agreed during review.
reviewed_pkg$dataset <- reviewed_pkg$dataset |>
  dplyr::mutate(
    description = "A reviewed description of this salmon dataset."
  )

pkg_path <- write_salmon_datapackage(
  resources = reviewed_pkg$resources,
  dataset_meta = reviewed_pkg$dataset,
  table_meta = reviewed_pkg$tables,
  dict = reviewed_pkg$dictionary,
  codes = reviewed_pkg$codes,
  path = pkg_path,
  overwrite = TRUE
)

validate_salmon_datapackage(
  pkg_path,
  require_iris = FALSE
)
```

### Python

```python
from metasalmonpy import (
    read_salmon_datapackage,
    validate_salmon_datapackage,
    write_salmon_datapackage,
)

reviewed_pkg = read_salmon_datapackage(pkg_path)

# Replace this example with the description agreed during review.
reviewed_dataset = reviewed_pkg["dataset"].copy()
reviewed_dataset.loc[:, "description"] = (
    "A reviewed description of this salmon dataset."
)

pkg_path = write_salmon_datapackage(
    resources=reviewed_pkg["resources"],
    dataset_meta=reviewed_dataset,
    table_meta=reviewed_pkg["tables"],
    dict_df=reviewed_pkg["dictionary"],
    codes=reviewed_pkg["codes"],
    path=pkg_path,
    overwrite=True,
)

validate_salmon_datapackage(
    pkg_path,
    require_iris=False,
)
```

### Spreadsheet

Record each manual transformation and metadata decision in a review log beside the package. A spreadsheet-only workflow is inspectable but is not a fully executable rebuild; use the R or Python helper workflow when you need to recreate and validate the package end to end.

::::::::::::::::::::::::::::::::::::::::::::::::

## Use supporting context in the same script

Source dictionaries, methods notes, and provenance documents help people review the inferred templates. Reading these files does not automatically merge them into `column_dictionary.csv`; you still decide which statements belong in canonical metadata.

::::::::::::::::::::::::::::::::::::: group-tab

### R

```r
source_dictionary <- readr::read_csv(
  file.path("raw_data", "source-data-dictionary.csv"),
  show_col_types = FALSE
)

context_note <- readr::read_file(
  file.path("raw_data", "methods-and-caveats.md")
)
```

### Python

```python
from pathlib import Path

import pandas as pd

raw_data_dir = Path("raw_data")

source_dictionary = pd.read_csv(
    raw_data_dir / "source-data-dictionary.csv"
)
context_note = (
    raw_data_dir / "methods-and-caveats.md"
).read_text(encoding="utf-8")
```

### Spreadsheet

Open the source dictionary and methods/caveats note from `raw_data/` beside the package metadata. Copy only reviewed statements into canonical metadata; preserve longer narrative context in the note.

::::::::::::::::::::::::::::::::::::::::::::::::

`llm_context_files` accepts local file paths, not the parsed `source_dictionary` or `context_note` objects. With `use_llm_review` set to `FALSE`, the examples pass `NULL` / `None`, so neither implementation warns about ignored context or contacts an LLM provider. Turning the toggle on explicitly passes the listed files to the configured provider; make that choice only after selecting the provider and model and confirming that the files are appropriate to send.

`seed_semantics = TRUE` / `seed_semantics=True` still performs semantic candidate lookup and may contact configured vocabulary services. That lookup is separate from LLM assessment. `check_updates = FALSE` / `check_updates=False` disables the unrelated package-version lookup so the script does not make that extra request.

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

1. add the source and context paths to `scripts/build_sdp.R` or `scripts/build_sdp.py`;
2. confirm the dataset ID and every table ID;
3. run the script with `use_llm_review` set to `FALSE` and `seed_semantics` set to `TRUE`;
4. encode an improved dataset description, one table description, and five column descriptions in the script; and
5. write one README/context-note section and add its path to `context_files`.

Rerun the script to confirm that the declared inputs and encoded review decisions recreate the package. Mark anything you are unsure about as a reviewer question rather than hiding it.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Keep raw data, context inputs, transformations, and reviewed metadata decisions connected through one reproducible script.
- One dataset may contain one or many tables; pass multiple tables as a named list.
- Prepare tidy rectangular inputs: one variable per column, one observation per row, and one value per cell.
- Semantic seeding is enabled in this chapter; LLM assessment remains a separate, explicit opt-in.
- Seeding is what makes Chapter 4 possible: the review there reads suggestions rather than searching, so a package built without seeding has nothing to review.
- Metadata tables hold structured facts; README/context notes hold narrative caveats.
- A clear description is more valuable than an uncertain link to a shared definition.

::::::::::::::::::::::::::::::::::::::::::::::::
