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

- R instructions use the latest `metasalmon` from the repository without a version pin. The *lesson build* is a separate matter: `renv/profiles/lesson-requirements/renv.lock` pins one released `metasalmon`, and that pin must be bumped whenever an episode starts teaching a newer function. `episodes/session-4.Rmd` writes a note to the build log when the pin is behind what it teaches.
- Python instructions use the latest `metasalmonpy` from the repository without a version pin.
- Spreadsheet instructions use the same canonical SDP CSV files and appear separately where no code is required.
- `metasalmon` and `metasalmonpy` are treated as behaviorally aligned implementations; deliberate language differences belong in the upstream parity guide.

## Current episode ladder

1. `episodes/session-1.Rmd`: introduce the salmon data integration system, its SDP and software components, shared and local semantic resources, bounded contexts, and the SDP-to-EML publication direction.
2. `episodes/session-2.Rmd`: run a prepared quickstart in the selected R, Python, or Spreadsheet lane and inspect the resulting package structure.
3. `episodes/session-3.Rmd`: bring learner-owned single-table, multi-CSV, or multi-sheet Excel inputs into a reproducible R or Python build script, declare context inputs, seed semantic candidates, and encode accepted review decisions for reruns.
4. `episodes/session-4.Rmd`: use the shared NuSEDS Fraser Coho example to run metasalmon's R-native semantic review — `review_semantics()` prints the decision call, the learner pastes it into the build script, and `apply_sdp_semantics()` writes it — covering one measurement IRI, one I-ADOPT decomposition, one unit, one statistical modifier, one table observation-unit IRI, and one deliberate rejection, with optional bundle-aware LLM review named as a separate opt-in.
5. `episodes/session-5.Rmd`: code lists, SKOS, and local vocabulary.
6. `episodes/session-6.Rmd`: render SMN, GCDFO, profile, or skip routes; write validated EML; preview KNB publication; and create a later version without discarding reviewed metadata.
7. `episodes/bonus-session.Rmd`: optional concept mapping extension.

## Styling and presentation

- **Canonical styling system:** author semantic Markdown in Sandpaper and use the global CSS and Bootstrap design tokens supplied by the Varnish theme. Sandpaper's native `group-tab` fenced div is the canonical control for synchronized R, Python, and Spreadsheet alternatives.
- **Style entry pattern:** inside every `group-tab`, use third-level headings in the consistent order `### R`, `### Python`, and `### Spreadsheet`. Sandpaper preserves that heading level and Varnish's existing `h3.tab-header` rule supplies the smaller responsive label size. A tab group shows one software lane at a time.
- **Subsections inside tabs:** Sandpaper converts every Markdown heading inside a `group-tab` into another tab button. Use an ordinary Markdown span with the theme's Bootstrap heading and display classes plus an accessible heading role (for example, `[Subsection]{.h4 .d-block role="heading" aria-level="4"}`) for a visually prominent subsection that must remain inside one software lane.
- **Tokens:** this repository defines no custom design tokens. Colors, spacing, typography, responsive breakpoints, and tab behavior come from Varnish/Bootstrap. Theme assets under `site/docs/assets/` are generated build output and must not be edited.
- **Inline-style policy:** do not add inline CSS, page-local `<style>` elements, template overrides, or parallel JavaScript for language selection. Prefer supported Sandpaper structure and existing Varnish rules; introduce a repository-wide stylesheet only if a future requirement cannot be expressed through those native patterns.
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
