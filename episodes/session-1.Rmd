---
title: "Why Start With a Salmon Data Package?"
teaching: 25
exercises: 10
---

:::::::::::::::::::::::::::::::::::::: questions

- Why is it hard for other people to reuse salmon datasets?
- What does a Salmon Data Package add to an ordinary spreadsheet or CSV?
- What should we finish before linking fields to shared definitions?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Describe the workshop ladder: structure, context, meaning, contribution.
- Recognize the core files in a Salmon Data Package.
- Choose the primary R/metasalmon path, a paired Python/salmonpy path, or the spreadsheet path for the hands-on work.

::::::::::::::::::::::::::::::::::::::::::::::::

## The problem this workshop solves

Salmon data are often understandable to the person or team that collected them, but hard for someone else to reuse. Column names may be short, code values may be local, methods may be buried in reports, and important caveats may live only in people's heads.

This workshop starts with a practical rule:

> Package and explain the data first. Link selected fields to shared definitions only after the package is reviewable.

In this workshop, **semantic** simply means "about meaning." A **semantic link** connects a local column or code value to a shared definition.

An **ontology** is a maintained set of concepts and definitions that also records how the concepts relate—for example, that coho salmon is a kind of salmon. A **vocabulary** is a maintained list of terms and definitions, while a **code list** records the allowed values for one data column. You will use these resources; you do not need to build or edit an ontology.

That keeps the first goal concrete. A useful draft Salmon Data Package is a successful first outcome even when some links to shared definitions are still blank or marked for review.

## The workshop ladder

| Stage | Main question | Output |
| --- | --- | --- |
| Structure | What files, tables, columns, and codes are in this dataset? | Draft Salmon Data Package |
| Context | What does a reviewer need to know to avoid misuse? | Metadata and README/context note |
| Meaning | Which fields should link to shared definitions? | Reviewed mappings for measurements and key code lists |
| Contribution | Which shared definitions are missing, and who should maintain them? | Plan to request a shared term or keep a local definition |

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

## R-first examples, three ways to participate

The worked code uses R first. Verified Python equivalents appear immediately afterward as companion blocks, while spreadsheet users edit the same standard package files. Use the path that matches your current comfort level; you do not need to run both code blocks.

| If you usually work in... | Start with... | You still review... |
| --- | --- | --- |
| R | `metasalmon::create_sdp()` | the same metadata CSVs, a generated descriptor, and optional suggestions |
| Python | `salmonpy.create_sdp()` | the same package structure, review workflow, and optional suggestions |
| Excel or Calc | Blank SDP CSV template folder | dataset, table, column, and conditional code metadata |

`metasalmon` 0.1.6 and `salmonpy` 0.1.6 are maintained as version-aligned implementations of the same core workflows and are parity-tested when packages move between R and Python. They are not identical: the R implementation remains the normative contract and currently provides the stronger final publication validator. See the [R and Python parity guide][salmonpy-parity].

You do not need prior knowledge of terminology standards to make a draft package. Later sessions introduce each specialized standard when it is needed.

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

- Start by making the dataset reviewable, not by forcing every field to match a shared definition.
- A Salmon Data Package keeps data, metadata, code lists, and context together.
- R, Python, and spreadsheet paths converge on the same review task.

::::::::::::::::::::::::::::::::::::::::::::::::
