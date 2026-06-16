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

request_plan <- gaps |>
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
    placement_recommendation,
    placement_confidence
  )
```

The output is a working list, not an automatic governance decision.

## Routing decision

Use this plain-language triage:

| Route | Use when |
| --- | --- |
| Shared `smn:` request | reusable salmon science concept, stable across organizations |
| GCDFO or DFO-specific request | DFO policy, operations, data stewardship, or program-specific concept |
| Local/profile vocabulary or ontology | local code list, project method bin, status category, formal local structure, or uncertain reuse |
| Defer | description is enough for now, or evidence is too weak |

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
- canonical metadata headers have no extra columns;
- measurement rows have final `term_iri`, `property_iri`, `entity_iri`, and `unit_iri`;
- term requests or local/profile decisions are documented.

Deferred measurement gaps are valid in draft or review state. They will not pass strict publication validation until the required measurement semantic fields are resolved.

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Draft a term-gap plan

Choose one unresolved field or code value.

Decide:

- route: shared `smn:`, GCDFO/DFO-specific, local/profile, or defer;
- proposed label and definition;
- evidence source;
- why existing terms do not fit;
- next action.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Missing terms are governance work, not a reason to force bad mappings.
- High-quality requests carry definitions, sources, examples, and routing rationale.
- Strict validation is a publication-readiness check, not the first review step.

::::::::::::::::::::::::::::::::::::::::::::::::
