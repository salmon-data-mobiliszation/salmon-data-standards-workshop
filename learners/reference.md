---
title: Reference
---

## Core workflow

1. Create a draft package from one table or a named list of tables.
2. Improve dataset, table, column, code, and README/context descriptions.
3. Review suggested semantic links, recording each decision as a line of code in the build script rather than as an edited cell.
4. Focus first on measurements, units, observation units, and important code lists.
5. Render and review unresolved-term routes: `smn`, `gcdfo`, `profile`, or `skip`.
6. Run strict validation only when the SDP is final enough for publication.
7. Complete the reviewed EML sidecar and export schema-valid EML 2.2.
8. Preview the KNB/DataONE object plan with a credential-free dry run; upload only with explicit authority and credentials.

## R and Python functions

| Workflow | R (`metasalmon`) | Python (`metasalmonpy`) |
| --- | --- | --- |
| Create a package | `metasalmon::create_sdp()` | `metasalmonpy.create_sdp()` |
| Read a package | `read_salmon_datapackage()` | `read_salmon_datapackage()` |
| Suggest shared definitions | `suggest_semantics()` | `suggest_semantics()` |
| Build a semantic review queue | `review_semantics()` | pending |
| Decide one review slot | `accept_suggestion()`, `reject_suggestion()` | pending |
| Write review decisions back | `apply_sdp_semantics()` | pending |
| Report required-but-unfilled metadata | `review_metadata()` | pending |
| Fill a free-text metadata field | `set_sdp_dataset()`, `set_sdp_table()`, `set_sdp_column()`, `set_sdp_code()` | pending |
| Detect unresolved gaps | `detect_semantic_term_gaps()` | `detect_semantic_term_gaps()` |
| Render request drafts | `render_ontology_term_request()` | `render_ontology_term_request()` |
| Validate during review | `validate_salmon_datapackage(..., require_iris = FALSE)` | `validate_salmon_datapackage(..., require_iris=False)` |
| Run the final publication gate | `validate_salmon_datapackage(..., require_iris = TRUE)` | `validate_salmon_datapackage(..., require_iris=True)` |
| Export validated EML | `write_eml_from_sdp()` | `write_eml_from_sdp()` (requires the `eml` extra) |
| Plan or run a KNB deposit | `publish_sdp_to_knb()` | `publish_sdp_to_knb()` (requires the `knb` extra) |

The two implementations are maintained at behavioral parity and normally release in lockstep. Their syntax remains idiomatic to each language; see the [metasalmonpy parity guide][metasalmonpy-parity] for deliberate differences. Install the **pinned** releases before the workshop — `metasalmon` v0.5.0 and `metasalmonpy` v0.4.0 — not the latest default branch; the Setup page has both commands and says why the numbers differ.

Rows marked *pending* are the R-native semantic review flow, which lands in `metasalmon` first. It is not a deliberate parity difference; the Python equivalent has not shipped yet. Python users decide the same slots by reading `semantic_suggestions.csv` and editing the target metadata field named by its `target_sdp_file` and `target_sdp_field` columns.

## Recommended project layout

```text
salmon-data-workshop/
  salmon-data-workshop.Rproj
  raw_data/       # unchanged input data, codebooks, and context files
  scripts/        # build_sdp.R or build_sdp.py for code-based lanes
  output/         # generated Salmon Data Packages
```

R users should open the `.Rproj` file. Keep the prepared dataset and all context inputs together under `raw_data/` and unchanged while the package is built. Every lane should work from the same project root and use paths relative to it. R and Python users put the reproducible build in `scripts/build_sdp.R` or `scripts/build_sdp.py`; spreadsheet users omit the script.

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

## Tidy shape and primary keys

An SDP describes data one column and one row at a time: `column_dictionary.csv` says what each column means, and `tables.csv` says what one row represents. That description only works if the table is actually shaped that way. Three rules, from the tidy data conventions:

1. **Each variable is a column.** If survey year is something you recorded, it is a `survey_year` column — not the *names* of several columns.
2. **Each observation is a row.** One row is one thing that happened: one stream in one year, one fish, one sample.
3. **Each table holds one kind of observation.** Stream-year counts and individual fish biosamples are two tables, not one.

Rule 3 is what makes the rest work: a primary key can only identify a row when every row is the same kind of thing, and a table-level `method_iri` only makes sense when the whole table was produced the same way.

Full worked examples, including the exact error text, are in the metasalmon [tidy data guide][metasalmon-tidy-data].

### `primary_key` is optional to declare and enforced once declared

`tables.csv$primary_key` holds the column, or comma-separated set of columns, whose values are unique within the table. Leaving it blank is allowed. **Declaring one that does not hold is a hard error** — validation fails rather than warning. Before metasalmon 0.2.6 nothing tested the field, so an older package can claim a key and still contain duplicate rows; the first strict validation after upgrading is where you find out.

| Failure | What validation reports | What it usually means |
| --- | --- | --- |
| The key repeats | `declares primary key '...' but N row(s) repeats it` | The key needs another column, or there are duplicate records to remove. Validation cannot tell you which. |
| The key contains blanks | `column <name> contains missing values` | A row with a blank key column has no identity. Checked separately from duplication, because two blanks are not literally equal and would otherwise slip through. |
| The key names a missing column | `primary_key references columns not present in data` | Usually a typo, or a column renamed in the data but not in the metadata. |

Choosing one is a matter of asking what one row *is*, then naming the columns that answer it:

| One row is... | `primary_key` |
| --- | --- |
| One stream in one year | `stream_id,survey_year` |
| One stream on one survey date | `stream_id,survey_date` |
| One individual fish | `sample_id` |
| One stream-year-species combination | `stream_id,survey_year,species_code` |

If you cannot name a unique set of columns, that is useful information: it usually means the table holds more than one kind of observation, and rule 3 applies.

### Column names that look like data values

The second shape check reads your **column names** and reports ones that look like data — a year per column, or a repeated stem with numeric tails. It is a **warning, never an error**: the package still builds, and validation still passes. It needs at least **three** matching columns, so an ordinary `x2`/`x3` pair is not flagged.

- **Year-like names**: `1998`, `2023`, `X2023` (R adds the `X` when repairing a name that starts with a digit).
- **A shared stem with numeric tails**: `count_1998`, `count_1999`, `count_2000`, or `pass1`, `pass2`, `pass3`.

It is a heuristic and can be wrong in both directions. A genuine `pass1` column in a three-pass electrofishing design will be flagged; a wide table with columns named `coho`, `chinook`, `sockeye` will not be. Read it as a prompt to look, not a verdict.

The wide shape is a problem for three concrete reasons: the dictionary gets one near-identical row per year column, `tables.csv` cannot say what one row is without ignoring the years spread sideways, and next year's data changes the *schema* rather than adding rows. Reshaping with `tidyr::pivot_longer()` fixes all three:

```r
long <- tidyr::pivot_longer(
  wide,
  cols = -stream_id,
  names_to = "survey_year",
  values_to = "spawner_count",
  names_transform = list(survey_year = as.integer)
)
```

`names_to` should be named after what those column names *are* (`survey_year`, not `name`). `names_transform` matters because column names are always text: without it you get `"2021"` as a string, and `value_type` in the dictionary would have to say `string`. In Python, the equivalent is `pandas.melt()` / `DataFrame.melt()` with `var_name` and `value_name`, followed by an explicit dtype cast.

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
| `publication/test/knb-manifest.json` | Exact-object manifest for the non-durable KNB Test Node rehearsal |
| `publication/knb-manifest.json` | Exact-object production dry-run or recovery manifest |

Use the [blank SDP CSV template][sdp-template] for a no-code starting point, or generate the current filled quickstart with `metasalmon` or `metasalmonpy` in Chapter 2.

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

The dictionary does not have a `method_iri` column or a `metadata/methods.csv` registry. A method lives where it is constant: `tables.csv$method_iri` for a whole-table procedure, `protocol_iri`/`protocol_citation` on `tables.csv` or `dataset.csv` for a citable document, or a code column resolving through `codes.csv$term_iri` when the method varies by row.

That is the shape since sdp-0.3.0. A package built before it may still carry a dictionary `method_iri` column, and the route forward is `migrate_sdp_methods(path)` — available in both implementations with the same signature, and with `dry_run = TRUE` / `dry_run=True` to see the proposed moves before writing anything. See the [migration guide][metasalmon-migration].

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

Not every semantic component is projected into EML. Both implementations conservatively annotate the whole measurement term and unit; they do not pretend that every I-ADOPT or method relationship has a direct EML equivalent.

## Rerun safety

| Command or state | Effect |
| --- | --- |
| `create_sdp(..., overwrite = FALSE)` | Fails if the output directory already exists; safest default. |
| `create_sdp(..., overwrite = TRUE)` | Re-infers and rewrites writer-owned package files. Manual edits to canonical metadata can be lost. |
| `create_sdp(..., overwrite = TRUE, prune = FALSE)` | Preserves non-owned sidecars, but still replaces owned metadata/data/descriptor outputs. |
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
- Strict validation passes.
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
