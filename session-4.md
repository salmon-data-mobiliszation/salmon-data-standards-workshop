---
title: "Review Terms and Measurement Meanings"
teaching: 55
exercises: 40
---

:::::::::::::::::::::::::::::::::::::: questions

- Where does the record of a semantic decision live?
- How do we keep semantic review small enough to finish in the workshop?
- How do I decide whether a suggested IRI is good enough to keep?
- What does I-ADOPT clarify for measurement columns?
- What can this review *not* decide for me?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Build a review queue from the suggestions your package already carries, without running a new search.
- Read one slot's shortlist and decide it with a call you paste into `scripts/build_sdp.R`.
- Decompose one measurement once using the SDP's I-ADOPT fields.
- Write the decisions back with `apply_sdp_semantics()` and confirm the data files did not change.
- Name the decisions this review cannot reach, and say where they are still made.

::::::::::::::::::::::::::::::::::::::::::::::::



## The decision that used to leave no record

By the end of Session 3 your package was reproducible almost everywhere. `raw_data/` holds unchanged inputs, `scripts/build_sdp.R` turns them into a package, and rerunning the script rebuilds the same bytes.

Almost everywhere. Until now, the documented way to accept a semantic link was to open `metadata/column_dictionary.csv` in a spreadsheet, read `semantic_suggestions.csv` beside it, and copy an IRI across by hand. That worked. But the only record it left was the changed cell. Six months later the cell says *what* was decided and nothing at all about *why*, *by whom*, or *what else was on the shortlist*. It was the one unreproducible link in a chain that is otherwise byte-for-byte reproducible.

This chapter replaces that step. `review_semantics()` prints a shortlist and, under every candidate, the exact line of R that accepts it:

```output
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 1)
```

You paste that line into `scripts/build_sdp.R`. **The paste is the audit trail.** There is no prompt, no menu, and no interactive review screen, and that is a design decision rather than an omission: anything you answer at a prompt vanishes when the session ends, which would leave the decision exactly as unreproducible as the spreadsheet it replaces.

A learner who understands why the spreadsheet was abandoned will not drift back to it. The spreadsheet lane still exists below, because a mixed workshop needs it — but it is now the lane that costs you the record, and this chapter says so plainly.

Be precise about the size of the claim. **This chapter's flow decides semantic IRIs, and it is not the whole package.** Free-text fields — descriptions, contacts, licences — are outside it, and a slot that retrieval found nothing for never reaches this queue at all. Neither of those is a spreadsheet job any more: `review_metadata()` and the `set_sdp_*()` setters, which shipped in the same release, close both, and the section [What this review cannot decide](#what-this-review-cannot-decide) is where they are named. That section is not a disclaimer at the end; it is half the lesson. A learner who leaves believing *this queue* finishes the package will be corrected by the validator, and will trust the tool less than it deserves.

::::::::::::::::::::::::::::::::::::: prereq

## You need metasalmon 0.5.0 or newer

The review flow shipped in **metasalmon 0.5.0**. Check before you start, and reinstall the pinned tag from the Setup page if the answer is older:


``` r
packageVersion("metasalmon")
```

An earlier metasalmon loads without complaint and then has none of the functions this chapter uses. The [changelog][metasalmon-changelog] has the 0.5.0 entry.

::::::::::::::::::::::::::::::::::::::::::::::::

## Keep the workshop semantic review bounded

We will not try to map every column. Everyone will use the NuSEDS Fraser Coho escapement package from Session 2, even if you are also building a package from your own data. That gives the room one case to discuss and keeps the decisions small enough to finish.

We will decide exactly these linked slots:

| Decision | SDP destination | Shared Fraser Coho slot |
| --- | --- | --- |
| One complete measurement variable | `column_dictionary.csv$term_iri` | `NATURAL_SPAWNERS_TOTAL` |
| One I-ADOPT decomposition | `property_iri`, `entity_iri`, `constraint_iri` on that same row | abundance, of a population, natural-origin |
| One unit | `column_dictionary.csv$unit_iri` | a count |
| One statistical modifier | `column_dictionary.csv$statistical_modifier_iri` | a total |
| What each table row represents | `tables.csv$observation_unit_iri` | an escapement |
| One deliberate rejection | any slot | `AREA` |

Administrative IDs, file names, local notes, and the other categorical code lists can rely on clear descriptions for now and be mapped in a later review.

## Your package must already carry suggestions

`review_semantics()` **never searches and never contacts a network or an LLM.** It reads the suggestions your package already has. That is why Session 3 turned `seed_semantics = TRUE` on: without it there is nothing to review, and the function says so rather than quietly returning an empty queue.

```output
Error in review_semantics(pkg_path) : No semantic suggestions to review.
ℹ Run `suggest_semantics()`, or `create_sdp()` with `seed_semantics = TRUE`,
  first.
```

If the Session 2 package was built with `seed_semantics = FALSE`, rebuild it once with seeding on before continuing. Expect the search itself to take a few minutes; that cost is paid once, at build time, and never again during review.

## Build the review queue

::::::::::::::::::::::::::::::::::::: group-tab

### R


``` r
library(metasalmon)

pkg_path <- file.path("output", "fraser-coho-example-sdp")

# One row per candidate; one queue entry per undecided slot. No search runs.
review <- review_semantics(pkg_path)

review
```

To work through one column at a time, filter the queue:


``` r
review <- review_semantics(pkg_path, columns = "NATURAL_SPAWNERS_TOTAL")
```

### Python

**There is no Python equivalent.** Not a partial one, not a differently-spelled one: `metasalmonpy` has no review queue, no accessor for the suggestions attribute, and no function that reads `semantic_suggestions.csv` back. The R-native review flow lands in `metasalmon` first, and the port has not been written. This is a gap, not a deliberate parity difference, so do not go looking for it in the [parity guide][metasalmonpy-parity].

This is also why the Setup page pins the two lanes to different releases: metasalmon `v0.5.0` is the release this chapter teaches, and metasalmonpy's newest is `v0.4.0`. Pinning both makes the lesson reproducible; only the port will make it equivalent.

What a Python user can do today is read the same evidence the R queue is built from, with pandas rather than with `metasalmonpy`. `semantic_suggestions.csv` sits at the package root and is written by both implementations:

```python
from pathlib import Path

import pandas as pd

pkg_path = Path("output") / "fraser-coho-example-sdp"

suggestions = pd.read_csv(pkg_path / "semantic_suggestions.csv")

print(
    suggestions[
        [
            "column_name",
            "dictionary_role",
            "target_sdp_file",
            "target_sdp_field",
            "label",
            "iri",
            "source",
            "score",
        ]
    ]
)
```

Decide from that table, then edit the target field in the canonical metadata CSV. Record each decision in `scripts/build_sdp.py` as a comment or an explicit assignment, so the reasoning survives the way the pasted R call does. Until the Python review flow ships, that discipline is manual rather than enforced.

### Spreadsheet

Open `semantic_suggestions.csv` at the package root beside `metadata/column_dictionary.csv`. Filter to `NATURAL_SPAWNERS_TOTAL` and to the `tables.csv` row whose `target_sdp_field` is `observation_unit_iri`. Compare each `label`, `iri`, and `definition` with the source documentation and the data holder's explanation, then write the accepted IRI into the target field named by `target_sdp_file` and `target_sdp_field`.

Be clear about the cost. This lane records the *outcome* and not the *reasoning*: nothing in the saved file says which other candidates you saw, or why you preferred this one. Keep a written review log beside the package so the next reader is not guessing. Opening the CSV does not accept a suggestion and is not evidence that a link is correct.

::::::::::::::::::::::::::::::::::::::::::::::::

## Read one slot

Each queue entry is one block. This is the `NATURAL_SPAWNERS_TOTAL` variable slot — the first block you see after filtering with `columns =` — printed exactly as it appears:

```output
── escapement · NATURAL_SPAWNERS_TOTAL · variable ────────────────────────────
   field:   column_dictionary.csv · term_iri
   current: REVIEW: https://w3id.org/gcdfo/salmon#SpawnerAbundance

   [1] Spawner abundance   gcdfo   score 18.25
       The abundance (count) of adult salmon that reach spawning grounds in a
       given system and time period (often operationalized as
       escapement/spawning escapement).
       https://w3id.org/gcdfo/salmon#SpawnerAbundance
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 1)

       review <- reject_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable")   # no candidate fits
```

Read it in this order:

- **the heading** — table, column, and semantic role;
- **`field:`** — the exact file and column this decision writes into, so you can check the result yourself;
- **`current:`** — what the field holds *now*;
- **the shortlist** — `[1]`, `[2]`, … in the order the ranked search produced, each with its label, source vocabulary, score, definition, and IRI; and
- **the calls** — one per candidate, plus one rejection.

`current:` has three states, and the difference matters.

| `current:` shows | What it means |
| --- | --- |
| `REVIEW: <iri>` | Seeding wrote a draft, because its unattended compatibility check passed. Still undecided. |
| `<blank>` | Seeding found a candidate but declined to draft it. Still undecided, and the queue shows it for exactly that reason. |
| `<unknown>` | The queue could not read the current value — the metadata row was missing or matched ambiguously. Read the CSV before deciding. |

Undecided is undecided. A `REVIEW:` prefix is a marker meaning *nobody has looked at this*, not a weak endorsement, and strict validation refuses to publish a package that still contains one.

The variable answers "what complete measurement is this column?" For `NATURAL_SPAWNERS_TOTAL` the candidate says spawner abundance, from `gcdfo`, with a definition that matches the NuSEDS field. Read the definition, not the label. Then accept it.

## Decide, in your script

`accept_suggestion()` and `reject_suggestion()` take a review and return a review. Nothing is written to disk until you say so, so a whole review is an ordinary re-runnable R script.

::::::::::::::::::::::::::::::::::::: group-tab

### R


``` r
review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 1)
```

Reject when nothing on the shortlist fits, and say why:


``` r
review <- reject_suggestion(
  review,
  "AREA",
  "variable",
  reason = "DFO statistical area, not a body of water"
)
```

`reason` is carried on the review object, shown in the console, **and written to disk** — `semantic_suggestions.csv` has a `decision_reason` column beside `decision`, so the sentence travels with the package rather than only with your project folder. Write it for a reader who has neither your script nor you: it is the one field that says why a slot is deliberately empty rather than merely unfinished.

Accept a term the search did not surface by naming it directly instead of a rank:


``` r
review <- accept_suggestion(
  review,
  "NATURAL_SPAWNERS_TOTAL",
  "property",
  iri = "https://w3id.org/smn/Abundance"
)
```

### Python

Pending, as above. Apply the decision by editing the target field in the canonical metadata CSV named by `target_sdp_file` and `target_sdp_field`, and record the reasoning in `scripts/build_sdp.py`.

### Spreadsheet

Type the accepted IRI into the target field, with no `REVIEW:` prefix. Leave the field blank for a rejection and write the reason in your review log.

::::::::::::::::::::::::::::::::::::::::::::::::

Two things make the printed call safe to paste rather than merely suggestive. The argument set is computed by *resolving* it, so `table =` and `code_value =` appear only when they are needed to address one slot and never otherwise. And the object name is read from your own binding — bind the review to `sem_review` and the printed calls say `sem_review <- accept_suggestion(sem_review, …)`.

Mistakes are caught by name, not by silence:

```output
Error in accept_suggestion(sem_review, "FULL_CU", "variable", rank = 1) :
  No review slot matches that column and role.
✖ Asked for: FULL_CU · variable
ℹ FULL_CU_IN · variable
```

```output
Error in accept_suggestion(sem_review, "FULL_CU_IN", "variable", rank = 3) :
  No candidate with that `rank` in this slot.
ℹ Ranks available: 1.
ℹ To accept a term that is not shortlisted, pass `iri` instead.
```

Read `Ranks available: 1.` literally, because it is the most misleading-looking thing on the page. **`create_sdp()` keeps one candidate per role by default** — `semantic_max_per_role = 1` — so the seeded `semantic_suggestions.csv` carries one row per slot rather than a ranked list, and every shortlist you have seen so far is one candidate deep. `rank = 1` is the only rank there is. "Accept rank 1" is therefore a much weaker statement than "the best of five": it is closer to "accept or reject".

Ask for a deeper shortlist at build time, not at review time. The review reads what seeding stored, so this is a `create_sdp()` argument:


``` r
pkg_path <- create_sdp(
  fraser_coho,
  path = file.path("output", "fraser-coho-example-sdp"),
  dataset_id = "fraser-coho-example",
  table_id = "escapement",
  seed_semantics = TRUE,
  semantic_max_per_role = 3,
  check_updates = FALSE,
  overwrite = TRUE
)
```

The same slot then offers three:

```output
── escapement · NATURAL_SPAWNERS_TOTAL · variable ────────────────────────────
   field:   column_dictionary.csv · term_iri
   current: REVIEW: https://w3id.org/gcdfo/salmon#SpawnerAbundance

   [1] Spawner abundance   gcdfo   score 18.25
       The abundance (count) of adult salmon that reach spawning grounds in a
       given system and time period (often operationalized as
       escapement/spawning escapement).
       https://w3id.org/gcdfo/salmon#SpawnerAbundance
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 1)

   [2] Relative hatchery spawner abundance   gcdfo   score 15.25
       Hatchery-origin spawner abundance expressed as a relative
       (dimensionless) abundance metric to a defined reference (commonly
       benchmarks), for within-series comparison; in rapid-status workflows,
       relative abundance is computed using the current generational average
       (geometric mean) divided by CU-specific lower and/or upper benchmarks.
       https://w3id.org/gcdfo/salmon#RelativeHatcherySpawnerAbundance
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 2)

   [3] Relative hatchery spawner abundance change   gcdfo   score 15.25
       A change metric (delta or percent change, as defined by the workflow)
       computed from relative hatchery-origin spawner abundance values over
       time; in rapid-status workflows, percent change is derived from
       log-transformed series and quantified over the most recent three
       generations.
       https://w3id.org/gcdfo/salmon#RelativeHatcherySpawnerAbundanceChange
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 3)

       review <- reject_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable")   # no candidate fits
```

Notice what a deeper shortlist actually bought: ranks 2 and 3 are *hatchery*-origin terms, for a column of *natural*-origin spawners. More candidates gave you more to rule out, not more to choose from — which is useful, and is not the same as more confidence. Depth costs seeding time on every column, so raise it when you are doing careful work on a narrow table, not by default.

Either way, when rank 1 is wrong the reliable escape is `iri =`, not rank 2.

## Treat suggestions as drafts

A score is a retrieval score. It measures how well a query matched a label and a definition; it is not agreement, and it is not evidence about your column.

Here is the very first slot in the unfiltered Fraser Coho queue:

```output
── escapement · AREA · variable ──────────────────────────────────────────────
   field:   column_dictionary.csv · term_iri
   current: <blank>

   [1] water body   ols   score 9.35
       The term body of water most often refers to large accumulations of
       water, such as oceans, seas, and lakes, but it includes smaller pools
       of water such as ponds, wetlands, or more rarely, puddles. A body of
       water does not have to be still or contained; Rivers, streams, canals,
       and other geographical features where water moves from one place to
       another are also considered bodies of water.
       http://purl.obolibrary.org/obo/ENVO_00000063  https://www.ebi.ac.uk/ols4/ontologies/envo/classes/http%3A%2F%2Fpurl.obolibrary.org%2Fobo%2FENVO_00000063
       review <- accept_suggestion(review, "AREA", "variable", rank = 1)

       review <- reject_suggestion(review, "AREA", "variable")   # no candidate fits
```

`AREA` in NuSEDS is a DFO statistical management area — an administrative identifier. The top and only candidate is an ENVO class for a body of water. It scores 9.35 and it is wrong. Reject it.

`WATERSHED_CDE` is the sharper case, and it is the reason step 2 of the checklist below is not redundant with step 1. Its top candidate is labelled **watershed**, which matches the column name about as well as a label can. Read the definition and it turns out to be *"the separation between neighbouring drainage basins"* — the divide, not the basin. The column stores neither: it stores a code. The label matched and the concept did not, which is precisely the failure a label-only check cannot see.

Keep a suggested IRI only when:

1. the label matches what the column means;
2. the definition matches the dataset context;
3. the scope is right;
4. the unit is compatible with the values;
5. the mapping does not erase an important caveat.

If any check fails, reject it, supply the right IRI with `iri =`, or leave it for the term-gap workflow in Session 6.

::::::::::::::::::::::::::::::::::::: callout

## Where the second IRI on the line comes from

Candidates retrieved through OLS print their IRI followed by a browsable OLS4 URL, because the IRI itself does not resolve to a human-readable page. In a terminal that supports hyperlinks you get one clickable label instead. Candidates from `smn`, `gcdfo`, and NVS print one IRI, because that IRI is already the page.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: callout

## What you read is what the vocabulary says

Definitions come from third parties, and some of them contain characters that mean something to R's message formatter. A definition reading *"…returning to spawn in a stream {reach}"* prints exactly that, braces included. The review console emits its lines with `cat()` rather than through a message template, so ontology text is never interpreted — you are reading the definition, not a rendering of it.

That matters for review: a definition that had been silently reformatted, truncated at a brace, or replaced by a formatting error would be the one piece of evidence you most need intact.

::::::::::::::::::::::::::::::::::::::::::::::::

## Measurement semantics and I-ADOPT

For `column_role = measurement`, SDP combines a variable link, I-ADOPT-style meaning components, a unit link, and an optional statistical-modifier link.

| Field | Plain-language question |
| --- | --- |
| `term_iri` | What complete measurement variable is this? |
| `property_iri` | I-ADOPT property: what characteristic is measured — count, length, mass, temperature? |
| `entity_iri` | I-ADOPT entity/object of interest: what is being measured? |
| `constraint_iri` | Optional I-ADOPT constraint: what qualifier narrows the meaning? |
| `unit_iri` | What unit are the values in? |
| `statistical_modifier_iri` | Optional: is the column an aggregation — a mean, maximum, minimum, total, or peak — rather than a single observation? |

The queue shows one slot per field, so the decomposition is decided one question at a time.

```output
── escapement · NATURAL_SPAWNERS_TOTAL · property ────────────────────────────
   field:   column_dictionary.csv · property_iri
   current: REVIEW: https://w3id.org/gcdfo/salmon#SpawnerAbundance

   [1] Spawner abundance   gcdfo   score 18.95
       The abundance (count) of adult salmon that reach spawning grounds in a
       given system and time period (often operationalized as
       escapement/spawning escapement).
       https://w3id.org/gcdfo/salmon#SpawnerAbundance
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "property", rank = 1)
```

This one deserves a stop. Retrieval offered the *same term* for `term_iri` and `property_iri`, and it cannot be right in both places: "spawner abundance" is a whole measurement variable, whereas the I-ADOPT property is the bare characteristic being measured. Decomposing a variable into itself records nothing. The property here is abundance:


``` r
review <- accept_suggestion(
  review,
  "NATURAL_SPAWNERS_TOTAL",
  "property",
  iri = "https://w3id.org/smn/Abundance"
)
```

This is the normal case for `iri =`, and it is worth naming as a general habit: when the property and the variable retrieve the same term, the property slot almost certainly needs a broader one.

The remaining three slots:

```output
── escapement · NATURAL_SPAWNERS_TOTAL · entity ──────────────────────────────
   field:   column_dictionary.csv · entity_iri
   current: REVIEW: https://w3id.org/smn/Population

   [1] Population   smn   score 15.55
       A group of organisms of the same species occupying a defined area that
       interbreed and share a gene pool. In salmon, populations are composed
       of one or more demes and form the biological basis for Conservation
       Units.
       https://w3id.org/smn/Population
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "entity", rank = 1)

── escapement · NATURAL_SPAWNERS_TOTAL · unit ────────────────────────────────
   field:   column_dictionary.csv · unit_iri
   current: REVIEW: http://qudt.org/vocab/unit/COUNT

   [1] Count   qudt   score 4.65
       http://qudt.org/vocab/unit/COUNT
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "unit", rank = 1)

── escapement · NATURAL_SPAWNERS_TOTAL · constraint ──────────────────────────
   field:   column_dictionary.csv · constraint_iri
   current: REVIEW: https://w3id.org/smn/NaturalOrigin

   [1] Natural-origin   smn   score 8.6
       Individuals that are born and reared in the wild (natural
       environment).
       https://w3id.org/smn/NaturalOrigin
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "constraint", rank = 1)
```

Note the unit candidate: score 4.65 and no definition at all. A low score with nothing to read is a prompt to check the vocabulary yourself, not a reason to accept faster. Confirm that a count is what the NuSEDS column actually stores before keeping it.

The statistical modifier is the one kind of "how" that stays in the dictionary, because a *mean* weight and a *maximum* weight are genuinely different variables:

```output
── escapement · NATURAL_SPAWNERS_TOTAL · statistical_modifier ────────────────
   field:   column_dictionary.csv · statistical_modifier_iri
   current: REVIEW: https://w3id.org/smn/TotalStatisticalModifier

   [1] Total   smn   score 15.15
       The reported value is the sum or cumulative total of the summarized
       observations, such as an annual total catch or cumulative escapement.
       https://w3id.org/smn/TotalStatisticalModifier
       review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "statistical_modifier", rank = 1)
```

The candidate is offered because the column name contains *TOTAL*. That is a name, not a fact about the values. Confirm with the data holder that the column really is a sum before accepting it; if you cannot confirm it, reject the slot rather than inheriting a claim from a column name.

### The table slot has no column

One queue entry is not about a column at all. `tables.csv$observation_unit_iri` records what one row of the table represents, so the printed call names the table instead:

```output
── escapement · entity ───────────────────────────────────────────────────────
   field:   tables.csv · observation_unit_iri
   current: REVIEW: https://w3id.org/smn/Escapement

   [1] Escapement   smn   score 14.4
       The number of mature salmon that pass through (or escape) fisheries
       and return to fresh water to spawn.
       https://w3id.org/smn/Escapement
       review <- accept_suggestion(review, role = "entity", rank = 1, table = "escapement")
```

Paste it as printed. `columns =` filters on column names, so a `columns` filter always hides this slot; build the queue without one when you want to reach it.

### Methods do not live in the column dictionary

A method describes how a value was produced, not what the column *is*, so it is recorded where it is actually constant: a procedure shared by a whole table goes in `tables.csv$method_iri`; a citable protocol document goes in `protocol_iri`/`protocol_citation` on `tables.csv` or `dataset.csv`; and a method that varies row by row becomes a code column whose values resolve through `codes.csv$term_iri` to shared-vocabulary procedures.

In the Fraser Coho package, `ESTIMATE_METHOD` is exactly that row-varying case, and metasalmon's deterministic NuSEDS crosswalk has already filled several of its code rows during package creation — `Area Under the Curve` resolves to `https://w3id.org/gcdfo/salmon#AreaUnderTheCurve` with no `REVIEW:` prefix at all. Those rows are written directly and produce no suggestions, so **they never appear in the review queue**. Open `metadata/codes.csv` and check them by eye. A crosswalk is a defensible default, not a decision you made.

Important boundary: `property_iri`, `entity_iri`, `constraint_iri`, and `statistical_modifier_iri` are I-ADOPT-style measurement-variable components. `unit_iri` is measurement semantics too, but units are not an I-ADOPT role, and methods are not part of the variable at all. Do not use these fields as general-purpose relationship fields for identifiers, attributes, or categorical columns.

## Write the decisions back

Decisions live only in the review object until you apply them.

::::::::::::::::::::::::::::::::::::: group-tab

### R


``` r
apply_sdp_semantics(pkg_path, review)
```

```output
✔ Applied 8 semantic review decisions to 'output/fraser-coho-example-sdp'.
ℹ Check the result with `validate_salmon_datapackage(path, require_iris =
  TRUE)`.
```

### Python

Pending. Edit the target metadata CSV fields directly, then revalidate.

### Spreadsheet

Save the metadata CSVs you edited, keeping the header row and column order unchanged.

::::::::::::::::::::::::::::::::::::::::::::::::

`apply_sdp_semantics()` is deliberately narrow, and the narrowness is the safety property:

- accepted IRIs are written with the `REVIEW:` prefix stripped;
- rejected slots are cleared;
- **undecided slots are left exactly as they were**, `REVIEW:` markers and all;
- `term_type` is kept in step with `term_iri`, so the dictionary never claims a kind for a term it no longer holds;
- `datapackage.json` and `semantic_suggestions.csv` are updated in the same transaction, because the descriptor duplicates the dictionary's IRI fields and a half-applied edit would leave the package quietly self-inconsistent; and
- **no data CSV byte is touched.**

That last point is the difference from `write_salmon_datapackage()`, which rebuilds a whole package from in-memory objects. Applying a review is a surgical metadata edit. Applying the same review twice produces identical bytes, which is what makes it safe to leave in a build script that runs every day.

Check the claim rather than believing it — the file hash of `data/escapement.csv` is the same before and after:


``` r
before <- tools::md5sum(file.path(pkg_path, "data", "escapement.csv"))

apply_sdp_semantics(pkg_path, review)

identical(before, tools::md5sum(file.path(pkg_path, "data", "escapement.csv")))
#> TRUE
```

Rebuild the queue afterwards and it is shorter: the slots you decided now hold final IRIs, so they drop out.


``` r
review_semantics(pkg_path)
```

### The decision that stays in the package

Your script is the record of *why*. `semantic_suggestions.csv` now also records *which* — `apply_sdp_semantics()` writes a `decision` column beside the candidates it was choosing between:


``` r
suggestions <- readr::read_csv(
  file.path(pkg_path, "semantic_suggestions.csv"),
  show_col_types = FALSE
)

suggestions[!is.na(suggestions$decision), c("column_name", "dictionary_role", "decision")]
```

```output
# A tibble: 8 × 3
  column_name            dictionary_role      decision
  <chr>                  <chr>                <chr>
1 AREA                   variable             rejected
2 NATURAL_SPAWNERS_TOTAL variable             accepted
3 NATURAL_SPAWNERS_TOTAL property             not_selected
4 NATURAL_SPAWNERS_TOTAL entity               accepted
5 NATURAL_SPAWNERS_TOTAL unit                 accepted
6 NATURAL_SPAWNERS_TOTAL constraint           accepted
7 NATURAL_SPAWNERS_TOTAL statistical_modifier accepted
8 <NA>                   entity               accepted
```

Row 8 has no `column_name` because it is the table observation-unit slot.

This is the first durable, in-package record of a review decision, and it travels with the package rather than with your project folder. Three values appear:

- `accepted` — this candidate was chosen;
- `rejected` — the slot was rejected, so no candidate was chosen; and
- `not_selected` — this candidate was on the shortlist and lost. The `property` row reads `not_selected` because we accepted `smn:Abundance` with `iri =` instead of the shortlisted term.

Read the `property` row as the useful case: it is the one that tells a later reader the shortlist was overruled, which is exactly the fact a copied cell used to hide.

A fourth column, `decision_reason`, carries the sentence you passed to `reject_suggestion()`. Add it to the selection above to see it:


``` r
suggestions[
  !is.na(suggestions$decision),
  c("column_name", "dictionary_role", "decision", "decision_reason")
]
```

`review_semantics()` reads that column back, so rebuilding the queue tomorrow keeps your rejections out of it instead of asking the same question again.

## The finished script

Session 3 said every accepted decision belongs in the script rather than in a manual edit inside `output/`. This is what that looks like for semantics. Append it to `scripts/build_sdp.R`, below the `create_sdp()` call:


``` r
review <- review_semantics(pkg_path)

review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "variable", rank = 1)
review <- accept_suggestion(
  review, "NATURAL_SPAWNERS_TOTAL", "property",
  iri = "https://w3id.org/smn/Abundance"          # the shortlist offered the whole variable
)
review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "entity", rank = 1)
review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "unit", rank = 1)
review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "constraint", rank = 1)
review <- accept_suggestion(review, "NATURAL_SPAWNERS_TOTAL", "statistical_modifier", rank = 1)
review <- accept_suggestion(review, role = "entity", rank = 1, table = "escapement")

review <- reject_suggestion(
  review, "AREA", "variable",
  reason = "DFO statistical area, not a body of water"
)

apply_sdp_semantics(pkg_path, review)

validate_salmon_datapackage(pkg_path, require_iris = FALSE)
```

Every line is a decision, every decision can carry its reasoning in a comment beside it, and the whole thing reruns. That is the property the spreadsheet could not give you.

Expect `validate_salmon_datapackage()` to still warn here: the slots you did not decide keep their `REVIEW:` markers, and the free-text placeholders are untouched. That is the correct state for a package mid-review.

One caveat about rerunning. The decisions replay deterministically, but the *candidates* do not: shared vocabularies evolve, so a future `create_sdp(seed_semantics = TRUE)` may retrieve a different shortlist and `rank = 1` may then name a different term. Where an accepted IRI must never drift, write it as `iri = "…"` instead of `rank = 1`. That converts a position into a commitment.

## What this review cannot decide

Say these out loud in the workshop. A tool that hides its limits teaches learners to trust it in the places it is weakest.

**A slot with no candidate never appears in *this* queue.** `review_semantics()` is built from shortlists, not from gaps, so a required field that retrieval found nothing for is silently absent from it. That is a property of the semantic queue, not a limit of the package: `review_metadata()` reads the package against the rules that actually decide strict validation — the schema's required fields, the `MISSING …:` placeholders, the measurement-IRI requirement and the table observation-unit requirement — so a field no retrieval ever touched is as visible to it as one with five candidates. Run it after this chapter, and treat *its* report, rather than an empty semantic queue, as the authority on whether the package is finished.

**Free-text fields have their own R-native flow, and it is not this one.** Descriptions, contacts, licences and the other `MISSING …:` placeholders are outside the semantic review, but they are no longer a spreadsheet job either. `review_metadata()` prints the exact `set_sdp_dataset()` / `set_sdp_table()` / `set_sdp_column()` / `set_sdp_code()` call for each one, with the value left as a `<…>` placeholder you replace:


``` r
review_metadata(pkg_path)

set_sdp_dataset(pkg_path,
  creator = "Fisheries and Oceans Canada - Pacific Region"
)
```

The same rule as this chapter applies: **the printed call is the contract, and the paste is the audit trail.** Pasting one unedited is refused — a `creator` field reading `<add creator, team, or originating program>` would pass strict validation while saying nothing, which is worse than the placeholder it replaced, because the marker is gone. Session 6 covers where that gate sits in the publication workflow.

**Some suggestion targets are not decidable in the semantic queue.** A target with no single IRI field to write into — the dataset keyword list, for example — is reported and skipped rather than shown as something you can accept. Set those with `set_sdp_dataset(pkg_path, keywords = "…")`, which checks the field name against the schema, so a misspelling is an error rather than a silent no-op.

::::::::::::::::::::::::::::::::::::: callout

## Two rough edges this chapter used to carry, and where they went

Earlier drafts of this lesson taught two real defects, because they were real: a rejection did not survive rebuilding the queue, and an empty queue under a mistyped `columns` filter printed the *completion* message — telling a learner who typed `columns = "TYPO"` that their package was finished.

Both were fixed in **metasalmon 0.5.0**, and both were found by teaching this API rather than by testing it. `review_semantics()` now replays recorded decisions and keeps decided slots out of the default queue (pass `include_filled = TRUE` to see them), the rejection *reason* is written to a `decision_reason` column and read back, and a `columns` value matching no column is an error that names the columns that do exist.

They are worth naming rather than quietly deleting. The shared shape is the lesson: **a feature that writes a record and never reads it back has not been round-tripped, and no test that only writes will say so.**

::::::::::::::::::::::::::::::::::::::::::::::::

## Optional LLM-assisted bundle review

This is a **separate step, and it is strictly opt-in.** Nothing in this chapter contacts an LLM: `review_semantics()`, `accept_suggestion()`, `reject_suggestion()`, and `apply_sdp_semantics()` make no network call of any kind. LLM assessment happens earlier, during `suggest_semantics()` or `create_sdp()`, and only when you pass `llm_assess = TRUE` in R or `llm_assess=True` in Python together with an approved provider and model. Supplying context files alone never triggers a call.

When suggestions were generated that way, the review console surfaces the assessment under the candidate as an extra `llm:` line with its decision, confidence, and rationale. It surfaces it; it never generates it. If you did not opt in, those lines simply are not there.

What the assessment is allowed to do is judge the retrieved candidates. It cannot invent an IRI. A measurement's variable, property, entity, unit, constraint, and statistical-modifier candidates are reviewed together as one bundle, and a statistical-modifier candidate is proposed only when the column's name, label, or description names an aggregation. Deterministic validators can downgrade an unsupported `accept` to `review`, but they never substitute a term.

Context files must be passed as existing local file paths through `llm_context_files`, never as parsed data frames or documents. Use only an approved provider and non-sensitive context. An LLM decision is evidence for your review, not a replacement for it: you still paste the call.

## Function reference

Full argument lists and return values: [`review_semantics()`][metasalmon-review-semantics], [`accept_suggestion()` and `reject_suggestion()`][metasalmon-accept-suggestion], [`apply_sdp_semantics()`][metasalmon-apply-sdp-semantics], [`review_metadata()`][metasalmon-review-metadata], and the [`set_sdp_*()` setters][metasalmon-set-sdp-dataset].

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Complete the bounded Fraser Coho review

Work with the shared NuSEDS Fraser Coho package, even if you brought your own dataset.

1. Build the queue with `review_semantics()` and count the slots.
2. Decide the six `NATURAL_SPAWNERS_TOTAL` slots: variable, property, entity, unit, constraint, statistical modifier. Use `iri =` where the shortlist is wrong, and write one sentence in the script saying why.
3. Decide the table observation-unit slot.
4. Reject `AREA` with a reason.
5. Apply the decisions and confirm `data/escapement.csv` is byte-identical.
6. Open `metadata/codes.csv` and check the `ESTIMATE_METHOD` rows the crosswalk filled. Which would you keep? Which would you question?

Do not map additional fields during this exercise.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 2: Prove the review is reproducible

Delete `output/fraser-coho-example-sdp/` and rerun `scripts/build_sdp.R` from the top. Budget a few minutes: this reruns the seeding search as well as the review.

- Does the package come back with the same accepted IRIs?
- Which of your decisions would survive a vocabulary change, and which are pinned to `rank = 1`?
- Rerun `apply_sdp_semantics()` a second time without changing anything. What changed on disk?
- Rebuild the queue after applying. Which slots came back, and why?

Then answer the question this chapter exists for: **if you left this project today, what would the next person be able to reconstruct — and what would they have to guess?**

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- The console prints the exact `accept_suggestion()` call; pasting it into your build script is what makes the decision reproducible.
- `review_semantics()` reads suggestions that already exist. It never searches, and it never contacts an LLM.
- `REVIEW:` and a blank field both mean undecided; a retrieval score is not agreement.
- Shortlists are one candidate deep by default (`semantic_max_per_role = 1`); ask for depth at build time, and expect it to give you more to reject rather than more to accept.
- No part of getting a package to strict validation needs a spreadsheet any more: this queue decides the IRIs, and `review_metadata()` plus the `set_sdp_*()` setters decide the free text and the gaps this queue never shows.
- The workshop review is bounded to one measurement, its I-ADOPT decomposition, its unit and statistical modifier, one table observation unit, and one deliberate rejection.
- I-ADOPT roles describe the measurement variable; units are separate, and methods live at the table, protocol, or code level rather than in the dictionary.
- `apply_sdp_semantics()` is a surgical, re-runnable metadata edit that leaves the data files byte-identical.
- The queue shows shortlists, not gaps — `review_metadata()` shows the gaps, and the validation report decides whether the package is finished.
- Optional LLM assessment is generated earlier and only on explicit opt-in; the review flow only displays it.

::::::::::::::::::::::::::::::::::::::::::::::::
