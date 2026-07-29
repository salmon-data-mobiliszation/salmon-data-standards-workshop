---
title: "Create a Draft Salmon Data Package"
teaching: 45
exercises: 35
---

:::::::::::::::::::::::::::::::::::::: questions

- How do I turn a spreadsheet or CSV into a draft Salmon Data Package?
- What do the R and Python `create_sdp()` functions produce?
- What should I check before sharing a draft for review?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create or inspect a draft package using the primary R/metasalmon path, a paired Python/salmonpy path, or the spreadsheet template.
- Identify the required metadata files and their roles.
- Separate draft review from final publication readiness.

::::::::::::::::::::::::::::::::::::::::::::::::

## What "draft" means

A draft package is allowed to contain blanks, placeholders, and review markers. The goal is to create a structured package that a human can improve.

Do not treat the first package as final. Treat it as the first shared review surface.

## R/metasalmon path

In R, `create_sdp()` creates a package folder and a review checklist.

```r
library(metasalmon)

data_path <- system.file(
  "extdata",
  "nuseds-fraser-coho-2023-2024.csv",
  package = "metasalmon"
)

fraser_coho <- readr::read_csv(data_path, show_col_types = FALSE)

pkg_path <- create_sdp(
  fraser_coho,
  path = "fraser-coho-2023-2024-sdp",
  dataset_id = "fraser-coho-2023-2024",
  table_id = "escapement",
  seed_semantics = FALSE,
  check_updates = FALSE,
  overwrite = TRUE
)

list.files(pkg_path, recursive = TRUE)
```

`seed_semantics` controls whether `metasalmon` searches for possible links between local fields and shared definitions. `FALSE` is the fast classroom option; enabling the search can take several minutes and produces suggestions for human review.

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

Run this block instead of the R block if you are following the Python path. The installed package is named `salmonpy`, even though its repository is named `metaSmnPy`.

```python
from importlib.resources import files

import pandas as pd
from salmonpy import create_sdp

data_path = files("salmonpy.data").joinpath(
    "nuseds-fraser-coho-sample.csv"
)

fraser_coho = pd.read_csv(data_path)

pkg_path = create_sdp(
    fraser_coho,
    path="fraser-coho-sample-sdp",
    dataset_id="fraser-coho-sample",
    table_id="escapement",
    seed_semantics=False,
    check_updates=False,
    overwrite=True,
)

for path in sorted(
    path for path in pkg_path.rglob("*") if path.is_file()
):
    print(path.relative_to(pkg_path))
```

`salmonpy` bundles its own small NuSEDS fixture under the filename shown above. It is not row-for-row identical to the larger 2023–2024 fixture bundled with `metasalmon`, so its package and dataset IDs use `fraser-coho-sample`. The fixtures demonstrate the same workflow and package structure; do not compare their row or column counts. `seed_semantics=False` has the same classroom purpose in Python: make the first package locally and defer searches for shared definitions. Python also writes a hidden `.salmonpy-package` bookkeeping file; the visible standard files below remain the shared review surface.

::::::::::::::::::::::::::::::::::::::::::::::::

Open the package folder and review:

- `README-review.txt`
- `metadata/column_dictionary.csv`
- `metadata/tables.csv`
- `metadata/dataset.csv`
- `metadata/codes.csv`, when present
- `semantic_suggestions.csv`, when present

Expected files:

```text
<package-folder>/
  README-review.txt
  datapackage.json             # generated descriptor
  metadata/
    dataset.csv
    tables.csv
    column_dictionary.csv
    codes.csv                  # when categorical columns exist
  data/
    escapement.csv
```

If semantic seeding is enabled, the package may also include `semantic_suggestions.csv`, and some metadata fields may contain `REVIEW: <iri>` draft values. An **IRI** is a stable web identifier for a shared term. The `REVIEW:` prefix means that the proposed match has not been accepted.

## Spreadsheet/CSV-template path

Download or clone the `smn-data-pkg` repository and copy the [blank SDP CSV template][sdp-template], then open its metadata CSV files in Excel, LibreOffice Calc, or another spreadsheet editor. There is no standalone workbook or template ZIP. Keep the folder structure and header rows exactly as provided.

Minimum steps:

1. Export each source table as a CSV under `data/`.
2. Fill one row in `metadata/dataset.csv`. The required fields are `dataset_id`, `title`, `description`, `creator`, `contact_name`, `contact_email`, and `license`; add coverage and provenance fields when they are useful.
3. Fill one row in `tables.csv` for each data table.
4. Fill one row in `column_dictionary.csv` for each data column.
5. When any column has `column_role = categorical`, use `codes.csv`. Each observed non-empty value must have exactly one matching row for its `dataset_id` + `table_id` + `column_name` + `code_value` key.
6. Optionally write a short README/context note with caveats, methods, and known limitations.
7. Before publication, generate `datapackage.json` with `metasalmon`, `salmonpy`, or another SDP-compatible tool and confirm that it agrees with the canonical metadata CSVs and referenced data files.

The spreadsheet path is valid when it produces the same canonical CSV metadata that either code package writes. The blank template intentionally omits `datapackage.json`; a complete or published package needs the generated descriptor as well.

## Review-state validation

Early validation should catch structure problems without requiring all links to shared definitions to be complete.

```r
review_check <- validate_salmon_datapackage(pkg_path, require_iris = FALSE)
review_check$semantic_validation$issues
review_check$semantic_validation$missing_terms
```

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

```python
from salmonpy import validate_salmon_datapackage

review_check = validate_salmon_datapackage(
    pkg_path,
    require_iris=False,
)

print(review_check["semantic_validation"]["issues"])
print(review_check["semantic_validation"]["missing_terms"])
```

::::::::::::::::::::::::::::::::::::::::::::::::

`require_iris = FALSE` in R and `require_iris=False` in Python allow links to shared definitions to remain unfinished during draft review. Warnings about missing links from measurement fields to shared definitions, placeholders, or `REVIEW:` markers can be acceptable in review state. Use strict validation only when the package is publication-ready, and use the normative R `metasalmon` validator for that final publication gate.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Create or inspect a draft package

Use one of the paths above.

Check that you can answer:

- Where is the data table?
- Which metadata file describes the dataset?
- Which metadata file describes each table?
- Which metadata file describes each column?
- Which columns, if any, need a code list?
- Which fields still need human review?
- Are any `MISSING DESCRIPTION:`, `MISSING METADATA:`, or `REVIEW:` markers still present?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- A draft package is a review surface, not a final publication.
- `metadata/*.csv` files are the canonical human-editable metadata.
- Non-strict validation belongs early; strict validation belongs near the end.

::::::::::::::::::::::::::::::::::::::::::::::::
