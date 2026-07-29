---
title: "Why Start With a Salmon Data Package?"
teaching: 25
exercises: 10
---

:::::::::::::::::::::::::::::::::::::: questions

- Why is it hard for other people to reuse salmon datasets?
- What does a Salmon Data Package add to an ordinary spreadsheet or CSV?
- What should we finish before worrying about ontology coverage?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Describe the workshop ladder: structure, context, meaning, contribution.
- Recognize the core files in a Salmon Data Package.
- Choose an Excel-first or R/metasalmon on-ramp for the hands-on work.

::::::::::::::::::::::::::::::::::::::::::::::::

## The problem this workshop solves

Salmon data are often understandable to the person or team that collected them, but hard for someone else to reuse. Column names may be short, code values may be local, methods may be buried in reports, and important caveats may live only in people's heads.

This workshop starts with a practical rule:

> Package and explain the data first. Add shared semantic links after the package is reviewable.

That keeps the first goal concrete. A useful draft Salmon Data Package is a successful first outcome even when some ontology mappings are still blank or marked for review.

## The workshop ladder

| Stage | Main question | Output |
| --- | --- | --- |
| Structure | What files, tables, columns, and codes are in this dataset? | Draft Salmon Data Package |
| Context | What does a reviewer need to know to avoid misuse? | Metadata and README/context note |
| Meaning | Which fields should link to shared definitions? | Reviewed mappings for measurements and key code lists |
| Contribution | What term gaps remain, and where should they go? | Term-request or profile-vocabulary plan |

## What is in a Salmon Data Package?

A package is a folder that keeps data and metadata together:

```text
my-salmon-data-package/
  metadata/
    dataset.csv
    tables.csv
    column_dictionary.csv
    codes.csv                  # required when categorical columns exist
  data/
    my_table.csv
  datapackage.json             # generated; required for complete/published packages
  README.md or README-review.txt  # optional sidecar or review checklist
```

The CSV files under `metadata/` are the human-reviewable core. `codes.csv` is conditional: include it when the package has categorical columns. The generated `datapackage.json` makes the package easier for software to read and is required for a complete or published package, but the metadata CSVs are the place most learners will edit first.

## Two on-ramps, one review task

Use whichever path matches your current comfort level.

| If you usually work in... | Start with... | You still review... |
| --- | --- | --- |
| Excel or Calc | Blank SDP CSV template folder | dataset, table, column, and conditional code metadata |
| R | `metasalmon::create_sdp()` | the same metadata CSVs, a generated descriptor, and optional suggestions |
| Python | `salmonpy` or exported CSVs | the same package structure |

No path requires you to understand OWL, SKOS, I-ADOPT, or IRIs before you have a draft package.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Pick your package

Choose one dataset or example table for the workshop.

Write down:

- a short dataset name;
- who would be the best contact for questions;
- what each row represents;
- one thing that could be misunderstood if the data were shared without context.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Start by making the dataset reviewable, not by forcing every field into an ontology.
- A Salmon Data Package keeps data, metadata, code lists, and context together.
- Excel and R paths converge on the same review task.

::::::::::::::::::::::::::::::::::::::::::::::::
