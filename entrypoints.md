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

## Current episode ladder

1. `episodes/session-1.Rmd`: why start with an SDP and what ontology/vocabulary language means in plain terms.
2. `episodes/session-2.Rmd`: create a draft package with the primary R workflow, a Python companion, or the blank CSV template.
3. `episodes/session-3.Rmd`: create an RStudio Project, use shared R/Python relative paths for learner-owned files, and capture context.
4. `episodes/session-4.Rmd`: generate and review deterministic suggestions in R or Python, with optional bundle-aware LLM review.
5. `episodes/session-5.Rmd`: code lists, SKOS, and local vocabulary.
6. `episodes/session-6.Rmd`: render SMN, GCDFO, profile, or skip routes and plan publication.
7. `episodes/bonus-session.Rmd`: optional concept mapping extension.

## Upstream workflow sources

- `metasalmon`: <https://github.com/salmon-data-mobilization/metasalmon>
- `salmonpy` repository (`metaSmnPy`): <https://github.com/salmon-data-mobilization/metaSmnPy>
- R/Python parity contract: <https://salmon-data-mobilization.github.io/metaSmnPy/guides/parity.html>
- Salmon Data Package specification: <https://github.com/salmon-data-mobilization/smn-data-pkg/blob/main/SPECIFICATION.md>
- Blank SDP CSV template: <https://github.com/salmon-data-mobilization/smn-data-pkg/tree/main/templates/salmon-data-package-template>

## Local checks

Use the repo's Sandpaper workflow when R dependencies are available:

```r
sandpaper::check_lesson()
sandpaper::build_lesson()
```

The lesson is documentation-only. It does not run a local app server.
