---
title: Setup
---

## What you will be ready to do

The workshop starts with ordinary tables and ends with a reviewed Salmon Data Package (SDP), a validated EML 2.2 metadata file, and a preview of the exact objects that `metasalmon` or `metasalmonpy` would upload to the Knowledge Network for Biocomplexity (KNB). A live catalog upload is available only to participants who have the required credentials and authority to redistribute the data.

## What to bring

Bring one small salmon-related dataset if you can. Supported workshop inputs are:

- one flat CSV or other rectangular table;
- several CSV files that belong to one dataset; or
- an Excel workbook containing one or more rectangular sheets/tables.

A **flat file** stores one two-dimensional table: one header row, then records in rows and fields in columns. A dataset can contain more than one table, so several flat files or workbook sheets can still belong to one dataset.

Bring data that are already organized as tidy rectangular tables. In [Wickham's tidy-data formulation](https://doi.org/10.18637/jss.v059.i10), each variable is a column, each observation is a row, and each value is a cell. Before the workshop, prepare a tabular copy without spreadsheet presentation features such as merged cells, repeated title or header rows, notes above the header, or subtotals mixed into the observations. If one sheet contains unrelated tables, separate them into distinct tables, while retaining the original source outside the workshop project.

NetCDF, rasters, and other multidimensional scientific formats are outside the scope of this workshop. Do not flatten a NetCDF file and present it as though it were an ordinary spreadsheet or the complete source dataset. Use a format-specific packaging workflow instead, or bring a separately reviewed and documented tabular derivative whose meaning is preserved.

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
  raw_data/                   # unchanged input data and context files
  scripts/                    # reproducible R or Python build scripts
  output/                     # generated Salmon Data Packages
```

From R, you can create the folders with:

```r
# Run these commands from the open RStudio Project root.
dir.create("raw_data", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
```

Copy the prepared dataset and its context files—such as codebooks, methods, caveats, and provenance notes—into `raw_data/` and leave those inputs unchanged while building the package. R users will put the reproducible build in `scripts/build_sdp.R`; Python users will use `scripts/build_sdp.py`. Spreadsheet users do not need a build script. Do not put source files directly inside a generated package.

## Software options

Choose the R, Python, or spreadsheet lane that fits how you work. Code-driven activities include examples in both R and Python, with language-specific subsections where the commands differ. Spreadsheet-specific subsections show how to review and edit the same standard package files without code. All three lanes use the same project layout and Salmon Data Package structure, so you can stay with one lane while still following the shared discussion.

### R/metasalmon path

Required:

- R 4.3 or newer;
- RStudio, Positron, or another R editor; and
- the `remotes`, `readr`, `dplyr`, `purrr`, `readxl`, and `metasalmon` packages.

Install or update to the latest version from GitHub before the workshop:

```r
install.packages(c("remotes", "readr", "dplyr", "purrr", "readxl"))
remotes::install_github("salmon-data-mobilization/metasalmon")

packageVersion("metasalmon")
```

Facilitators should review the [metasalmon changelog][metasalmon-changelog] when preparing to teach.

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

### Python/metasalmonpy path

`metasalmonpy` is the Python implementation of the `metasalmon` workflow. The two packages are maintained at behavioral parity and their releases move in lockstep; deliberate, language-idiomatic differences are documented in the [parity guide][metasalmonpy-parity]. Use the Python examples anywhere the workshop presents a Python lane.

Required:

- Python 3.9 or newer; and
- a terminal, notebook, or Python editor.

Create an environment and install or update to the latest version directly from GitHub (no Git installation required):

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install \
  "metasalmonpy @ https://github.com/salmon-data-mobilization/metasalmonpy/archive/refs/heads/main.tar.gz"
```

The installed package and Python import are both named `metasalmonpy`. See the [metasalmonpy documentation][metasalmonpy-docs]. Validated EML export uses the optional `eml` extra, and KNB publication uses the optional `knb` extra. To prepare for both, replace `metasalmonpy` with `metasalmonpy[knb]` in the install command above; the `knb` extra includes EML support.

If you will read `.xlsx` workbooks in Python during Chapter 3, also install `openpyxl`:

```bash
python -m pip install openpyxl
```

### Spreadsheet path

Required:

- Microsoft Excel, LibreOffice Calc, or another spreadsheet editor that can save CSV files.

Recommended:

- the project folder described above; and
- a copy of the [blank SDP CSV template][sdp-template], which you can open and edit with your spreadsheet software.

Download or clone the `smn-data-pkg` repository and copy that template folder. There is no standalone workbook or template ZIP. Spreadsheet participants can review and edit the canonical metadata CSVs directly with their spreadsheet software.

## Pre-workshop reading

Read these only if you have time:

1. Salmon Data Package specification: [normative rules][sdp-specification] and [field definitions and accepted values][sdp-field-reference]
2. Salmon Data Package starting points: the [blank CSV template][sdp-template] and the current code-generated quickstart in Chapter 2
3. metasalmon quickstart: [create and review a package][metasalmon-quickstart]
4. metasalmon post-review workflow: [validate, export EML, and preview KNB publication][metasalmon-eml-workflow]
5. metasalmonpy quickstart: [create and review the same core package structure in Python][metasalmonpy-docs]
6. Optional for ontology maintainers: [Salmon Domain Ontology conventions][sdo-conventions]

You do not need to read ontology documentation before attending. Session 1 explains the term in plain language before the workshop uses it.

## Setup check

Before the demo, confirm that:

- the project is open at `salmon-data-workshop/`;
- `raw_data/`, `scripts/`, and `output/` exist;
- your prepared data and context files are under `raw_data/`, or you plan to run the included example unchanged;
- R or Python users have a place for `scripts/build_sdp.R` or `scripts/build_sdp.py`;
- R users can load `metasalmon` with `library(metasalmon)`;
- Python users can import `metasalmonpy`; and
- spreadsheet users can open the blank SDP CSV template in their editor.

If your organization restricts software installation, use the spreadsheet lane for the package-structure and metadata-review activities.
