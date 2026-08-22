---
title: "Why Start With a Salmon Data Package?"
teaching: 35
exercises: 15
---

:::::::::::::::::::::::::::::::::::::: questions

- What will I be able to publish by the end of the workshop?
- What is the difference between a dataset, a table, and a flat file?
- What does a Salmon Data Package add to an ordinary spreadsheet or CSV?
- Where do the SDP fields come from, and how do they map into EML?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- State the end goal: a reviewed SDP, a validated EML file, and a guarded catalog-publication plan.
- Distinguish a dataset from its one or more tables and recognize supported tabular inputs.
- Recognize the core metadata CSVs before running any package code.
- Separate the Frictionless structure, external-standard alignments, and salmon-specific SDP conventions.

::::::::::::::::::::::::::::::::::::::::::::::::

## Start with the end goal

By the end of the workshop, participants should be able to:

1. create and review a Salmon Data Package (SDP);
2. run the strict R/`metasalmon` publication check;
3. export the reviewed metadata as schema-valid EML 2.2; and
4. preview an exact KNB/DataONE catalog deposit, then perform the upload when they have credentials and redistribution authority.

An EML file is structured XML, not an arbitrary XML file with a different name. `metasalmon` maps reviewed SDP facts into the EML model and validates the result against EML 2.2. A live KNB call creates persistent production objects, so the workshop uses a credential-free dry run unless an authorized publication exercise has been arranged.

## The problem this workshop solves

Salmon data are often understandable to the person or team that collected them, but hard for someone else to reuse. Column names may be short, code values may be local, methods may be buried in reports, and important caveats may live only in people's heads.

This workshop starts with a practical rule:

> Package and explain the data first. Link selected fields to shared definitions only after the package is reviewable.

In this workshop, **semantic** simply means "about meaning." A **semantic link** connects a local column or code value to a shared definition.

An **ontology** is a maintained set of concepts and definitions that also records how the concepts relate—for example, that coho salmon is a kind of salmon. A **vocabulary** is a maintained list of terms and definitions, while a **code list** records the allowed values for one data column. You will use these resources; you do not need to build or edit an ontology.

## Dataset, table, and flat file

These terms describe different levels:

| Term | Meaning | Example |
| --- | --- | --- |
| Dataset | The complete collection being documented; it can contain one or many related tables. | A coho escapement dataset containing observations, sites, and methods tables. |
| Table | A rectangular set of rows and columns with one consistent row meaning. | One row per population and return year. |
| Flat file | A file that stores one two-dimensional table, normally with one header row and no nested structure. | A CSV file. |
| Workbook | A container that can hold several sheets/tables; the workbook itself is not one flat file. | An `.xlsx` file with `Escapement` and `Sites` sheets. |

The workshop supports one flat table, multiple CSV tables, or multiple rectangular Excel sheets. R reads each source table into a data frame and passes either one data frame or a **named list** of data frames to `create_sdp()`. The workflow does not directly preserve multidimensional NetCDF, raster, or nested-array structures.

## The workshop ladder

| Stage | Main question | Output |
| --- | --- | --- |
| Structure | What files, tables, columns, and codes are in this dataset? | Draft Salmon Data Package |
| Context | What does a reviewer need to know to avoid misuse? | Metadata and README/context note |
| Meaning | Which fields should link to shared definitions? | Reviewed mappings for measurements and key code lists |
| Contribution | Which shared definitions are missing, and who should maintain them? | Plan to request a shared term or keep a local definition |
| Publication | How do reviewed SDP facts become portable catalog metadata? | Valid EML plus a reviewed KNB/DataONE publication plan |

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
  README.md or README-review.txt
```

The CSV files under `metadata/` are the canonical, human-reviewable core. `codes.csv` is conditional: include it when the package has categorical columns. The generated `datapackage.json` is the Frictionless descriptor used by software; it must agree with the metadata CSVs and data resources.

## See the metadata CSVs before writing code

The previews below are deliberately shortened so they fit on screen. Open the complete example files to see every canonical header: [dataset.csv][sdp-example-dataset], [tables.csv][sdp-example-tables], [column_dictionary.csv][sdp-example-dictionary], and [codes.csv][sdp-example-codes].

`metadata/dataset.csv` has one row for the dataset:

```csv
dataset_id,title,description,creator,contact_name,contact_email,license,...
demo-coho,Coho escapement demo,Practice escapement records,Demo team,Data office,data@example.org,CC-BY-4.0,...
```

`metadata/tables.csv` has one row for each table:

```csv
dataset_id,table_id,file_name,table_label,description,observation_unit,...
demo-coho,escapement,data/escapement.csv,Escapement estimates,One row per population and return year,Population-year,...
```

`metadata/column_dictionary.csv` is the main review surface. It has one row for every column in every table:

```csv
dataset_id,table_id,column_name,column_label,column_description,column_role,value_type,required,unit_label,...
demo-coho,escapement,population_id,Population ID,Stable identifier for the population,identifier,string,TRUE,,...
demo-coho,escapement,return_year,Return year,Calendar year of adult return,temporal,integer,TRUE,,...
demo-coho,escapement,spawner_count,Spawner count,Estimated natural-origin adult spawners,measurement,integer,FALSE,fish,...
```

`metadata/codes.csv` explains stored values in categorical columns:

```csv
dataset_id,table_id,column_name,code_value,code_label,code_description,...
demo-coho,escapement,species_code,CO,Coho salmon,Stored species code for coho salmon,...
```

The [SDP field reference][sdp-field-reference] gives the definition, requirement, accepted type or allowed values, and notes for every field. Do not guess a header or add a convenient extra column to a canonical metadata CSV.

## Where the fields come from

SDP combines several layers; they should not be described as one universal standard:

| Layer | What it contributes |
| --- | --- |
| Frictionless Data Package and Table Schema | The package/resource structure, table fields, value types, constraints, and machine-readable schemas used to validate each metadata CSV and `datapackage.json`. |
| Common discovery/catalog concepts | Titles, descriptions, contacts, licences, temporal coverage, keywords, and provenance that can map into EML, HNAP/ISO, or another catalog profile. |
| I-ADOPT, SOSA, SKOS/OWL, and unit vocabularies | External semantic roles for measurement property/entity/constraint/statistical modifier, table- and code-level procedures, reusable concepts, code lists, and units. |
| Salmon Data Package profile | The exact CSV filenames and columns, joins through `dataset_id`/`table_id`/`column_name`, `column_role`, observation-unit conventions, categorical-code coverage, and salmon publication rules. |

In other words, every metadata CSV is described with a **Frictionless Table Schema**, but not every SDP column name comes from Frictionless itself. SDP defines a custom Frictionless profile and aligns selected fields with other standards where the alignment is warranted.

## How SDP becomes EML

The export is a governed transformation, not a claim that the two formats are identical:

| SDP source | EML destination |
| --- | --- |
| `dataset.csv$title`, `description`, `keywords` | Dataset title, abstract, and keyword set |
| `dataset.csv$temporal_start` and `temporal_end` | Temporal coverage |
| Each `tables.csv` row | One EML `dataTable`, including its name, description, physical CSV object, and key information |
| `column_dictionary.csv` names, labels, descriptions, and `value_type` | EML attributes, definitions, and storage types |
| `column_dictionary.csv$required` | EML not-null constraints |
| `codes.csv` | EML enumerated domains for categorical attributes |
| Reviewed measurement `term_iri` and `unit_iri` | Conservative EML semantic annotations |
| Reviewed `metadata/eml-mapping.yml` sidecar | Structured parties, rights, methods, measurement scales, missing-value meanings, geographic/taxonomic coverage, and publication intent that SDP cannot infer safely |

The sidecar is important: a title or column type can map directly, but an ORCID-authenticated metadata provider, a measurement scale, or permission to publish cannot be inferred from a source spreadsheet.

## R-first examples, three ways to participate

The worked code uses R first. Python equivalents appear immediately afterward for the core package workflow, while spreadsheet users edit the same standard package files. Use the path that matches your current comfort level; you do not need to run both code blocks.

| If you usually work in... | Start with... | Publication handoff |
| --- | --- | --- |
| R | `metasalmon::create_sdp()` | R also provides strict validation, EML export, and KNB publication. |
| Python | `metasalmonpy.create_sdp()` | Hand the compatible SDP to current R/`metasalmon` for the final gate. |
| Excel or Calc | Blank SDP CSV template folder | Hand the reviewed CSV package to R/`metasalmon` for validation and export. |

The R examples target the tagged `metasalmon` 0.3.0 release, which implements `sdp-0.3.0`. The Python companion is `metasalmonpy` 0.2.1, whose version is a parity claim against metasalmon 0.2.1 — it writes the earlier `sdp-0.2.0` shape — so do not claim complete version or feature parity, and expect R's `migrate_sdp_methods()` in the handoff.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Pick your package

Choose one dataset or example table for the workshop.

Write down:

- whether it is one flat table, several files, or a multi-sheet workbook;
- a short dataset name;
- the tables it contains and what one row means in each;
- who would be the best contact for questions; and
- one thing that could be misunderstood if the data were shared without context.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- The end-to-end target is reviewed SDP metadata, valid EML, and a guarded catalog-publication plan.
- A dataset can contain multiple tables; a flat file contains one rectangular table.
- The metadata CSVs are visible review surfaces, not hidden software internals.
- SDP is a custom Frictionless profile with explicit external-standard alignments and salmon-specific rules.
- EML export needs reviewed facts that cannot be inferred from the source table alone.

::::::::::::::::::::::::::::::::::::::::::::::::
