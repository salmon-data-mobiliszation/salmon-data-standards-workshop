---
title: "Capture Context That Travels With the Data"
teaching: 40
exercises: 35
---

:::::::::::::::::::::::::::::::::::::: questions

- What context do data holders need to share so others do not misuse the data?
- What belongs in column metadata versus a README/context note?
- How can context improve later term mapping?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Write useful dataset, table, column, and code descriptions.
- Draft a compact README/context note for reviewers and mapping tools.
- Identify caveats that should not be hidden in informal comments.

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
- A clear description is more valuable than an uncertain ontology link.

::::::::::::::::::::::::::::::::::::::::::::::::
