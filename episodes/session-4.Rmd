---
title: "Review Terms and Measurement Meanings"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- Which terms should we map first?
- How do I decide whether a suggested IRI is good enough to keep?
- What does I-ADOPT clarify for measurement columns?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Review suggested `term_iri` values without treating them as final.
- Prioritize measurements, units, observation units, and important categorical code lists.
- Decompose a measurement using SDP semantic fields without confusing units or methods with I-ADOPT roles.

::::::::::::::::::::::::::::::::::::::::::::::::

## Do not map everything first

The package does not need an IRI for every field. Start with fields where shared meaning changes whether data can be compared:

- measurement variables;
- units;
- observation units, meaning what each row is about;
- categorical code lists that are reused or high-risk;
- fields that carry important constraints, such as origin, life stage, method, or inclusion rules.

Administrative IDs, file names, local notes, and one-off workflow fields can often rely on clear descriptions.

## Generate suggestions for the current package

If you used the fast `seed_semantics = FALSE` classroom path, generate candidates now from the package you reviewed. If semantic seeding was enabled during `create_sdp()`, the package-root `semantic_suggestions.csv` contains the original evidence; rerunning after your metadata edits searches only from the current package state.

::::::::::::::::::::::::::::::::::::: group-tab

## R

```r
pkg <- read_salmon_datapackage(pkg_path)

reviewed_dict <- suggest_semantics(
  df = pkg$resources,
  dict = pkg$dictionary,
  codes = pkg$codes,
  table_meta = pkg$tables,
  dataset_meta = pkg$dataset
)

suggestions <- attr(reviewed_dict, "semantic_suggestions")

suggestions |>
  dplyr::filter(target_scope == "column") |>
  dplyr::select(
    column_name,
    dictionary_role,
    label,
    iri,
    source,
    definition
  )
```

## Python

```python
from metasalmonpy import (
    read_salmon_datapackage,
    suggest_semantics,
)

pkg = read_salmon_datapackage(pkg_path)

reviewed_dict = suggest_semantics(
    df=pkg["resources"],
    dict_df=pkg["dictionary"],
    codes=pkg["codes"],
    table_meta=pkg["tables"],
    dataset_meta=pkg["dataset"],
)

suggestions = reviewed_dict.attrs["semantic_suggestions"]

column_suggestions = suggestions.loc[
    suggestions["target_scope"].eq("column"),
    [
        "column_name",
        "dictionary_role",
        "label",
        "iri",
        "source",
        "definition",
    ],
]

print(column_suggestions)
```

## Spreadsheet

Open an instructor-prepared `semantic_suggestions.csv` beside the package metadata. Filter to the field or code you are reviewing, then compare each candidate label and definition with the source documentation and the data holder's explanation. Record **keep**, **replace**, **remove**, or **defer**; opening the CSV does not accept a suggestion or prove that a link is correct.

::::::::::::::::::::::::::::::::::::::::::::::::

Vocabulary lookup can take a few minutes. For a live workshop, instructors can prepare this output in advance. Omitting `sources` uses role-aware defaults. If you supply `sources` explicitly, current `metasalmon` and `metasalmonpy` treat the vector as a strict allowlist for the initial search and any LLM-requested bounded retry.

Vocabulary lookup can fail independently of returning zero matches. If a result is unexpectedly empty, inspect a focused search before declaring a vocabulary gap:

::::::::::::::::::::::::::::::::::::: group-tab

## R

```r
probe <- find_terms(
  "spawner count",
  role = "property"
)

attr(probe, "diagnostics")
```

## Python

```python
from metasalmonpy import find_terms

probe = find_terms(
    "spawner count",
    role="property",
)

print(probe.attrs.get("diagnostics"))
```

## Spreadsheet

If an instructor-provided suggestion file is unexpectedly empty, do not record a vocabulary gap from that absence alone. Ask for the lookup diagnostics or use the linked vocabulary documentation to distinguish a service failure from a genuine no-match result.

::::::::::::::::::::::::::::::::::::::::::::::::

A warning or non-success diagnostic is evidence of a lookup problem, not evidence that no appropriate term exists. Do not turn a temporary service outage into a new-term request.

## Treat suggestions as drafts

Some tools write semantic suggestions directly into metadata as `REVIEW: <iri>`. That prefix is a warning, not approval.

Keep a suggested IRI only when:

1. the label matches what the column means;
2. the definition matches the dataset context;
3. the scope is right;
4. the unit is compatible with the values;
5. the mapping does not erase an important caveat.

If any check fails, replace it, remove it, or add it to the term-gap plan.

## Measurement semantics

For `column_role = measurement`, SDP combines a variable link, I-ADOPT-style meaning components, a unit link, and an optional statistical-modifier link.

| Field | Plain-language question |
| --- | --- |
| `term_iri` | What complete measurement variable is this? |
| `property_iri` | I-ADOPT property: what characteristic is measured, such as count, length, mass, or temperature? |
| `entity_iri` | I-ADOPT entity/object of interest: what is being measured? |
| `constraint_iri` | Optional I-ADOPT constraint: what qualifier narrows the meaning? |
| `unit_iri` | What unit are the values in? |
| `statistical_modifier_iri` | Optional: is the column an aggregation or summary — a mean, maximum, minimum, total, or peak — rather than a single observation? |

**Methods do not live in the column dictionary.** A method describes how a value was produced, not what the column is, so it is recorded where it is actually constant: a procedure shared by a whole table goes in `tables.csv$method_iri`, a citable protocol document goes in `protocol_iri`/`protocol_citation` on `tables.csv` or `dataset.csv`, and a method that varies row by row becomes a code column in the data whose values resolve through `codes.csv$term_iri` to shared-vocabulary procedures. A statistical modifier is the one kind of "how" that stays in the dictionary, because a *mean* weight and a *maximum* weight are different variables.

Important boundary: `property_iri`, `entity_iri`, `constraint_iri`, and `statistical_modifier_iri` are I-ADOPT-style measurement-variable components. `unit_iri` is also measurement semantics, but units are not an I-ADOPT role, and methods are not part of the variable at all. Do not use these fields as general-purpose relationship fields for identifiers, attributes, or categorical columns.

## Optional LLM-assisted bundle review

Adding `llm_assess = TRUE` in R or `llm_assess=True` in Python, plus an approved provider and model, asks the LLM to judge the retrieved candidates; it does not let the model invent IRIs. A measurement's variable, property, entity, unit, constraint, and statistical-modifier candidates are reviewed together as one bundle. A statistical-modifier candidate is proposed only when the column's name, label, or description names an aggregation such as total, mean, maximum, minimum, or peak. Method candidates apply to code values, where codes can resolve to shared `sosa:Procedure` concepts.

The package clients bound retries for temporary provider failures and keep credentials out of reported URLs. These safeguards reduce avoidable failures; they do not authorize unbounded retries, sensitive context, or unattended acceptance of LLM decisions.

Deterministic validators can downgrade an unsupported `accept` decision to `review`, but they never substitute or invent a term. Suggested candidates written into the dictionary carry the `REVIEW:` prefix until a person confirms them.

Context files must be passed as existing local file paths through `llm_context_files`, and context alone does not enable an LLM call. Use only an approved provider and appropriate non-sensitive context.

## Example review

Column: `natural_spawner_count`

| Question | Review answer |
| --- | --- |
| What is measured? | Count of naturally spawning adult salmon |
| Property | Count or abundance |
| Entity | Adult spawning salmon population |
| Constraint | Natural-origin or naturally spawning, depending on source definition |
| Unit | Fish or individuals |
| Statistical modifier | Blank here; fill it only when the column is an aggregation, such as a *peak* or *mean* count |
| Method | Not a dictionary field: record the survey or estimator on `tables.csv` when it is constant for the table, or as a code column when it varies by row |

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Review two mapped fields

Pick one measurement column and one non-measurement column.

For each:

- read the description;
- inspect any suggested IRI;
- decide keep, replace, remove, or defer;
- write one sentence explaining the decision.

For the measurement column, also fill or review the property, entity, unit, and optional constraint and statistical-modifier fields, and decide where any method information belongs (table level, protocol citation, or code column).

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Prioritize semantic review where shared meaning affects comparison or reuse.
- `REVIEW:` suggestions are evidence to inspect, not final answers.
- Optional LLM review selects from deterministic candidates and remains subject to deterministic checks.
- SDP measurement semantic fields are measurement-only in the column dictionary; methods live at the table, protocol, or code level rather than in the dictionary, and I-ADOPT itself does not model units or methods.

::::::::::::::::::::::::::::::::::::::::::::::::
