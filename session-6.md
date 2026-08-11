---
title: "Route Term Gaps, Export EML, and Plan Catalog Publication"
teaching: 80
exercises: 55
---

:::::::::::::::::::::::::::::::::::::: questions

- What should I do when no existing term fits?
- What information makes a new-term request useful?
- How do review-state and publication-state validation differ?
- How do reviewed SDP fields become a valid EML file?
- How can I preview or perform a guarded KNB catalog upload?
- How should I create a later package version without discarding reviewed metadata?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Turn unresolved mappings into a term-gap plan.
- Route candidate terms to shared, DFO-specific, or local/profile governance.
- Run the strict SDP validation gate before export.
- Complete the SDP-to-EML handoff and write validated EML 2.2.
- Preview an exact KNB/DataONE deposit and distinguish a dry run from a persistent live upload.
- Write an intentional new package version from reviewed metadata.

::::::::::::::::::::::::::::::::::::::::::::::::

## A gap is not a failure

When no candidate term fits, do not force the closest match. Record the gap and decide where it belongs.

The package should keep enough evidence that maintainers can understand the request without a long follow-up interview.

## Post-review workflow in R

After editing the metadata files, reload and validate the current package state.

```r
pkg <- read_salmon_datapackage(pkg_path)
validate_salmon_datapackage(pkg_path, require_iris = FALSE)
```

Then rerun suggestions only for unresolved pieces.

```r
reviewed_dict <- suggest_semantics(
  df = pkg$resources,
  dict = pkg$dictionary,
  codes = pkg$codes,
  table_meta = pkg$tables,
  dataset_meta = pkg$dataset
)

gaps <- detect_semantic_term_gaps(reviewed_dict)

if (nrow(gaps) == 0) {
  message("No unresolved term gaps; there is no request plan to render.")
  requests <- tibble::tibble()
  request_plan <- tibble::tibble()
} else {
  requests <- render_ontology_term_request(
    gaps,
    scope = "auto",
    ask = FALSE,
    profile_name = "local-program"
  )

  reviewed_scopes <- requests$request_scope
  # Review every value. For example, route a DFO-specific row explicitly:
  # reviewed_scopes[2] <- "gcdfo"

  requests <- render_ontology_term_request(
    gaps,
    scope = "auto",
    ask = FALSE,
    profile_name = "local-program",
    scope_overrides = reviewed_scopes
  ) |>
    dplyr::mutate(
      ontology_repo = dplyr::if_else(
        request_scope %in% c("smn", "gcdfo"),
        ontology_repo,
        NA_character_
      )
    )

  request_plan <- requests |>
    dplyr::select(
      dataset_id,
      table_id,
      target_scope,
      target_row_key,
      target_sdp_field,
      dictionary_role,
      search_query,
      top_non_smn_label,
      top_non_smn_source,
      gap_detection_basis,
      llm_new_term_namespace,
      llm_escalated_from,
      placement_recommendation,
      placement_confidence,
      request_scope,
      ontology_repo
    )

  request_plan
  readr::write_csv(request_plan, file.path(pkg_path, "term-request-plan.csv"))
}
```

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

```python
from pathlib import Path

import pandas as pd
from salmonpy import (
    detect_semantic_term_gaps,
    read_salmon_datapackage,
    render_ontology_term_request,
    suggest_semantics,
    validate_salmon_datapackage,
)

pkg = read_salmon_datapackage(pkg_path)
validate_salmon_datapackage(pkg_path, require_iris=False)

reviewed_dict = suggest_semantics(
    df=pkg["resources"],
    dict_df=pkg["dictionary"],
    codes=pkg["codes"],
    table_meta=pkg["tables"],
    dataset_meta=pkg["dataset"],
)

gaps = detect_semantic_term_gaps(reviewed_dict)

if gaps.empty:
    print("No unresolved term gaps; there is no request plan to render.")
    requests = pd.DataFrame()
    request_plan = pd.DataFrame()
else:
    requests = render_ontology_term_request(
        gaps,
        scope="auto",
        ask=False,
        profile_name="local-program",
    )

    reviewed_scopes = requests["request_scope"].tolist()
    # Review every value. For example, route a DFO-specific row explicitly:
    # reviewed_scopes[1] = "gcdfo"

    requests = render_ontology_term_request(
        gaps,
        scope="auto",
        ask=False,
        profile_name="local-program",
        scope_overrides=reviewed_scopes,
    )

    non_repository_rows = ~requests["request_scope"].isin(
        ["smn", "gcdfo"]
    )
    requests.loc[non_repository_rows, "ontology_repo"] = pd.NA

    request_columns = [
        "dataset_id",
        "table_id",
        "target_scope",
        "target_row_key",
        "target_sdp_field",
        "dictionary_role",
        "search_query",
        "top_non_smn_label",
        "top_non_smn_source",
        "gap_detection_basis",
        "llm_new_term_namespace",
        "llm_escalated_from",
        "placement_recommendation",
        "placement_confidence",
        "request_scope",
        "ontology_repo",
    ]

    request_plan = requests.loc[:, request_columns]
    print(request_plan)
    request_plan.to_csv(
        Path(pkg_path) / "term-request-plan.csv",
        index=False,
    )
```

::::::::::::::::::::::::::::::::::::::::::::::::

`detect_semantic_term_gaps()` combines deterministic candidate gaps with final LLM `request_new_term` decisions when LLM assessment was enabled. `gap_detection_basis` records which evidence created the gap, and `llm_escalated_from` preserves an unresolved `reject_shortlist` escalation. The deterministic `suggest_semantics()` call shown above leaves those LLM fields blank.

`render_ontology_term_request()` converts the gaps into reviewable draft payloads and proposed routes. It never submits an issue. The output is a working list, not an automatic governance decision.

To preview the SMN and GCDFO issue bodies without posting anything:

```r
issue_preview <- if (nrow(requests) == 0) {
  tibble::tibble()
} else {
  requests |>
    dplyr::filter(request_scope %in% c("smn", "gcdfo")) |>
    submit_term_request_issues(dry_run = TRUE)
}

issue_preview
```

::::::::::::::::::::::::::::::::::::: callout

## Python equivalent

```python
from salmonpy import submit_term_request_issues

if requests.empty:
    issue_preview = pd.DataFrame()
else:
    routable = requests.loc[
        requests["request_scope"].isin(["smn", "gcdfo"])
    ]
    issue_preview = (
        submit_term_request_issues(routable, dry_run=True)
        if not routable.empty
        else pd.DataFrame()
    )

print(issue_preview)
```

::::::::::::::::::::::::::::::::::::::::::::::::

## Routing decision

Use this plain-language triage:

| Route | Use when |
| --- | --- |
| `smn` | reusable salmon science concept, stable across organizations |
| `gcdfo` | DFO policy, operations, data stewardship, or DFO-specific concept |
| `profile` | local code list, project method bin, status category, formal local structure, or uncertain reuse |
| `skip` or defer | description is enough for now, or evidence is too weak |

Treat any LLM namespace suggestion as evidence, not authority. Review `request_scope` row by row before filing or publishing anything.

## Useful term-request ingredients

A useful request includes:

- proposed label;
- one or two sentence definition;
- source of the definition;
- example values or rows;
- where the term might sit in a hierarchy or concept scheme;
- related terms that were close but not exact;
- whether the term is shared, DFO-specific, or local/profile;
- any mapping strength you believe is appropriate.

## Final validation is later

Strict validation is the final gate.

```r
validate_salmon_datapackage(pkg_path, require_iris = TRUE)
```

Python can run a useful companion check:

```python
validate_salmon_datapackage(pkg_path, require_iris=True)
```

For publication, run the current R `metasalmon` strict validator shown first. `salmonpy` 0.1.6 provides a useful companion check for the core package, but it is not version-aligned with R/`metasalmon` 0.2.3 and does not enforce the full EML/KNB publication contract.

Run it only when:

- review markers such as `REVIEW:` have been resolved;
- required metadata placeholders are gone;
- canonical metadata headers exactly match the schema fields, in schema order, with no missing or extra columns;
- every `tables.csv$file_name` is a safe relative path to an existing data file;
- `column_dictionary.csv` rows and column names match the headers of the referenced data files;
- every observed non-empty categorical value has exactly one matching `codes.csv` row for its dataset/table/column/value key;
- measurement rows have final `term_iri`, `property_iri`, `entity_iri`, and `unit_iri`;
- `datapackage.json` exists, declares the SDP profile and resources, and agrees with the canonical metadata CSVs and referenced data files;
- term requests or local/profile decisions are documented.

Deferred measurement gaps are valid in draft or review state. They will not pass strict publication validation until the required measurement semantic fields are resolved.

## Map the reviewed SDP into EML

`metasalmon` does not simply rename SDP fields. It builds a new EML document and validates the result:

| Reviewed SDP source | EML output |
| --- | --- |
| Dataset ID, title, description, keywords, temporal coverage | Alternate identifier, title, abstract, keyword set, and temporal coverage |
| Each table row and referenced data CSV | One EML `dataTable` with an identified physical object |
| Column name, label, description, and `value_type` | Attribute name, label, definition, and storage type |
| `required = TRUE` and table primary keys | Not-null and primary-key constraints |
| Categorical `codes.csv` rows | Enumerated-domain code definitions |
| Reviewed measurement term and unit IRIs | Conservative semantic annotations |
| Reviewed EML sidecar | Parties, rights, methods, measurement scales, missing values, geographic/taxonomic coverage, provenance, and access intent |

The canonical SDP does not contain every fact EML requires. For example, a free-text `creator` cell cannot safely be guessed into structured people, organizations, ORCIDs, and metadata-provider roles. Measurement scale and the meanings of missing-value tokens also need explicit review.

## Export validated EML 2.2

Install `emld` and `jsonvalidate`, then copy the package's sidecar template once:


``` r
eml_mapping_path <- file.path(
  pkg_path,
  "metadata",
  "eml-mapping.yml"
)
```

``` error
Error:
! object 'pkg_path' not found
```

``` r
if (!file.exists(eml_mapping_path)) {
  file.copy(
    system.file(
      "extdata",
      "eml-mapping-template.yml",
      package = "metasalmon"
    ),
    eml_mapping_path
  )
}
```

``` error
Error:
! object 'eml_mapping_path' not found
```

Stop and review the copied YAML. Replace every example value. The sidecar must bind the final semantic vocabulary and reviewed-selection ledger with their SHA-256 checksums; it must also record reviewed parties, rights authorization, source provenance, methods, and one measurement-scale/domain entry for every column. Set `status: final` only after that review.

The detailed, current checklist is in the [metasalmon post-review and publication workflow][metasalmon-eml-workflow]. Do not invent dummy parties, checksums, rights evidence, measurement scales, or missing-value meanings merely to make validation pass.

When the SDP, its semantic-review evidence, and the sidecar are final:


``` r
eml_result <- write_eml_from_sdp(pkg_path)
```

``` error
Error in `write_eml_from_sdp()`:
! could not find function "write_eml_from_sdp"
```

``` r
eml_result$path
```

``` error
Error:
! object 'eml_result' not found
```

``` r
eml_result$eml_version
```

``` error
Error:
! object 'eml_result' not found
```

``` r
eml_result$validation
```

``` error
Error:
! object 'eml_result' not found
```

The default output is `metadata/eml.xml`. An identical existing file is an idempotent success. A different existing file is protected unless you deliberately pass `overwrite = TRUE` after reviewing why the bytes changed.

## Preview the KNB/DataONE catalog deposit

Use a dry run first. It creates local EML, OAI-ORE, and manifest artifacts, but it does not read credentials or make a network request:


``` r
knb_plan <- publish_sdp_to_knb(
  pkg_path,
  public = FALSE,
  dry_run = TRUE,
  representation = "expanded",
  overwrite = FALSE
)
```

``` error
Error in `publish_sdp_to_knb()`:
! could not find function "publish_sdp_to_knb"
```

``` r
knb_plan$status
```

``` error
Error:
! object 'knb_plan' not found
```

``` r
knb_plan$manifest_path
```

``` error
Error:
! object 'knb_plan' not found
```

Review `publication/knb-manifest.json`. The expanded plan lists the original data resources, allowlisted canonical SDP artifacts, validated EML science metadata, and the OAI-ORE resource map with exact identifiers and checksums. It does not scan and upload arbitrary files from the package folder.

In `metasalmon` 0.2.3 or later, `overwrite = TRUE` can rebuild conflicting artifacts left by an **unpublished dry run** after you correct an input. It cannot overwrite anything that reached DataONE; published PIDs are immutable and require a reviewed revision.

## Live upload is a separate authorized action

A live call creates persistent production KNB objects even when `public = FALSE`. Private access is a review posture, not a server-side draft. The call requires:

- the exact pre-existing dry-run plan;
- a short-lived DataONE JWT entered only into the current R process;
- an authenticated subject matching the reviewed EML metadata provider;
- `confirm = TRUE`; and
- authority for the chosen access and redistribution decision.


``` r
previous_token <- getOption("dataone_token")

options(
  dataone_token = rstudioapi::askForPassword(
    "Short-lived DataONE JWT"
  )
)
```

``` error
Error:
! RStudio not running
```

``` r
tryCatch(
  publish_sdp_to_knb(
    pkg_path,
    public = FALSE,
    dry_run = FALSE,
    confirm = TRUE,
    representation = "expanded"
  ),
  finally = options(dataone_token = previous_token)
)
```

``` error
Error in `publish_sdp_to_knb()`:
! could not find function "publish_sdp_to_knb"
```

Do not place the token in a script, `.Renviron`, YAML, manifest, command argument, or shell history. Do not switch to `public = TRUE` merely for convenience: public access is a separate redistribution decision and requests DataONE preservation replicas.

Publication is complete only when the intended catalog state is verified, not merely when KNB stores the objects. If the returned manifest says `published_pending_catalog`, preserve that exact status and recheck rather than creating replacement identifiers or claiming completion.

## Later example: make a new version after review

After people have edited package metadata over time, do not regenerate the same folder from raw data and hope the edits survive. Read the reviewed state, make deliberate changes in memory, and write a new versioned folder:

```r
reviewed_pkg <- read_salmon_datapackage(pkg_path)

# Example of an intentional metadata update. Replace with the real reviewed text.
reviewed_pkg$dataset <- reviewed_pkg$dataset |>
  dplyr::mutate(
    description = paste(
      description,
      "This version adds the reviewed 2026 return-year records."
    )
  )

v2_path <- file.path("output", "my-salmon-sdp-v2")

write_salmon_datapackage(
  resources = reviewed_pkg$resources,
  dataset_meta = reviewed_pkg$dataset,
  table_meta = reviewed_pkg$tables,
  dict = reviewed_pkg$dictionary,
  codes = reviewed_pkg$codes,
  path = v2_path,
  overwrite = FALSE
)

validate_salmon_datapackage(
  v2_path,
  require_iris = TRUE
)
```

If data columns changed, update the dictionary. If new categorical values appeared, update `codes.csv`. Rebuild and review version-specific semantic, EML, and publication artifacts; do not blindly copy old checksum-bound sidecars.

For a later KNB version, keep the earlier package and verified manifest unchanged, add a new reviewed `publication.revision_key` to the new version's EML sidecar, and plan against the preceding `revision_manifest`. This creates an immutable revision rather than overwriting published bytes.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Draft a term-gap plan

Choose one unresolved field or code value.

Decide:

- route: `smn`, `gcdfo`, `profile`, or `skip`/defer;
- proposed label and definition;
- evidence source;
- why existing terms do not fit;
- next action.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 2: Trace the publication handoff

Using a finalized instructor-provided package or your own package when it is ready:

1. identify three SDP fields and their EML destinations;
2. identify two facts that must come from `eml-mapping.yml` rather than inference;
3. run or inspect the result of `write_eml_from_sdp()`;
4. run or inspect a credential-free KNB dry-run manifest; and
5. state who would need to authorize a live upload and whether the intended access is private or public.

Do not run a live upload as a classroom experiment.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Missing terms are governance work, not a reason to force bad mappings.
- High-quality requests carry definitions, sources, examples, and routing rationale.
- Rendering produces reviewable SMN, GCDFO, or profile request drafts; it does not submit them.
- Strict validation is a publication-readiness check, not the first review step.
- EML export is a validated transformation that also requires reviewed sidecar facts.
- A KNB dry run is local and reversible; a live call creates persistent production objects.
- Later package and catalog versions should be explicit immutable revisions, not overwrite attempts.

::::::::::::::::::::::::::::::::::::::::::::::::
