---
title: Reference
---

## Core workflow

1. Create a draft package.
2. Improve dataset, table, column, code, and README/context descriptions.
3. Review suggested semantic links.
4. Focus first on measurements, units, observation units, and important code lists.
5. Render and review unresolved-term routes: `smn`, `gcdfo`, `profile`, or `skip`.
6. Run strict validation only when the package is final enough for publication.

## R-first and Python companion functions

| Workflow | R primary | Python companion |
| --- | --- | --- |
| Create a package | `metasalmon::create_sdp()` | `salmonpy.create_sdp()` |
| Read a package | `read_salmon_datapackage()` | `read_salmon_datapackage()` |
| Suggest shared definitions | `suggest_semantics()` | `suggest_semantics()` |
| Detect unresolved gaps | `detect_semantic_term_gaps()` | `detect_semantic_term_gaps()` |
| Render request drafts | `render_ontology_term_request()` | `render_ontology_term_request()` |
| Validate during review | `validate_salmon_datapackage(..., require_iris = FALSE)` | `validate_salmon_datapackage(..., require_iris=False)` |

The workshop examples pair `metasalmon` 0.1.6 and `salmonpy` 0.1.6. They are parity-tested when packages move between languages, but they are not identical. Run the R `metasalmon` strict validator for the final publication gate.

## Recommended project layout

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  data-raw/       # unchanged source data
  context/        # codebooks, methods, caveats, provenance
  output/         # generated Salmon Data Packages
```

Open the `.Rproj` file before working and use paths relative to the project root. Python users can start from the same root folder and use the same layout.

## Salmon Data Package files

| File | Purpose |
| --- | --- |
| `metadata/dataset.csv` | Dataset-level title, description, contact, license, coverage, provenance |
| `metadata/tables.csv` | Table-level labels, row meaning, file paths, observation units |
| `metadata/column_dictionary.csv` | Column labels, descriptions, roles, types, units, semantic fields |
| `metadata/codes.csv` | Required when categorical columns exist; one row per observed non-empty dataset/table/column/value key |
| `data/*.csv` | Data tables |
| `datapackage.json` | Generated descriptor required for complete/published packages; must agree with the CSV metadata and referenced data files |
| `README.md` or `README-review.txt` | Optional human context, caveats, or review checklist |

## Column roles

| Role | Use for |
| --- | --- |
| `identifier` | Keys, IDs, or fields used to identify rows or related records |
| `attribute` | Descriptive fields that are not measurements or categories |
| `temporal` | Dates, datetimes, years, or time periods |
| `categorical` | Values from a defined set; requires `codes.csv` coverage |
| `measurement` | Observed or computed quantities |

## Measurement semantic fields

For publication-ready measurement rows, SDP requires `term_iri`, `property_iri`, `entity_iri`, and `unit_iri`. Constraint and method IRIs remain optional.

| Field | Publication requirement | Meaning |
| --- | --- | --- |
| `term_iri` | Required | IRI for the whole measurement variable |
| `property_iri` | Required | I-ADOPT property: the characteristic measured |
| `entity_iri` | Required | I-ADOPT entity/object of interest |
| `constraint_iri` | Optional | I-ADOPT constraint that narrows the meaning |
| `unit_iri` | Required | Unit IRI, usually from a unit vocabulary such as QUDT |
| `method_iri` | Optional | Procedure or method IRI, aligned outside I-ADOPT |

Do not use `property_iri`, `entity_iri`, `constraint_iri`, or `method_iri` as general relationship fields for identifiers, attributes, or categorical columns.

## Publication checks

- Required metadata fields are complete and canonical metadata headers exactly match the schema fields, in schema order, with no missing or extra columns.
- Every `tables.csv$file_name` is a safe relative path to an existing data file.
- `column_dictionary.csv` rows and column names match the headers of the referenced data files.
- Every observed non-empty categorical value has exactly one matching `codes.csv` row for its dataset/table/column/value key.
- Measurement rows have final `term_iri`, `property_iri`, `entity_iri`, and `unit_iri` values.
- No placeholder text or `REVIEW:` prefixes remain.
- `datapackage.json` exists, declares the SDP profile and resources, and agrees with the canonical CSV metadata and referenced data files.
- Strict validation passes in the normative R `metasalmon` implementation.

## Routing unresolved terms

| Route | Use when |
| --- | --- |
| Shared Salmon Domain Ontology (`smn`) | Stable, policy-neutral, reusable across multiple organizations |
| GC DFO Salmon Ontology (`gcdfo`) | DFO Pacific operational, process, data stewardship, or policy terms |
| Local/profile vocabulary or ontology (`profile`) | Project-specific terms, local codelists, method bins, status categories, or uncertain reuse |
| Skip/defer (`skip`) | Description is enough for now, or evidence is too weak |

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

**Code list**: The allowed stored values for one data column, with labels and definitions for those values.

**I-ADOPT**: A framework for describing what a measurement variable means using property, entity, and optional constraints. It does not model units, methods, time, or location by itself.

**IRI**: A web identifier that points to a term or definition.

**Ontology**: A maintained set of concepts and definitions that also records how the concepts relate.

**OWL**: A language for formal ontology classes and relationships.

**Salmon Data Package**: A folder of data and metadata CSV files that makes a dataset easier to review, validate, and share.

**Semantic link or mapping**: A connection from a local column or code value to a shared definition; semantic simply means "about meaning."

**SKOS**: A model for controlled vocabularies, concept schemes, labels, definitions, and mappings.

**Vocabulary**: A maintained list of reusable terms and definitions.

**`REVIEW: <iri>`**: A draft semantic suggestion that must be checked before publication.
