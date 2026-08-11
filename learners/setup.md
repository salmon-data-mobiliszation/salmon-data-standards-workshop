---
title: Setup
---

## What you will be ready to do

The workshop starts with ordinary tables and ends with a reviewed Salmon Data Package (SDP), a validated EML 2.2 metadata file, and a preview of the exact objects that `metasalmon` would upload to the Knowledge Network for Biocomplexity (KNB). A live catalog upload is available only to participants who have the required credentials and authority to redistribute the data.

## What to bring

Bring one small salmon-related dataset if you can. Supported workshop inputs are:

- one flat CSV or other rectangular table;
- several CSV files that belong to one dataset; or
- an Excel workbook containing one or more rectangular sheets/tables.

A **flat file** stores one two-dimensional table: one header row, then records in rows and fields in columns. A dataset can contain more than one table, so several flat files or workbook sheets can still belong to one dataset.

This tabular workflow does not directly support multidimensional formats such as NetCDF, rasters, or nested scientific arrays. Convert an appropriate tabular slice only when that conversion preserves the meaning of the source; otherwise use a workflow designed for that format.

Choose files you are allowed to discuss in the workshop. If you do not have a suitable dataset, use the included example unchanged.

Before the workshop, try to identify:

- what each row in each table represents;
- who created or maintains the data;
- any codes or abbreviations that need explanation; and
- one caveat that a future user should know.

## Prepare the project folder before the demo

Create a project folder named something like `salmon-data-workshop`. R users should create or open an RStudio Project in that folder. Python and spreadsheet users can use the same layout.

Create these subfolders before the package demo:

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj  # R users
  raw_data/                   # unchanged source CSVs or workbooks
  context/                    # codebooks, methods, caveats, provenance
  output/                     # generated Salmon Data Packages
```

From R, you can create the folders with:

```r
# Run these commands from the open RStudio Project root.
dir.create("raw_data", showWarnings = FALSE)
dir.create("context", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
```

Copy your source files into `raw_data/` and leave those copies unchanged. Do not put source files directly inside a generated package.

## Software options

You only need one on-ramp for package creation. The final EML/catalog step currently uses R/`metasalmon`.

### R/metasalmon path

Required:

- R 4.3 or newer;
- RStudio, Positron, or another R editor; and
- the `remotes`, `readr`, `dplyr`, `purrr`, `readxl`, and `metasalmon` packages.

Install the current GitHub version used by the workshop:

```r
install.packages(c("remotes", "readr", "dplyr", "purrr", "readxl"))
remotes::install_github("salmon-data-mobilization/metasalmon")

# The revised lesson targets metasalmon 0.2.3 or later.
packageVersion("metasalmon")
```

The canonical GitHub `main` branch was version 0.2.3 when this lesson was updated; the latest tagged R release was still 0.1.8. Check the [metasalmon changelog][metasalmon-changelog] before teaching if the version has moved.

For validated EML export, also install:

```r
install.packages(c("emld", "jsonvalidate"))
```

The credential-free KNB dry run does not need a DataONE login. For a live KNB upload, also install the publication packages and the password-prompt helper used in Session 6:

```r
install.packages(c("dataone", "datapack", "XML", "rstudioapi"))
```

A live upload also needs an ORCID-authenticated short-lived DataONE token and explicit publication authority. Do not store the token in a script, project file, YAML file, or shell history.

Optional:

- An LLM provider key only if you want to try optional LLM-assisted semantic review. The basic quickstart and EML export do not require an LLM.

LLM review is strictly opt-in. Context supplied through `llm_context_files` must be a character vector of existing local file paths, and it does not trigger an LLM call unless `llm_assess = TRUE`. Use only an approved provider and do not send sensitive or restricted material outside an authorized environment.

### Python/salmonpy companion path

The workshop teaches the core creation and review workflow in R first and then provides a Python equivalent. `salmonpy` 0.1.6 still supports those companion activities, but it is no longer version-aligned with the current R package and does not provide the final EML/KNB workflow taught here.

Required:

- Python 3.9 or newer; and
- a terminal, notebook, or Python editor.

Create an environment and install the released Python wheel:

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install \
  "salmonpy @ https://github.com/salmon-data-mobilization/metaSmnPy/releases/download/v0.1.6/salmonpy-0.1.6-py3-none-any.whl"
```

The repository is named `metaSmnPy`, while the installed package and Python import are named `salmonpy`. See the [salmonpy documentation][salmonpy-docs]. Python packages can be handed to R/`metasalmon` for final validation, EML export, and catalog publication.

### Spreadsheet path

Required:

- Microsoft Excel, LibreOffice Calc, or another spreadsheet editor that can save CSV files.

Recommended:

- the project folder described above; and
- a copy of the [blank SDP CSV template][sdp-template], which you can open and edit with your spreadsheet software.

Download or clone the `smn-data-pkg` repository and copy that template folder. There is no standalone workbook or template ZIP. A spreadsheet participant can complete the metadata review and then hand the package to an R user for validation and EML export.

## Pre-workshop reading

Read these only if you have time:

1. Salmon Data Package specification: [normative rules][sdp-specification] and [field definitions and accepted values][sdp-field-reference]
2. Salmon Data Package examples: [blank CSV template][sdp-template] and [filled minimal example][sdp-example]
3. metasalmon quickstart: [create and review a package][metasalmon-quickstart]
4. metasalmon post-review workflow: [validate, export EML, and preview KNB publication][metasalmon-eml-workflow]
5. salmonpy quickstart: [create and review the same core package structure in Python][salmonpy-docs]
6. Optional for ontology maintainers: [Salmon Domain Ontology conventions][sdo-conventions]

You do not need to read ontology documentation before attending. Session 1 explains the term in plain language before the workshop uses it.

## Setup check

Before the demo, confirm that:

- the project is open at `salmon-data-workshop/`;
- `raw_data/`, `context/`, and `output/` exist;
- your source files are under `raw_data/`, or you plan to run the included example unchanged; and
- R users can load `metasalmon` with `library(metasalmon)`.

If your organization restricts software installation, use the spreadsheet path and pair with someone who can run the R validation and EML export later.
