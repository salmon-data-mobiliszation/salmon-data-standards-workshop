---
title: "The Salmon Data Integration System"
teaching: 35
exercises: 15
---

:::::::::::::::::::::::::::::::::::::: questions

- What parts make up the Salmon Data Integration System?
- What is the difference between a dataset, a table, and a flat file?
- What does a Salmon Data Package add to an ordinary spreadsheet or CSV?
- When should a team reuse, extend, or federate a controlled vocabulary or ontology?
- How do reviewed SDP facts become EML catalog metadata?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- State the end goal: a reviewed SDP, a validated EML file, and a guarded catalog-publication plan.
- Distinguish a dataset from its one or more tables and recognize supported tabular inputs.
- Explain the roles of the SDP, `metasalmon`, shared semantic resources, and local vocabularies or ontologies.
- Choose between reusing a shared term, proposing a shared extension, and keeping a local term with an explicit bridge mapping.
- Separate the Frictionless structure, external-standard alignments, and salmon-specific SDP conventions.

::::::::::::::::::::::::::::::::::::::::::::::::

## Start with the end goal

By the end of the workshop, participants should be able to:

1. create and review a Salmon Data Package (SDP);
2. run a strict publication check with `metasalmon` or `metasalmonpy`;
3. export the reviewed metadata as schema-valid EML 2.2.0; and
4. preview an exact KNB/DataONE catalog deposit, then perform the upload when they have credentials and redistribution authority.

An EML file is structured XML, not an arbitrary XML file with a different name. `metasalmon` and `metasalmonpy` map reviewed SDP facts into the EML model and validate the result against EML 2.2.0. A live KNB call creates persistent production objects, so the workshop uses a credential-free dry run unless an authorized publication exercise has been arranged.

## The problem this workshop solves

Salmon data are often understandable to the person or team that collected them, but hard for someone else to reuse. Column names may be short, code values may be local, methods may be buried in reports, and important caveats may live only in people's heads. A word can also mean one thing in a stock-assessment program and something different in a hatchery, habitat, or fisheries context.

This workshop starts with a practical rule:

> Package and explain the data first. Link selected fields to shared definitions only after the package is reviewable.

In this workshop, **semantic** simply means "about meaning." A **semantic link** connects a local column or code value to a shared definition.

An **ontology** is a maintained set of concepts and definitions that also records how the concepts relate—for example, that coho salmon is a kind of salmon. A **controlled vocabulary** is a governed list of terms and definitions, while a **code list** records the allowed values for one data column. Most workshop examples reuse existing resources. When local meaning is genuinely different, the system keeps that meaning local and maps it to shared concepts rather than pretending the meanings are identical.

## The system and its components

The [Salmon Data Integration System][salmon-data-integration-system] connects local salmon data and expert knowledge to portable packages, shared meanings, and publication formats. It is a set of cooperating components, not one file format or one ontology:

| Component | Role in the system |
| --- | --- |
| Local data and expert context | Supply the observations, methods, code meanings, caveats, and conditional rules that must not be lost. |
| [Salmon Data Package][sdp-specification] | Keeps the data, dataset/table descriptions, column dictionary, code lists, and machine-readable package descriptor together as a reviewable contract. |
| [`metasalmon`][metasalmon] in R and [`metasalmonpy`][metasalmonpy] in Python | Create, read, review, validate, and publish SDPs. Both implementations provide language-idiomatic [interactive decomposition chat][metasalmon-chat-decomposition] and [strictly opt-in LLM review][metasalmon-llm-review] to help surface missing context and assess candidate terms; suggestions remain drafts for human review. See the [Python documentation][metasalmonpy-docs] for its calling conventions. |
| [Salmon Domain Ontology][sdo] and other governed vocabularies | Provide reusable identifiers and definitions for meanings that are shared across programs or organizations. |
| Local controlled vocabularies, ontologies, and bridge mappings | Preserve program-specific concepts under local authority and connect them conservatively to shared concepts without erasing important differences. |
| [EML][eml-specification] and catalogs such as [KNB][knb] | Turn reviewed package facts into portable discovery metadata and, when authorized, a catalog deposit. |

A **bounded context** is a program, organization, or workflow in which a set of terms and rules has a stable local meaning. The Salmon Domain Ontology serves as a shared domain model: its concepts provide anchors that bridge mappings can use to translate between bounded contexts. It does not require every team to replace its own terminology.

### Reuse, extend, or federate?

Use a local controlled vocabulary when the main need is to govern a finite list of labels or codes. Use a local ontology when the relationships among local concepts also need to be represented. Then choose the integration path that fits the evidence and authority:

| Situation | Appropriate path |
| --- | --- |
| An existing shared concept has the same meaning | Reuse its identifier directly in the SDP. |
| A concept is stable and likely to be reused across organizations | Propose an extension to the Salmon Domain Ontology or the appropriate governed vocabulary; its steward decides whether and how it enters the shared resource. |
| A concept is program-specific, policy-specific, uncertain, or not ready for shared governance | Give it a stable identifier in a locally governed vocabulary or ontology, then publish a bridge mapping to the nearest shared concept with an honest relationship strength and provenance. |

The [modules and bridge profiles guide][sdo-bridge-guide] shows the practical pattern: define local terms in a local namespace, map them to shared anchors as exact, close, broader, narrower, or related only when warranted, record why the mapping was made, and test it against real rows. This is how the system supports translation without collapsing two bounded contexts into one.

## Dataset, table, and flat file

These terms describe different levels:

| Term | Meaning | Example |
| --- | --- | --- |
| Dataset | The complete collection being documented; it can contain one or many related tables. | A coho escapement dataset containing observations, sites, and methods tables. |
| Table | A rectangular set of rows and columns with one consistent row meaning. | One row per population and return year. |
| Flat file | A file that stores one two-dimensional table, normally with one header row and no nested structure. | A CSV file. |
| Workbook | A container that can hold several sheets/tables; the workbook itself is not one flat file. | An `.xlsx` file with `Escapement` and `Sites` sheets. |

The workshop supports one flat table, multiple CSV tables, or multiple rectangular Excel sheets. The R and Python workflows read each source table into memory and pass either one table or a named collection of tables to `create_sdp()`. The workflow does not directly preserve multidimensional NetCDF, raster, or nested-array structures.

## The workshop ladder

| Stage | Main question | Output |
| --- | --- | --- |
| Structure | What files, tables, columns, and codes are in this dataset? | Draft Salmon Data Package |
| Context | What does a reviewer need to know to avoid misuse? | Metadata and README/context note |
| Meaning | Which fields should link to shared definitions? | Reviewed mappings for measurements and key code lists |
| Contribution | Which shared definitions are missing, and who should maintain them? | Decision to reuse, request a shared extension, or publish a local bridge mapping |
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

## Where the fields come from

SDP combines several layers; they should not be described as one universal standard:

| Layer | What it contributes |
| --- | --- |
| [Frictionless Data Package][frictionless-data-package] and [Table Schema][frictionless-table-schema] | The package/resource structure, table fields, value types, constraints, and machine-readable schemas used to validate each metadata CSV and `datapackage.json`. |
| Common discovery/catalog concepts | Titles, descriptions, contacts, licences, temporal coverage, keywords, and provenance that can map into [EML][eml-specification], the Government of Canada's [HNAP metadata profile][hnap-guide], or another catalog profile. |
| [I-ADOPT][iadopt], [SOSA/SSN][sosa-ssn], [SKOS][skos-reference]/[OWL][owl-overview], and [QUDT unit vocabularies][qudt] | External semantic roles for measurement property/entity/constraint/statistical modifier, table- and code-level procedures, reusable concepts, code lists, and units. |
| [Salmon Data Package profile][sdp-specification] | The exact CSV filenames and columns, joins through `dataset_id`/`table_id`/`column_name`, `column_role`, observation-unit conventions, categorical-code coverage, and salmon publication rules. |

In other words, every metadata CSV is described with a **Frictionless Table Schema**, but not every SDP column name comes from Frictionless itself. SDP defines a custom Frictionless profile and aligns selected fields with other standards where the alignment is warranted.

For the current SDP-to-EML transformation, use `metasalmon`'s canonical [`eml-mapping-template.yml`][metasalmon-eml-mapping] and [`write_eml_from_sdp()` reference][metasalmon-eml-reference] rather than a duplicate field-by-field crosswalk in the workshop. The export combines reviewed dataset, table, column, code, semantic, and mapping-sidecar facts, then validates the resulting EML. Publication intent and authority must still be provided and reviewed; they cannot be inferred from a source spreadsheet.

## R, Python, and spreadsheet participation

The workshop provides R and Python examples for the code-based workflow, with separate spreadsheet subsections where direct metadata review is useful. Use the path that matches your current comfort level; you do not need to run every version of an exercise.

| If you usually work in... | Start with... | How this path participates |
| --- | --- | --- |
| R | `metasalmon::create_sdp()` | Create, review, validate, export, and plan or perform authorized publication in R. |
| Python | `metasalmonpy.create_sdp()` | Follow the corresponding creation, review, validation, export, and publication workflow in Python. |
| Excel or Calc | Open the generated SDP metadata CSVs | Review and edit dataset, table, column, and code descriptions; follow the spreadsheet-specific subsections where they appear. |

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Pick your dataset

Choose one salmon dataset you know well. Do not inventory its files or fields yet. Instead, look for meaning that the table alone does not explain:

- an overloaded term such as `stock`, `run`, or `population` that different teams may use differently;
- a hidden rule that currently lives in a biologist's head rather than in the data or metadata; or
- a column whose meaning depends on another column.

For example, a column named `count` might mean returning adult spawners when `life_stage = "adult"`, but downstream-migrating smolts when `life_stage = "smolt"`. The values are both counts, yet they describe different biological observations.

Write down **one thing that could be misunderstood if the dataset were shared without that biological context**.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- The integration system connects local data and expert context to an SDP, review tools, shared or local semantic resources, EML, and catalog publication.
- A dataset can contain multiple tables; a flat file contains one rectangular table.
- The metadata CSVs are visible review surfaces, not hidden software internals.
- SDP is a custom Frictionless profile with explicit external-standard alignments and salmon-specific rules.
- The Salmon Domain Ontology provides shared anchors between bounded contexts; it does not erase locally governed meanings.
- Reuse shared terms when meanings match, propose shared extensions when reuse is broad and stable, and federate local terms when the local distinction matters.
- EML export uses reviewed mapping facts that cannot be inferred from the source table alone.

::::::::::::::::::::::::::::::::::::::::::::::::
