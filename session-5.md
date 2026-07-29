---
title: "Code Lists, SKOS, and Local Vocabulary"
teaching: 45
exercises: 35
---

:::::::::::::::::::::::::::::::::::::: questions

- How should categorical values be documented?
- When is SKOS the right model?
- When should a vocabulary or ontology stay local or profile-scoped?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Build or review `metadata/codes.csv` for categorical columns.
- Explain SKOS as a practical way to document concept schemes and code lists.
- Decide whether a term belongs in a shared ontology, DFO-specific ontology, or local/profile vocabulary.

::::::::::::::::::::::::::::::::::::::::::::::::

## Categorical values need definitions too

A categorical column stores values from a known set, such as species codes, origin categories, run timing, method bins, or status values. The data table may store compact values, but reviewers need the meaning.

Use `metadata/codes.csv` when a column has controlled values. It is required when any `column_dictionary.csv` row has `column_role = categorical`. Each observed non-empty value must have exactly one matching row for its `dataset_id` + `table_id` + `column_name` + `code_value` key; do not leave observed values undocumented or duplicate that key.

`code_value` is required unless `vocabulary_iri` is supplied. A vocabulary-only row with a blank `code_value` documents an external vocabulary but does not cover any value observed in the data.

This work is language-independent: `metasalmon` and `salmonpy` read and write the same `metadata/codes.csv` structure.

| Field | Purpose |
| --- | --- |
| `column_name` | Which column uses this code |
| `code_value` | Stored value in the data |
| `code_label` | Human-readable label |
| `code_description` | Meaning, scope, or caveat |
| `vocabulary_iri` | Recommended IRI for the whole vocabulary |
| `term_iri` | Recommended IRI for the specific code concept |

## SKOS in plain language

Keep three related ideas separate:

- a **code list** records the allowed stored values for one data column;
- a **vocabulary** is a maintained list of reusable terms and definitions;
- an **ontology** is a maintained set of concepts and definitions that also records relationships among them.

SKOS is a way to publish controlled vocabularies: lists of concepts, labels, definitions, and relationships. It is usually the right pattern for:

- code values;
- method bins;
- status categories;
- local policy or program categories;
- labels that people need to review and govern.

SKOS is not a full logical model of the world. That is why it is often easier and safer for operational code lists.

## Shared, DFO-specific, or local?

Use this decision path before proposing a new shared term.

| If the term is... | Put it first in... |
| --- | --- |
| stable, policy-neutral, and likely useful across organizations | shared Salmon Domain Ontology (`smn:`) |
| specific to DFO policy, operations, or stewardship practice | GC DFO Salmon Ontology or DFO profile |
| specific to one project, program, workbook, or local workflow | local/profile vocabulary or ontology |
| unclear or poorly sourced | package description and reviewer question |

The safe default is local/profile first when reuse is uncertain. SKOS is usually best for local code lists, status categories, and method bins. OWL should be reserved for durable formal structure. Terms can be promoted later when there is evidence that other groups need them.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Build a code-list review table

Pick one categorical column.

Create or improve rows for each code value:

- stored value;
- label;
- definition;
- source or reviewer;
- whether a shared term already exists;
- whether the value should stay local for now.

Then compare the table with the data: every observed non-empty value should have one matching row for that dataset, table, column, and value, and that key should not be duplicated.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- `codes.csv` is the review surface for controlled categorical values.
- Each observed non-empty categorical value needs exactly one matching row for its dataset/table/column/value key.
- SKOS is usually the right model for code lists and status/method categories, but local/profile work is not always SKOS-only.
- Do not promote local vocabulary to shared `smn:` without evidence of broad reuse.

::::::::::::::::::::::::::::::::::::::::::::::::
