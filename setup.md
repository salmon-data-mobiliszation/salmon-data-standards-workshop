---
title: Setup
---

## What to bring

Bring one small salmon-related dataset if you can. A CSV file or Excel workbook is enough. Choose something you are allowed to discuss in the workshop.

If you do not have a dataset, use the provided example during the session.

Before the workshop, try to identify:

- what each row represents;
- who created or maintains the data;
- any codes or abbreviations that need explanation;
- one caveat that a future user should know.

## Software options

You only need one on-ramp.

### R/metasalmon path

Required:

- R 4.3 or newer.
- RStudio, Positron, or another R editor.
- The `remotes`, `readr`, `dplyr`, and `metasalmon` packages.

Install with:

```r
install.packages(c("remotes", "readr", "dplyr"))
remotes::install_github("salmon-data-mobilization/metasalmon")
```

Optional:

- An LLM provider key only if you want to try optional LLM-assisted semantic review. The basic quickstart does not require an API key.

LLM review is strictly opt-in. Context supplied through `llm_context_files` must be a character vector of existing local file paths, and it does not trigger an LLM call unless `llm_assess = TRUE`. Use only an approved provider and do not send sensitive or restricted material outside an authorized environment.

### Python/salmonpy companion path

The workshop teaches each coded workflow in R first and then provides a Python equivalent. Both packages target version 0.1.6 and are parity-tested when packages move between languages. The R package remains the normative contract and should run the final publication check.

Required:

- Python 3.9 or newer.
- A terminal, notebook, or Python editor.

Create an environment and install the released Python wheel:

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install \
  "salmonpy @ https://github.com/salmon-data-mobilization/metaSmnPy/releases/download/v0.1.6/salmonpy-0.1.6-py3-none-any.whl"
```

The repository is named `metaSmnPy`, while the installed package and Python import are named `salmonpy`. See the [salmonpy documentation][salmonpy-docs] and [R/Python parity guide][salmonpy-parity]. Python supports the paired creation and review activities; use `metasalmon` for the authoritative final publication validation.

### Spreadsheet path

Required:

- Microsoft Excel, LibreOffice Calc, or another spreadsheet editor that can save CSV files.

Recommended:

- A folder where you can save a package with `metadata/` and `data/` subfolders.
- A copy of the [blank SDP CSV template][sdp-template], which you can open and edit with your spreadsheet software. Download or clone the `smn-data-pkg` repository and copy that folder; there is no standalone workbook or template ZIP.

## Pre-workshop reading

Read these only if you have time:

1. Salmon Data Package specification: [normative rules][sdp-specification] and [field reference][sdp-field-reference]
2. Salmon Data Package examples: [blank CSV template][sdp-template] and [minimal example][sdp-example]
3. metasalmon quickstart: [create and review a package][metasalmon-quickstart]
4. salmonpy quickstart: [create and review the same package structure in Python][salmonpy-docs]
5. Optional for ontology maintainers: [Salmon Domain Ontology conventions][sdo-conventions]

You do not need to read ontology documentation before attending. Session 1 explains the term in plain language before the workshop uses it.

## Folder check

During the workshop you should be able to create a folder like this:

```text
my-salmon-data-package/
  metadata/
  data/
```

If your organization restricts software installation, use the spreadsheet path and pair with someone who can run validation later.
