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

1. `episodes/session-1.Rmd`: why start with an SDP.
2. `episodes/session-2.Rmd`: create a draft package from the blank CSV template or with `metasalmon`.
3. `episodes/session-3.Rmd`: capture context.
4. `episodes/session-4.Rmd`: generate and review deterministic suggestions, with optional bundle-aware LLM review.
5. `episodes/session-5.Rmd`: code lists, SKOS, and local vocabulary.
6. `episodes/session-6.Rmd`: render SMN, GCDFO, profile, or skip routes and plan publication.
7. `episodes/bonus-session.Rmd`: optional concept mapping extension.

## Upstream workflow sources

- `metasalmon`: <https://github.com/salmon-data-mobilization/metasalmon>
- Salmon Data Package specification: <https://github.com/salmon-data-mobilization/smn-data-pkg/blob/main/SPECIFICATION.md>
- Blank SDP CSV template: <https://github.com/salmon-data-mobilization/smn-data-pkg/tree/main/templates/salmon-data-package-template>
- Optional Git/GitHub/RStudio setup: <https://happygitwithr.com/>

## Local checks

Use the repo's Sandpaper workflow when R dependencies are available:

```r
sandpaper::check_lesson()
sandpaper::build_lesson()
```

The lesson is documentation-only. It does not run a local app server.
