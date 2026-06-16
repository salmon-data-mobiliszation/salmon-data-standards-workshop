---
title: "Create a Draft Salmon Data Package"
teaching: 45
exercises: 35
---

:::::::::::::::::::::::::::::::::::::: questions

- How do I turn a spreadsheet or CSV into a draft Salmon Data Package?
- What does `metasalmon::create_sdp()` produce?
- What should I check before sharing a draft for review?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create or inspect a draft package using the Excel-first or R/metasalmon path.
- Identify the required metadata files and their roles.
- Separate draft review from final publication readiness.

::::::::::::::::::::::::::::::::::::::::::::::::

## What "draft" means

A draft package is allowed to contain blanks, placeholders, and review markers. The goal is to create a structured package that a human can improve.

Do not treat the first package as final. Treat it as the first shared review surface.

## Excel-first path

Use the Salmon Data Package template as a workbook-shaped review surface.

Minimum steps:

1. Put source data in a `data` sheet or export it as a CSV under `data/`.
2. Fill one row in `dataset.csv` metadata: title, description, creator, contact, license, and useful coverage notes.
3. Fill one row in `tables.csv` for each data table.
4. Fill one row in `column_dictionary.csv` for each data column.
5. Use `codes.csv` only for categorical columns with controlled values.
6. Write a short README/context note with caveats, methods, and known limitations.

The workbook path is valid when it produces the same core metadata that an R package would write.

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

`seed_semantics = FALSE` is the fast classroom option. The default semantic seeding path may take several minutes because it searches term sources and writes review suggestions.

Open the package folder and review:

- `README-review.txt`
- `metadata/column_dictionary.csv`
- `metadata/tables.csv`
- `metadata/dataset.csv`
- `metadata/codes.csv`, when present
- `semantic_suggestions.csv`, when present

Expected files:

```text
fraser-coho-2023-2024-sdp/
  README-review.txt
  datapackage.json
  metadata/
    dataset.csv
    tables.csv
    column_dictionary.csv
    codes.csv
  data/
    escapement.csv
```

If semantic seeding is enabled, the package may also include `semantic_suggestions.csv`, and some metadata fields may contain `REVIEW: <iri>` draft values.

## Review-state validation

Early validation should catch structure problems without demanding final semantic coverage.

```r
review_check <- validate_salmon_datapackage(pkg_path, require_iris = FALSE)
review_check$semantic_validation$issues
review_check$semantic_validation$missing_terms
```

Warnings about missing measurement semantics, placeholders, or `REVIEW:` markers can be acceptable in review state. Use strict validation only when the package is publication-ready.

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
