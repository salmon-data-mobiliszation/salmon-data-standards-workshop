---
title: Reference
---

## Core workflow

1. Create a draft package.
2. Improve dataset, table, column, code, and README/context descriptions.
3. Review suggested semantic links.
4. Focus first on measurements, units, observation units, and important code lists.
5. Route unresolved terms to shared, DFO-specific, local/profile, or defer.
6. Run strict validation only when the package is final enough for publication.

## Salmon Data Package files

| File | Purpose |
| --- | --- |
| `metadata/dataset.csv` | Dataset-level title, description, contact, license, coverage, provenance |
| `metadata/tables.csv` | Table-level labels, row meaning, file paths, observation units |
| `metadata/column_dictionary.csv` | Column labels, descriptions, roles, types, units, semantic fields |
| `metadata/codes.csv` | Code values and labels for categorical columns |
| `data/*.csv` | Data tables |
| `datapackage.json` | Generated machine-readable descriptor |
| `README.md` or `README-review.txt` | Human context, caveats, and review checklist |

## Column roles

| Role | Use for |
| --- | --- |
| `identifier` | Keys, IDs, or fields used to identify rows or related records |
| `attribute` | Descriptive fields that are not measurements or categories |
| `temporal` | Dates, datetimes, years, or time periods |
| `categorical` | Values from a defined set, usually documented in `codes.csv` |
| `measurement` | Observed or computed quantities |

## Measurement semantic fields

For measurement rows, SDP semantics may include:

| Field | Meaning |
| --- | --- |
| `term_iri` | IRI for the whole measurement variable |
| `property_iri` | I-ADOPT property: the characteristic measured |
| `entity_iri` | I-ADOPT entity/object of interest |
| `constraint_iri` | Optional I-ADOPT constraint that narrows the meaning |
| `unit_iri` | Unit IRI, usually from a unit vocabulary such as QUDT |
| `method_iri` | Optional procedure or method IRI, aligned outside I-ADOPT |

Do not use `property_iri`, `entity_iri`, `constraint_iri`, or `method_iri` as general relationship fields for identifiers, attributes, or categorical columns.

## Routing unresolved terms

| Route | Use when |
| --- | --- |
| Shared Salmon Domain Ontology (`smn:`) | Stable, policy-neutral, reusable across multiple organizations |
| GC DFO Salmon Ontology | DFO Pacific operational, process, data stewardship, or policy terms |
| Local/profile vocabulary or ontology | Project-specific terms, local codelists, method bins, status categories, or uncertain reuse |
| Defer | Description is enough for now, or evidence is too weak |

SKOS is usually best for codelists, status categories, and method bins. OWL is for durable domain structure and formal relationships.

## New-term request checklist

Include:

- proposed label;
- definition;
- source for the definition;
- example rows or values;
- suggested parent, scheme, or nearby term;
- existing terms that were close but not exact;
- route: shared, GCDFO/DFO-specific, local/profile, or defer;
- mapping strength and confidence when relevant;
- reviewer action: accept, review, defer, or request new term.

## Glossary

**I-ADOPT**: A framework for describing what a measurement variable means using property, entity, and optional constraints. It does not model units, methods, time, or location by itself.

**IRI**: A web identifier that points to a term or definition.

**OWL**: A language for formal ontology classes and relationships.

**Salmon Data Package**: A folder of data and metadata CSV files that makes a dataset easier to review, validate, and share.

**SKOS**: A model for controlled vocabularies, concept schemes, labels, definitions, and mappings.

**`REVIEW: <iri>`**: A draft semantic suggestion that must be checked before publication.
