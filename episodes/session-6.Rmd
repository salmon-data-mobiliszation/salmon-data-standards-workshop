---
title: "Route Term Gaps and Plan Publication"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- What should I do when no existing term fits?
- What information makes a new-term request useful?
- How do review-state and publication-state validation differ?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Turn unresolved mappings into a term-gap plan.
- Route candidate terms to shared, DFO-specific, or local/profile governance.
- Describe the final validation and publication-readiness checks.

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

::::::::::::::::::::::::::::::::::::: keypoints

- Missing terms are governance work, not a reason to force bad mappings.
- High-quality requests carry definitions, sources, examples, and routing rationale.
- Rendering produces reviewable SMN, GCDFO, or profile request drafts; it does not submit them.
- Strict validation is a publication-readiness check, not the first review step.

::::::::::::::::::::::::::::::::::::::::::::::::
