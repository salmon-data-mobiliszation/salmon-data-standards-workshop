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
- A copy of the [blank SDP CSV template][sdp-template], which you can open and edit with your spreadsheet software. Download the `smn-data-pkg` repository as a ZIP from GitHub or clone it, then copy that folder; there is no standalone workbook or template ZIP.

### R/metasalmon path

Required:

- R 4.3 or newer.
- RStudio, Positron, or another R editor.
- The `remotes`, `readr`, and `metasalmon` packages.

Install with:

```r
install.packages(c("remotes", "readr", "dplyr"))
remotes::install_github("salmon-data-mobilization/metasalmon")
```

Installing `metasalmon` from this public repository does **not** require Git, a GitHub account, a personal access token, or a connection between RStudio and GitHub. `remotes::install_github()` downloads public packages through the GitHub API. See the [`remotes` installation documentation][remotes-install-github] for details; authentication is needed for private repositories and can also help if you reach GitHub's anonymous API rate limit.

Optional:

- An LLM provider key only if you want to try optional LLM-assisted semantic review. The basic quickstart does not require an API key.
- Git and GitHub setup if you plan to clone repositories, contribute changes, or use RStudio's Git pane. Follow Jenny Bryan and collaborators' [Happy Git and GitHub for the useR][happy-git] before the workshop.

LLM review is strictly opt-in. Context supplied through `llm_context_files` must be a character vector of existing local file paths, and it does not trigger an LLM call unless `llm_assess = TRUE`. Use only an approved provider and do not send sensitive or restricted material outside an authorized environment.

### Python path

The main workshop uses Excel and R examples. Python users can follow the same package structure with `salmonpy`.

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install git+https://github.com/Br-Johnson/salmonpy.git
```

## Pre-workshop reading

Read these only if you have time:

1. Salmon Data Package specification: [normative rules][sdp-specification] and [field reference][sdp-field-reference]
2. Salmon Data Package examples: [blank CSV template][sdp-template] and [minimal example][sdp-example]
3. metasalmon quickstart: [create and review a package][metasalmon-quickstart]
4. Salmon Domain Ontology conventions: <https://github.com/salmon-data-mobilization/salmon-domain-ontology/blob/main/CONVENTIONS.md>

You do not need to read ontology documentation before attending. The workshop introduces the needed terms during the exercises.

## Folder check

During the workshop you should be able to create a folder like this:

```text
my-salmon-data-package/
  metadata/
  data/
```

If your organization restricts software installation, use the Excel-first path and pair with someone who can run validation later.
