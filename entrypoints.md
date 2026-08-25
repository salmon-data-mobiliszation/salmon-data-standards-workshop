---
title: Entrypoints
---

# Entrypoints

This repository is a Carpentries/Sandpaper lesson for the Salmon Data Standards Workshop.

## Main lesson surfaces

- `config.yaml`: lesson title, navigation, and visible episode order.
- `index.md`: site landing text.
- `README.md`: repository overview and current workshop promise.
- `episodes/`: learner-facing sessions.
- `learners/setup.md`: setup and prerequisite guidance.
- `learners/reference.md`: glossary and decision aids.
- `instructors/instructor-notes.md`: one-hour and full-day delivery notes.
- `profiles/learner-profiles.md`: target learner personas.

## Software lanes

- R instructions use the latest `metasalmon` from the repository without a version pin.
- Python instructions use the latest `metasalmonpy` from the repository without a version pin.
- Spreadsheet instructions use the same canonical SDP CSV files and appear separately where no code is required.
- `metasalmon` and `metasalmonpy` are treated as behaviorally aligned implementations; deliberate language differences belong in the upstream parity guide.

## Current episode ladder

1. `episodes/session-1.Rmd`: introduce the salmon data integration system, its SDP and software components, shared and local semantic resources, bounded contexts, and the SDP-to-EML publication direction.
2. `episodes/session-2.Rmd`: run a prepared quickstart in the selected R, Python, or Spreadsheet lane and inspect the resulting package structure.
3. `episodes/session-3.Rmd`: bring learner-owned single-table, multi-CSV, or multi-sheet Excel inputs into the same lanes, capture context, and protect reviewed work during reruns.
4. `episodes/session-4.Rmd`: generate and review deterministic suggestions in R or Python, with optional bundle-aware LLM review.
5. `episodes/session-5.Rmd`: code lists, SKOS, and local vocabulary.
6. `episodes/session-6.Rmd`: render SMN, GCDFO, profile, or skip routes; write validated EML; preview KNB publication; and create a later version without discarding reviewed metadata.
7. `episodes/bonus-session.Rmd`: optional concept mapping extension.

## Presentation behavior

- Sandpaper's native `group-tab` fenced div is the canonical control for synchronized R, Python, and Spreadsheet alternatives.
- A tab group shows one software lane at a time; use the same tab labels and order wherever those alternatives recur.
- Site presentation comes from the repository's Sandpaper/Varnish theme. Do not add a parallel CSS or JavaScript system for language selection.
- Edit learner source under `episodes/`, `learners/`, and `index.md`; never hand-edit generated files under `site/`.

## Upstream workflow sources

- `metasalmon`: <https://github.com/salmon-data-mobilization/metasalmon>
- `metasalmonpy` repository: <https://github.com/salmon-data-mobilization/metasalmonpy>
- R/Python parity contract: <https://salmon-data-mobilization.github.io/metasalmonpy/guides/parity.html>
- Salmon Data Package specification: <https://github.com/salmon-data-mobilization/smn-data-pkg/blob/main/SPECIFICATION.md>
- Blank SDP CSV template: <https://github.com/salmon-data-mobilization/smn-data-pkg/tree/main/templates/salmon-data-package-template>
- SDP field reference: <https://github.com/salmon-data-mobilization/smn-data-pkg/blob/main/docs/field-reference.md>
- metasalmon post-review, EML, and KNB workflow: <https://github.com/salmon-data-mobilization/metasalmon/blob/main/vignettes/post-review-package-publication.Rmd>

## Local checks

Use the repo's Sandpaper workflow when R dependencies are available:

```r
sandpaper::check_lesson()
sandpaper::build_lesson()
```

The lesson is documentation-only. It does not run a local app server.
