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

For `column_role = measurement`, SDP combines a variable link, I-ADOPT-style meaning components, a unit link, and an optional method/procedure link.

| Field | Plain-language question |
| --- | --- |
| `term_iri` | What complete measurement variable is this? |
| `property_iri` | I-ADOPT property: what characteristic is measured, such as count, length, mass, or temperature? |
| `entity_iri` | I-ADOPT entity/object of interest: what is being measured? |
| `constraint_iri` | Optional I-ADOPT constraint: what qualifier narrows the meaning? |
| `unit_iri` | What unit are the values in? |
| `method_iri` | What method or procedure matters for interpretation, modeled outside I-ADOPT? |

Important boundary: `property_iri`, `entity_iri`, and `constraint_iri` are I-ADOPT-style measurement-variable components. `unit_iri` and `method_iri` are also measurement semantics, but units and methods are not I-ADOPT roles. Do not use these fields as general-purpose relationship fields for identifiers, attributes, or categorical columns.

## Example review

Column: `natural_spawner_count`

| Question | Review answer |
| --- | --- |
| What is measured? | Count of naturally spawning adult salmon |
| Property | Count or abundance |
| Entity | Adult spawning salmon population |
| Constraint | Natural-origin or naturally spawning, depending on source definition |
| Unit | Fish or individuals |
| Method | Use only if the survey or estimator is part of the variable meaning |

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Review two mapped fields

Pick one measurement column and one non-measurement column.

For each:

- read the description;
- inspect any suggested IRI;
- decide keep, replace, remove, or defer;
- write one sentence explaining the decision.

For the measurement column, also fill or review the property, entity, unit, and optional constraint/method fields.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Prioritize semantic review where shared meaning affects comparison or reuse.
- `REVIEW:` suggestions are evidence to inspect, not final answers.
- SDP measurement semantic fields are measurement-only in the column dictionary, and I-ADOPT itself does not model units or methods.

::::::::::::::::::::::::::::::::::::::::::::::::
