---
title: "Capture Context That Travels With the Data"
teaching: 40
exercises: 35
---

:::::::::::::::::::::::::::::::::::::: questions

- What context do data holders need to share so others do not misuse the data?
- What belongs in column metadata versus a README/context note?
- How should I organize and read my own data and context files?
- How can context improve later term mapping?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create an RStudio Project with separate locations for original data, context, and generated output.
- Read either the bundled NuSEDS example or a learner-owned CSV using a reproducible relative path.
- Write useful dataset, table, column, and code descriptions.
- Draft a compact README/context note for reviewers and mapping tools.
- Identify caveats that should not be hidden in informal comments.

::::::::::::::::::::::::::::::::::::::::::::::::

## Create a project home for your own files

Use an RStudio Project so that every relative path starts from one predictable folder.

1. In RStudio, choose **File > New Project**.
2. Choose **New Directory > New Project**, give it a name such as `salmon-data-workshop`, and choose where to create it. If you already made the folder, choose **Existing Directory** instead.
3. Reopen the project later by opening its `.Rproj` file. Do not use `setwd()` to point at folders elsewhere on your computer.

From the R console, create three working folders:

```r
dir.create("data-raw", showWarnings = FALSE)
dir.create("context", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
```

Use them like this:

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  data-raw/
    my-salmon-data.csv        # unchanged source data
  context/
    source-data-dictionary.csv # codebook or field definitions
    methods-and-caveats.md     # methods, caveats, or provenance
  output/
    my-salmon-sdp/            # generated package goes here
```

Copy source files into `data-raw/` and leave those copies unchanged. Put codebooks, methods, and other explanatory files in `context/`. Write generated packages only under `output/`. Use only files you are allowed to bring to the workshop, and do not send context files to an external service unless that use is approved.

## Read the bundled example or your own data

The bundled NuSEDS example comes from the installed R package:

```r
library(metasalmon)

example_data_path <- system.file(
  "extdata",
  "nuseds-fraser-coho-2023-2024.csv",
  package = "metasalmon"
)

fraser_coho <- readr::read_csv(
  example_data_path,
  show_col_types = FALSE
)
```

Your own file uses a path relative to the RStudio Project:

```r
own_data_path <- file.path(
  "data-raw",
  "my-salmon-data.csv"
)

own_data <- readr::read_csv(
  own_data_path,
  show_col_types = FALSE
)

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

pkg_path <- create_sdp(
  own_data,
  path = file.path("output", "my-salmon-sdp"),
  dataset_id = "my-salmon-data",
  table_id = "observations",
  seed_semantics = FALSE,
  check_updates = FALSE,
  overwrite = TRUE
)
```

Change only the file names, dataset ID, table ID, and output folder to match your material. `source_dictionary` and `context_note` show how to read two common context formats. For a PDF or Excel workbook, use an appropriate reader rather than changing the folder layout. `context_paths` keeps the locations of every context file; people can review them directly, and optional approved LLM review can use those paths later.

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

Start Python from the same project folder and use the same `data-raw/`, `context/`, and `output/` layout.

```python
from importlib.resources import files
from pathlib import Path

import pandas as pd
from salmonpy import create_sdp

project_root = Path.cwd()

for folder in ("data-raw", "context", "output"):
    (project_root / folder).mkdir(exist_ok=True)

example_data_path = files("salmonpy.data").joinpath(
    "nuseds-fraser-coho-sample.csv"
)
fraser_coho = pd.read_csv(example_data_path)

own_data_path = project_root / "data-raw" / "my-salmon-data.csv"
own_data = pd.read_csv(own_data_path)

source_dictionary = pd.read_csv(
    project_root / "context" / "source-data-dictionary.csv"
)
context_note = (
    project_root / "context" / "methods-and-caveats.md"
).read_text(encoding="utf-8")

context_paths = [
    str(path)
    for path in sorted((project_root / "context").rglob("*"))
    if path.is_file()
]

pkg_path = create_sdp(
    own_data,
    path=project_root / "output" / "my-salmon-sdp",
    dataset_id="my-salmon-data",
    table_id="observations",
    seed_semantics=False,
    check_updates=False,
    overwrite=True,
)
```

The Python package bundles a smaller NuSEDS teaching fixture than the R package. Both are only practice inputs for the same package workflow; use `own_data` when the exercise moves to your files.

::::::::::::::::::::::::::::::::::::::::::::::::

## Context is part of the data

Many data holders hesitate to share data because they know the spreadsheet can be misread. A Salmon Data Package should make that local knowledge visible.

Use the metadata tables for structured facts. Use a README/context note for the narrative a reviewer needs before interpreting the package.

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

## Challenge 1: Write the context a reviewer needs

For your draft package, improve:

1. the dataset description;
2. one table description;
3. five column descriptions;
4. one README/context note section.

Mark anything you are unsure about as a reviewer question rather than hiding it.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Context reduces misuse risk and improves mapping quality.
- Metadata tables hold structured facts; README/context notes hold narrative caveats.
- A clear description is more valuable than an uncertain link to a shared definition.

::::::::::::::::::::::::::::::::::::::::::::::::
