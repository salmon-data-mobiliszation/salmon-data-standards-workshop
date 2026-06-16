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

### Excel-first path

Required:

- Microsoft Excel, LibreOffice Calc, or another spreadsheet editor that can save CSV files.

Recommended:

- A folder where you can save a package with `metadata/` and `data/` subfolders.

### R/metasalmon path

Required:

- R 4.3 or newer.
- RStudio, Positron, or another R editor.
- The `remotes`, `readr`, and `metasalmon` packages.

Install with:

```r
install.packages(c("remotes", "readr", "dplyr"))
remotes::install_github("salmon-data-mobilization/metasmn")
```

Optional:

- An LLM provider key only if you want to try optional LLM-assisted semantic review. The basic quickstart does not require an API key.

### Python path

The main workshop uses Excel and R examples. Python users can follow the same package structure with `salmonpy`.

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install git+https://github.com/Br-Johnson/salmonpy.git
```

## Pre-workshop reading

Read these only if you have time:

1. Salmon Data Package specification: <https://github.com/salmon-data-mobilization/smn-data-pkg>
2. metasalmon quickstart: <https://salmon-data-mobilization.github.io/metasmn/articles/metasalmon.html>
3. Salmon Domain Ontology conventions: <https://github.com/salmon-data-mobilization/salmon-domain-ontology/blob/main/CONVENTIONS.md>

You do not need to read ontology documentation before attending. The workshop introduces the needed terms during the exercises.

## Folder check

During the workshop you should be able to create a folder like this:

```text
my-salmon-data-package/
  metadata/
  data/
```

If your organization restricts software installation, use the Excel-first path and pair with someone who can run validation later.
