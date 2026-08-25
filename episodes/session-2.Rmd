---
title: "Create a Draft Salmon Data Package"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- What must I set up before running the demo?
- What will the bundled quickstart data show me?
- What input structures does `create_sdp()` support?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Confirm the project, `raw_data/`, `scripts/`, and `output/` layout, unless you already completed this during setup.
- Run the bundled example unchanged to generate and inspect templates.
- Explain why Chapter 2 uses bundled quickstart data and Chapter 3 introduces your own data.
- Identify supported single-table, multi-table, and workbook inputs.

::::::::::::::::::::::::::::::::::::::::::::::::

## Before the quickstart: confirm the project and folders

If you already created this project and its folders in **Summary and Setup**, skip this section. Otherwise, work from one project root so every path in the lesson is relative and reproducible.

1. R users: in RStudio choose **File > New Project**, then create a new project or open the folder you prepared during setup.
2. Confirm that the working project is `salmon-data-workshop/`; do not call `setwd()` to jump elsewhere.
3. Create the input, script, and output folders before calling `create_sdp()`.

```r
# Run from the open RStudio Project root.
dir.create("raw_data", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
```

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  raw_data/                   # unchanged data and context inputs
  scripts/                    # build_sdp.R or build_sdp.py
  output/                     # generated package folders
```

Keep the prepared dataset, codebooks, methods, caveats, and other context inputs together under `raw_data/` and do not edit them in place while building a package. In Chapter 3, R users will save the reproducible build as `scripts/build_sdp.R`, Python users as `scripts/build_sdp.py`, and spreadsheet users will omit the script.

## Chapter 2 uses the bundled quickstart data

In this chapter, use the prepared starting point for your chosen software lane. The R and Python examples use a small NuSEDS-derived table; the spreadsheet lane uses the canonical blank SDP template. Each is a quickstart for seeing the package structure and starter metadata. Do not substitute your own files yet: Chapter 3 is the bring-your-own-data workflow.

## What "draft" means

A draft package is allowed to contain blanks, placeholders, and review markers. The first example has one purpose: generate the package structure and starter metadata so you can inspect it. It is not a finished description of the source dataset and it does not export EML yet.

## Generate or open the prepared quickstart

Choose **R**, **Python**, or **Spreadsheet** below. Your selection is synchronized with the other software choices on this page.

::::::::::::::::::::::::::::::::::::: group-tab

### R

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
  check_updates = TRUE,
  overwrite = FALSE
)

list.files(pkg_path, recursive = TRUE)
```

### Python

`metasalmonpy` includes the same NuSEDS-derived practice table. Generate its templates with semantic searching turned off so the first result is fast and local.

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
    check_updates=True,
    overwrite=False,
)

for path in sorted(
    path for path in pkg_path.rglob("*") if path.is_file()
):
    print(path.relative_to(pkg_path))
```

### Spreadsheet

Spreadsheet participants can inspect the package structure without running code. Download or clone the `smn-data-pkg` repository, copy its [blank SDP CSV template][sdp-template] into `output/spreadsheet-quickstart-sdp/`, and open the CSV files with Excel, LibreOffice Calc, or another spreadsheet editor.

Keep the copied folder structure and header rows unchanged. In this chapter, inspect the prepared example rather than replacing its data or metadata; Chapter 3 introduces your own data.

::::::::::::::::::::::::::::::::::::::::::::::::

For the R and Python lanes, `seed_semantics = FALSE` / `seed_semantics=False` is the fast classroom option. It skips live searches for links to shared definitions. Chapter 4 shows how to run those searches after the starter metadata has been reviewed.

## Inspect the package files

Open these files in this order. A package generated by R or Python starts with `README-review.txt`; the spreadsheet template uses `README.md`.

1. `README-review.txt` or `README.md`
2. `metadata/column_dictionary.csv`
3. `metadata/tables.csv`
4. `metadata/dataset.csv`
5. `metadata/codes.csv`, when present
6. `semantic_suggestions.csv`, when present

The R or Python quickstart has this generated structure. The spreadsheet template has the same core metadata CSVs but keeps `data/README.md` in place of a learner data table until Chapter 3.

```text
output/fraser-coho-example-sdp/
  README-review.txt            # README.md in the prepared example
  datapackage.json
  .metasalmon-package          # R writer bookkeeping; Python uses .metasalmonpy-package
  metadata/
    dataset.csv
    tables.csv
    column_dictionary.csv
    codes.csv                  # present when categorical columns exist
  data/
    escapement.csv              # filename follows the table ID
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

## Field definitions and accepted values

Use the [SDP field reference][sdp-field-reference] while editing. Four fields that commonly cause confusion are:

| Field | Meaning | Accepted values or rule |
| --- | --- | --- |
| `column_role` | What the column does in the table | `identifier`, `attribute`, `temporal`, `categorical`, or `measurement` |
| `value_type` | The basic type of values in the source column | `integer`, `number`, `string`, `boolean`, `date`, or `datetime` |
| `required` | Whether every data row must contain a value in this source column | `TRUE`, `FALSE`, or blank; this is different from whether an SDP metadata field itself is required. |
| `unit_label` / `unit_iri` | A readable unit and its stable identifier | `unit_label` is text; `unit_iri` is required for measurement rows and must be a valid absolute IRI. |

## Review-state validation

Early validation should catch structure problems without requiring all links to shared definitions to be complete. Use the same software lane you selected above.

::::::::::::::::::::::::::::::::::::: group-tab

### R

```r
review_check <- validate_salmon_datapackage(
  pkg_path,
  require_iris = FALSE
)

review_check$semantic_validation$issues
review_check$semantic_validation$missing_terms
```

### Python

```python
from metasalmonpy import validate_salmon_datapackage

review_check = validate_salmon_datapackage(
    pkg_path,
    require_iris=False,
)

print(review_check["semantic_validation"]["issues"])
print(review_check["semantic_validation"]["missing_terms"])
```

### Spreadsheet

Spreadsheet software does not currently run the SDP validator. For this quickstart, compare the prepared example's folder structure and metadata headers with the [SDP field reference][sdp-field-reference], and keep unresolved fields or term links visibly in review state. This manual review is not evidence that strict validation has passed.

::::::::::::::::::::::::::::::::::::::::::::::::

In the R and Python lanes, `require_iris = FALSE` / `require_iris=False` allows links to shared definitions to remain unfinished during draft review. Warnings about missing measurement links, placeholders, or `REVIEW:` markers can be acceptable in review state. Use strict validation only when the package is publication-ready.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Generate and inspect the quickstart templates

Run the bundled quickstart unchanged, then answer:

- Where is the data table?
- Which metadata file describes the dataset, each table, each column, and categorical codes?
- Which fields still need human review?
- What would you replace when moving to your own data?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Confirm the project and folders unless you already prepared them during setup.
- Run the bundled quickstart unchanged to learn the generated package shape; bring your own data in Chapter 3.
- `create_sdp()` accepts one data frame or a named list of tabular data frames, not arbitrary scientific file structures.
- The field reference is the source for definitions and allowed values.

::::::::::::::::::::::::::::::::::::::::::::::::
