---
title: Reference
---

## Core workflow

1. Create a draft package from one table or a named list of tables.
2. Improve dataset, table, column, code, and README/context descriptions.
3. Review suggested semantic links.
4. Focus first on measurements, units, observation units, and important code lists.
5. Render and review unresolved-term routes: `smn`, `gcdfo`, `profile`, or `skip`.
6. Run strict R validation only when the SDP is final enough for publication.
7. Complete the reviewed EML sidecar and export schema-valid EML 2.2.
8. Preview the KNB/DataONE object plan with a credential-free dry run; upload only with explicit authority and credentials.

## R-first and Python companion functions

| Workflow | R primary | Python companion |
| --- | --- | --- |
| Create a package | `metasalmon::create_sdp()` | `metasalmonpy.create_sdp()` |
| Read a package | `read_salmon_datapackage()` | `read_salmon_datapackage()` |
| Suggest shared definitions | `suggest_semantics()` | `suggest_semantics()` |
| Detect unresolved gaps | `detect_semantic_term_gaps()` | `detect_semantic_term_gaps()` |
| Render request drafts | `render_ontology_term_request()` | `render_ontology_term_request()` |
| Validate during review | `validate_salmon_datapackage(..., require_iris = FALSE)` | `validate_salmon_datapackage(..., require_iris=False)` |
| Run the final publication gate | `validate_salmon_datapackage(..., require_iris = TRUE)` | Hand off to current R/`metasalmon` for the `sdp-0.3.0` gate |
| Migrate an `sdp-0.2.0` package | `migrate_sdp_methods()` | Hand off to current R/`metasalmon` |
| Export validated EML | `write_eml_from_sdp()` | `write_eml_from_sdp()` (at 0.2.1 parity; this lesson runs it in R) |
| Plan or run a KNB deposit | `publish_sdp_to_knb()` | `publish_sdp_to_knb()` (at 0.2.1 parity; this lesson runs it in R) |

The lesson targets the tagged **R/`metasalmon` 0.3.0 release** (specification `sdp-0.3.0`). The Python companion is **`metasalmonpy` 0.2.1**, whose version is a parity claim: it mirrors metasalmon 0.2.1 behaviour and writes the earlier `sdp-0.2.0` package shape. Do not describe the implementations as fully version- or feature-aligned, and migrate Python-created packages with `migrate_sdp_methods()` before the R publication gate.

## Recent metasalmon updates reflected here

| Version | Workshop-relevant change |
| --- | --- |
| 0.1.7–0.1.8 | Added reviewed EML 2.2 export, guarded KNB/DataONE planning/publication, expanded package representation, and immutable revision handling. |
| 0.2.0 | Made dictionary `value_type` the read authority, fixed multi-table handling, preserved reviewed sidecars during ordinary rewrites, and added `prune` as the explicit destructive reset. |
| 0.2.1 | Made semantic ranking locale-independent and derived descriptor schema URLs from the validated SDP bundle. |
| 0.2.2 | Cached term indexes for consistent, faster sessions and made failed vocabulary lookups distinguishable from successful zero-match searches. |
| 0.2.3 | Allowed corrected unpublished KNB dry runs to be replanned with `overwrite = TRUE`, added bounded provider retries, and moved/redacted the BioPortal credential. |
| 0.2.4 | Made the empty field the single canonical missing-value token: a literal `"NA"` in data now round-trips as the string it is (it is a real fisheries gear code), so hand-authored packages using `NA` to mean missing must rewrite those cells as empty fields. |
| 0.2.5 | Extended credential redaction to all qualified `*_token` names in captured errors and reports. |
| 0.2.6 | Enforced declared `primary_key` uniqueness as a validation error, warned on value-like column names (pointing at `tidyr::pivot_longer()`), and surfaced unresolved `MISSING METADATA:` placeholders in default validation. |
| 0.3.0 | Implemented `sdp-0.3.0`: removed the dictionary `method_iri` and the `metadata/methods.csv` registry, added `statistical_modifier_iri`, moved methods to `tables.csv`/`protocol_iri`/`codes.csv`, and added `migrate_sdp_methods()` for 0.2.x packages. |

See the [metasalmon changelog][metasalmon-changelog] for the full implementation record. These changes do not turn a draft package, failed lookup, private deposit, or Member Node write into publication evidence.

## Recommended project layout

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  raw_data/       # unchanged source CSVs or workbooks
  context/        # codebooks, methods, caveats, provenance
  output/         # generated Salmon Data Packages
```

Open the `.Rproj` file before working and use paths relative to the project root. Python and spreadsheet users can start from the same root folder and use the same layout.

## Dataset, table, and supported inputs

**Dataset** means the complete collection being documented. It can contain one or many related tables.

**Table** means one rectangular set of rows and columns with a consistent row meaning.

**Flat file** means a file containing one two-dimensional table, normally with one header row; CSV is the usual example. An Excel workbook can contain several sheets/tables and is not itself one flat file.

| Input structure | Workshop support |
| --- | --- |
| One CSV or rectangular data frame | Pass one data frame and a `table_id` to `create_sdp()`. |
| Several CSVs | Read them separately and pass a named list of data frames. |
| Excel with one or several rectangular sheets | Read each sheet with `readxl::read_excel()` and pass a named list. |
| NetCDF, raster, multidimensional array, nested data | Not directly supported; use a format-specific workflow or an explicitly reviewed tabular derivative. |

The output SDP data resources are CSV files.

## Salmon Data Package files

| File | Purpose |
| --- | --- |
| `metadata/dataset.csv` | Dataset-level title, description, contact, license, coverage, discovery, and provenance fields |
| `metadata/tables.csv` | One row per table: file path, label, row meaning, observation unit, primary key, and table-level `method_iri`/`protocol_iri`/`protocol_citation` |
| `metadata/column_dictionary.csv` | One row per data column: labels, definitions, roles, types, units, and semantic fields |
| `metadata/codes.csv` | Required when categorical columns exist; one row per observed non-empty dataset/table/column/value key |
| `data/*.csv` | One or more tabular data resources |
| `datapackage.json` | Generated Frictionless descriptor required for complete/published packages; it must agree with the CSV metadata and data files |
| `README.md` or `README-review.txt` | Human context, caveats, or review checklist |
| `metadata/eml-mapping.yml` | Reviewed facts needed for EML and KNB that cannot be inferred safely from SDP alone |
| `metadata/eml.xml` | Validated EML 2.2 export created near the end, not a hand-edited source file |
| `publication/knb-manifest.json` | Exact-object KNB/DataONE dry-run or recovery manifest |

Complete filled examples are linked from Session 1: [dataset.csv][sdp-example-dataset], [tables.csv][sdp-example-tables], [column_dictionary.csv][sdp-example-dictionary], and [codes.csv][sdp-example-codes].

## Standards and conventions behind the fields

| Source | Scope in SDP |
| --- | --- |
| Frictionless Data Package/Table Schema | Package/resource descriptors, field types and constraints, and the schemas used to validate canonical CSVs |
| SDP custom profile | Exact files, columns, joins, `column_role`, cross-table rules, and publication requirements |
| I-ADOPT | Measurement property, entity, and optional constraint roles |
| SOSA | Procedure alignment for table-level `method_iri` and method code values (`term_type = sosa:Procedure` in `codes.csv`) |
| SKOS/OWL and published vocabularies | Reusable terms and code meanings |
| QUDT or another reviewed unit vocabulary | Unit IRIs |
| EML | A downstream ecological metadata export and catalog representation, not the authoring source of every SDP field |

Every canonical metadata CSV is defined with Frictionless Table Schema, but the SDP profile defines the field names and salmon-specific rules. A field that can map to EML is not automatically an EML-native field.

## Field definitions and accepted values

The complete, current source is the [SDP field reference][sdp-field-reference]. These are the fields learners most often need to interpret:

| Field | Meaning | Accepted values or rule |
| --- | --- | --- |
| `column_role` | Function of the column in its table | `identifier`, `attribute`, `temporal`, `categorical`, `measurement` |
| `value_type` | Basic type of values stored in the column | `integer`, `number`, `string`, `boolean`, `date`, `datetime` |
| `required` | Whether each data row must contain a value in that source column | `TRUE`, `FALSE`, or blank. It does not mean “this metadata header is required.” |
| `unit_label` | Human-readable unit | Free text; blank when a unit is not applicable. |
| `unit_iri` | Stable identifier for the unit | A valid absolute IRI; conditionally required when `column_role = measurement`. |
| `term_type` | Kind of linked term | `owl_class`, `owl_object_property`, or `skos_concept` in the column dictionary |
| `update_frequency` | Planned dataset update cadence | `daily`, `weekly`, `monthly`, `annually`, `asNeeded`, or `unknown` |
| `temporal_start`, `temporal_end` | Dataset coverage boundary | A year (`YYYY`) or full date (`YYYY-MM-DD`); not a partial `YYYY-MM` date |

Value types mean:

- `integer`: whole numbers only;
- `number`: numeric values that may include decimals;
- `string`: text;
- `boolean`: logical true/false values;
- `date`: ISO date `YYYY-MM-DD`; and
- `datetime`: ISO datetime with a timezone, such as `YYYY-MM-DDTHH:MM:SSZ`.

## Column roles

| Role | Use for |
| --- | --- |
| `identifier` | Keys, IDs, or fields used to identify rows or related records |
| `attribute` | Descriptive fields that are not measurements or controlled categories |
| `temporal` | Dates, datetimes, years, or time periods |
| `categorical` | Values from a defined set; requires `codes.csv` coverage |
| `measurement` | Observed or computed quantities |

## Measurement semantic fields

For publication-ready measurement rows, SDP requires `term_iri`, `property_iri`, `entity_iri`, and `unit_iri`. Constraint and statistical-modifier IRIs remain optional.

| Field | Publication requirement | Meaning |
| --- | --- | --- |
| `term_iri` | Required | IRI for the whole measurement variable |
| `property_iri` | Required | I-ADOPT property: the characteristic measured |
| `entity_iri` | Required | I-ADOPT entity/object of interest |
| `constraint_iri` | Optional | I-ADOPT constraint that narrows the meaning; multiple IRIs are semicolon-separated |
| `unit_iri` | Required | Unit IRI, usually from a unit vocabulary such as QUDT |
| `statistical_modifier_iri` | Optional | I-ADOPT statistical modifier: fill it only when the column is an aggregation or summary (mean, maximum, minimum, total, peak), because the summary is part of the variable's identity |

Since `sdp-0.3.0`, the dictionary has no `method_iri` column and the `metadata/methods.csv` registry is gone. A method lives where it is constant: `tables.csv$method_iri` for a whole-table procedure, `protocol_iri`/`protocol_citation` on `tables.csv` or `dataset.csv` for a citable document, or a code column resolving through `codes.csv$term_iri` when the method varies by row.

Do not use `property_iri`, `entity_iri`, `constraint_iri`, or `statistical_modifier_iri` as general relationship fields for identifiers, attributes, or categorical columns.

## SDP-to-EML crosswalk

| SDP source | EML result |
| --- | --- |
| `dataset_id` | Alternate identifier and deterministic EML identifier input |
| Dataset title and description | EML title and abstract |
| Dataset keywords | EML keyword set |
| Dataset temporal start/end | EML temporal coverage |
| Each tables row | EML `dataTable` and physical CSV object |
| Table label and description | EML entity name and description |
| Table primary key | EML primary-key constraint |
| Column name, label, description | EML attribute name, label, definition |
| `value_type` | EML storage type |
| `required = TRUE` | EML not-null constraint |
| `codes.csv` rows | EML enumerated domain |
| Measurement `term_iri` and `unit_iri` | Conservative semantic annotations |
| `eml-mapping.yml` | Structured creators/providers/contacts, rights, methods, scale/domain details, missing values, geographic/taxonomic coverage, and access decision |

Not every semantic component is projected into EML. Current `metasalmon` conservatively annotates the whole measurement term and unit; it does not pretend that every I-ADOPT or method relationship has a direct EML equivalent.

## Rerun safety

| Command or state | Effect |
| --- | --- |
| `create_sdp(..., overwrite = FALSE)` | Fails if the output directory already exists; safest default. |
| `create_sdp(..., overwrite = TRUE)` | Re-infers and rewrites writer-owned package files. Manual edits to canonical metadata can be lost. |
| `create_sdp(..., overwrite = TRUE, prune = FALSE)` in R 0.2.0+ | Preserves non-owned sidecars, but still replaces owned metadata/data/descriptor outputs. |
| `create_sdp(..., overwrite = TRUE, prune = TRUE)` | Empties the package first; use only for a deliberately disposable package. |
| `read_salmon_datapackage()` | Loads the manually reviewed package as the current source state. |
| `write_salmon_datapackage(..., path = <new-version>, overwrite = FALSE)` | Writes an intentional new version without overwriting the reviewed folder. |
| `publish_sdp_to_knb(..., overwrite = TRUE)` | Rebuilds conflicting artifacts from an unpublished dry run only; it never overwrites live immutable DataONE objects. |

After manual edits, continue with read/validate helpers or write a new versioned package. Do not casually rerun `create_sdp()` on the same folder.

## Publication checks

- Required metadata values are complete, and canonical headers exactly match the schemas in order with no extras.
- Every `tables.csv$file_name` is a safe relative path to an existing data file.
- Dictionary rows and column names exactly match the referenced data headers.
- Every observed non-empty categorical value has exactly one matching `codes.csv` row.
- Measurement rows have final `term_iri`, `property_iri`, `entity_iri`, and `unit_iri` values.
- No placeholder text or `REVIEW:` prefixes remain.
- `datapackage.json` declares the current SDP profile/resources and agrees with the canonical CSVs.
- Strict R validation passes.
- The EML sidecar has reviewed parties, rights authorization, methods, scales/domains, missing values, provenance, and bound semantic-review checksums.
- `write_eml_from_sdp()` returns a valid EML 2.2 result.
- A KNB dry-run manifest is reviewed before any credentialed live call.

## Routing unresolved terms

| Route | Use when |
| --- | --- |
| Shared Salmon Domain Ontology (`smn`) | Stable, policy-neutral, reusable across multiple organizations |
| GC DFO Salmon Ontology (`gcdfo`) | DFO Pacific operational, process, data stewardship, or policy terms |
| Local/profile vocabulary or ontology (`profile`) | Project-specific terms, local code lists, method bins, status categories, or uncertain reuse |
| Skip/defer (`skip`) | Description is enough for now, or evidence is too weak |

SKOS is usually best for code lists, status categories, and method bins. OWL is for durable domain structure and formal relationships.

## New-term request checklist

Include:

- proposed label and definition;
- source for the definition;
- example rows or values;
- suggested parent, scheme, or nearby term;
- existing terms that were close but not exact;
- route: shared, GCDFO/DFO-specific, local/profile, or defer;
- mapping strength and confidence when relevant; and
- reviewer action: accept, review, defer, or request new term.

## Glossary

**Catalog**: A system that indexes metadata so people and software can discover datasets. KNB is the catalog/deposit target currently supported by `publish_sdp_to_knb()`.

**Code list**: The allowed stored values for one data column, with labels and definitions for those values.

**Dataset**: The complete collection being documented; it can contain one or many tables.

**EML**: Ecological Metadata Language, an XML metadata standard used by ecological data repositories and catalogs.

**Flat file**: A file that stores one rectangular table, such as CSV.

**I-ADOPT**: A framework for describing what a measurement variable means using property, entity, and optional constraints. It does not model units, methods, time, or location by itself.

**IRI**: A web identifier that points to a term or definition.

**Ontology**: A maintained set of concepts and definitions that also records how the concepts relate.

**Salmon Data Package**: A folder of one or more data tables and canonical metadata CSVs that makes a dataset easier to review, validate, transform, and share.

**Semantic link or mapping**: A connection from a local column or code value to a shared definition; semantic simply means "about meaning."

**Statistical modifier**: The aggregation or summary that is part of a measurement variable's identity — a mean, maximum, minimum, total, or peak. Recorded in `statistical_modifier_iri`; left blank for plain measurements.

**Table**: A rectangular set of rows and columns with one consistent row meaning.

**Vocabulary**: A maintained list of reusable terms and definitions.

**`REVIEW: <iri>`**: A draft semantic suggestion that must be checked before publication.
