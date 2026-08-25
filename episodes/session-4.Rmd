---
title: "Review Terms and Measurement Meanings"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- How do we keep semantic review small enough to finish in the workshop?
- How do I decide whether a suggested IRI is good enough to keep?
- What does I-ADOPT clarify for measurement columns?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Review one suggested `term_iri` for the Fraser Coho measurement without treating it as final.
- Decompose that same measurement once using the SDP's I-ADOPT fields.
- Review one unit IRI, one table observation-unit IRI, and one method-code IRI without confusing those links with I-ADOPT roles.

::::::::::::::::::::::::::::::::::::::::::::::::

## Keep the workshop semantic review bounded

In this workshop, we will not try to map every column. Everyone will use the NuSEDS Fraser Coho escapement example for one shared semantic-review exercise, even if you are also building a package from your own data. That gives the room one case to discuss and keeps the decisions small enough to finish.

We will review exactly these linked decisions:

| Decision | SDP destination | Shared Fraser Coho example |
| --- | --- | --- |
| One complete measurement-variable IRI | `column_dictionary.csv$term_iri` | `NATURAL_SPAWNERS_TOTAL` |
| One I-ADOPT decomposition | `property_iri`, `entity_iri`, and optional `constraint_iri` on that same dictionary row | abundance for natural-origin salmon in a conservation unit |
| One simple unit | `column_dictionary.csv$unit_iri` | individuals |
| What each table row represents | `tables.csv$observation_unit_iri` | an escapement estimate |
| One method | `codes.csv$term_iri` for one `ESTIMATE_METHOD` value | `Area Under the Curve` |

The method is a code-level example because the NuSEDS estimate method varies by row. It is not part of the I-ADOPT decomposition. Administrative IDs, file names, local notes, and the other categorical code lists can rely on clear descriptions for now and be mapped in a later review.

## Generate suggestions for the shared example

Continue with the NuSEDS Fraser Coho package from Session 2, even if you created another package from your own data in Session 3. The quickstart used `seed_semantics = FALSE`, so generate candidates now from the metadata you reviewed. If semantic seeding was already enabled for this package, its package-root `semantic_suggestions.csv` contains the original evidence; rerunning after metadata edits searches from the current package state.

The code below subsets the metadata before lookup, so deterministic search runs only for the shared measurement and table target. The `Area Under the Curve` method row is populated by the deterministic NuSEDS crosswalk during package creation, so this lesson reads and reviews that row instead of searching every method code again.

::::::::::::::::::::::::::::::::::::: group-tab

### R

```r
example_pkg_path <- file.path(
  "output",
  "fraser-coho-example-sdp"
)

pkg <- read_salmon_datapackage(example_pkg_path)

measurement_dict <- pkg$dictionary |>
  dplyr::filter(
    column_name == "NATURAL_SPAWNERS_TOTAL"
  )

shared_table <- pkg$tables |>
  dplyr::filter(table_id == "escapement")

reviewed_dict <- suggest_semantics(
  df = pkg$resources,
  dict = measurement_dict,
  table_meta = shared_table
)

suggestions <- attr(reviewed_dict, "semantic_suggestions")

bounded_suggestions <- suggestions |>
  dplyr::filter(
    (
      target_scope == "column" &
        column_name == "NATURAL_SPAWNERS_TOTAL" &
        dictionary_role %in% c(
          "variable",
          "property",
          "entity",
          "constraint",
          "unit"
        )
    ) |
      (
        target_scope == "table" &
          target_sdp_field == "observation_unit_iri"
      )
  ) |>
  dplyr::select(
    target_scope,
    column_name,
    dictionary_role,
    target_sdp_field,
    label,
    iri,
    source,
    definition
  )

method_example <- pkg$codes |>
  dplyr::filter(
    column_name == "ESTIMATE_METHOD",
    code_value == "Area Under the Curve"
  ) |>
  dplyr::select(
    column_name,
    code_value,
    term_iri
  )

bounded_suggestions
method_example
```

### Python

```python
from pathlib import Path

from metasalmonpy import (
    read_salmon_datapackage,
    suggest_semantics,
)

example_pkg_path = Path("output") / "fraser-coho-example-sdp"

pkg = read_salmon_datapackage(example_pkg_path)

measurement_dict = pkg["dictionary"].loc[
    pkg["dictionary"]["column_name"].eq("NATURAL_SPAWNERS_TOTAL")
]
shared_table = pkg["tables"].loc[
    pkg["tables"]["table_id"].eq("escapement")
]

reviewed_dict = suggest_semantics(
    df=pkg["resources"],
    dict_df=measurement_dict,
    table_meta=shared_table,
)

suggestions = reviewed_dict.attrs["semantic_suggestions"]

measurement_targets = (
    suggestions["target_scope"].eq("column")
    & suggestions["column_name"].eq("NATURAL_SPAWNERS_TOTAL")
    & suggestions["dictionary_role"].isin(
        ["variable", "property", "entity", "constraint", "unit"]
    )
)
table_target = (
    suggestions["target_scope"].eq("table")
    & suggestions["target_sdp_field"].eq("observation_unit_iri")
)

bounded_suggestions = suggestions.loc[
    measurement_targets | table_target,
    [
        "target_scope",
        "column_name",
        "dictionary_role",
        "target_sdp_field",
        "label",
        "iri",
        "source",
        "definition",
    ],
]

method_example = pkg["codes"].loc[
    pkg["codes"]["column_name"].eq("ESTIMATE_METHOD")
    & pkg["codes"]["code_value"].eq("Area Under the Curve"),
    ["column_name", "code_value", "term_iri"],
]

print(bounded_suggestions)
print(method_example)
```

### Spreadsheet

Open an instructor-prepared `semantic_suggestions.csv` beside the NuSEDS Fraser Coho package metadata. Filter to `NATURAL_SPAWNERS_TOTAL` and the table observation-unit row. Then inspect the `Area Under the Curve` row in `metadata/codes.csv`. Compare each IRI, label, and definition with the source documentation and the data holder's explanation. Record **keep**, **replace**, **remove**, or **defer**; opening the CSV does not accept a suggestion or prove that a link is correct.

::::::::::::::::::::::::::::::::::::::::::::::::

Vocabulary lookup can take a few minutes. Omitting `sources` uses role-aware defaults. If you supply `sources` explicitly, current `metasalmon` and `metasalmonpy` treat the vector as a strict allowlist for the initial search and any LLM-requested bounded retry.

At this stage, treat an empty or unexpected result as **unresolved**, not as proof that the vocabulary lacks an appropriate term. Leave that decision in review and continue with the shared example; a later workflow can distinguish a lookup problem from a genuine term gap.

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

Shared example column: `NATURAL_SPAWNERS_TOTAL`

| Decision | Fraser Coho candidate to review |
| --- | --- |
| Complete measurement variable, `term_iri` | Natural-origin spawner abundance; review `https://w3id.org/gcdfo/salmon#SpawnerAbundance` against the NuSEDS definition. |
| I-ADOPT property, `property_iri` | Abundance; review `https://w3id.org/smn/Abundance`. |
| I-ADOPT entity, `entity_iri` | The conservation unit recorded in `FULL_CU_IN`; review `https://w3id.org/gcdfo/salmon#ConservationUnit`. |
| I-ADOPT constraint, `constraint_iri` | Natural origin; review `https://w3id.org/smn/NaturalOrigin`. |
| Unit, `unit_iri` | Individuals; review `https://qudt.org/vocab/unit/INDIV`. This is measurement semantics, but not an I-ADOPT role. |
| Statistical modifier | Leave blank for this exercise; do not infer *total*, *peak*, or *mean* without confirming what the source value represents. |
| Table observation unit | Each row reports an escapement estimate; review `https://w3id.org/smn/EscapementEstimate` for `tables.csv$observation_unit_iri`. |
| Method | `ESTIMATE_METHOD` varies by row. Review the `Area Under the Curve` code mapping to `https://w3id.org/gcdfo/salmon#AreaUnderTheCurve` in `codes.csv$term_iri`; do not put it in the measurement's I-ADOPT fields. |

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Complete the bounded Fraser Coho review

Work with the shared NuSEDS Fraser Coho package, even if you brought your own dataset. Complete only this review:

1. choose **keep**, **replace**, **remove**, or **defer** for the one `NATURAL_SPAWNERS_TOTAL` `term_iri` candidate, and write one sentence explaining why;
2. complete one I-ADOPT decomposition of that same measurement by reviewing its property, entity, and natural-origin constraint;
3. review the QUDT Individual unit IRI;
4. review the escapement-estimate IRI that says what each table row represents; and
5. review the `Area Under the Curve` method-code IRI in `codes.csv`.

Do not map additional fields during this exercise. After the workshop, use the same sequence for another measurement in your own package.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- The workshop semantic exercise is bounded to one Fraser Coho measurement, one I-ADOPT decomposition, one unit, one table observation unit, and one method code.
- `REVIEW:` suggestions are evidence to inspect, not final answers.
- Optional LLM review selects from deterministic candidates and remains subject to deterministic checks.
- SDP measurement semantic fields are measurement-only in the column dictionary; methods live at the table, protocol, or code level rather than in the dictionary, and I-ADOPT itself does not model units or methods.

::::::::::::::::::::::::::::::::::::::::::::::::
