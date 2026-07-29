---
title: 'Instructor Notes'
---

## Teaching stance

Start with the learner's data, not ontology theory. The first win is a package that someone else can review.

Before using specialized language, say:

> An ontology is a maintained set of concepts and definitions that also records how the concepts relate. In this workshop, learners use shared definitions; they do not build an ontology.

Say "link to a shared definition" before introducing "semantic link" or "semantic mapping." Teach the code in R first, then point Python participants to the companion block rather than presenting two separate lectures.

Repeat these messages throughout:

- A clear description is better than a forced IRI.
- Not every field needs an ontology term.
- Measurement columns deserve the most careful semantic review.
- Local context should be preserved and mapped, not renamed away.
- New-term requests are evidence packages for maintainers.

## One-hour introduction

Use this when the goal is awareness and recruitment.

| Time | Activity |
| --- | --- |
| 0:00-0:05 | Why salmon data sharing fails when context is implicit |
| 0:05-0:15 | Show SDP folder anatomy and metadata files |
| 0:15-0:30 | Demo `metasalmon::create_sdp()`; point out the paired Python block and blank CSV template |
| 0:30-0:45 | Review one measurement mapping and one code list |
| 0:45-0:55 | Show one unresolved term and route it |
| 0:55-1:00 | Stop points and next steps |

Do not teach ontology editing in the one-hour format.

## Full-day workshop

| Time | Activity |
| --- | --- |
| 0:00-0:30 | Intro and package anatomy |
| 0:30-1:45 | Create or inspect draft packages |
| 1:45-2:15 | Peer review package structure |
| 2:15-3:15 | Write metadata and README/context notes |
| 3:15-4:15 | Review measurement semantics |
| 4:15-5:00 | Review code lists and SKOS/profile choices |
| 5:00-6:00 | Route term gaps and draft requests |
| 6:00-6:30 | Publication readiness and next steps |

Adjust times for breaks and group size.

## Mixed-audience facilitation

Pair spreadsheet participants with R-capable participants for validation steps, but do not make them wait for code before they can reason about metadata. Python participants should run the paired `salmonpy` blocks; they still need the R `metasalmon` final publication check until validator parity is complete.

Recommended table roles:

- data owner: explains what the data mean;
- package editor: edits the metadata CSV cells;
- reviewer: asks what could be misunderstood;
- mapper: checks suggestions and records gaps.

## Checkpoint prompts

After Session 1:

- Can another person find the data table?
- Can they tell what each row represents?
- Are required metadata blanks visible?
- Can learners explain an ontology as shared concepts, definitions, and relationships?

After Session 2:

- Did the chosen R, Python, or spreadsheet path create the standard package files?
- Which fields still contain placeholders or `REVIEW:` suggestions?

After Session 3:

- Are source data under `data-raw/`, context under `context/`, and generated packages under `output/`?
- Can learners read their own file using a path relative to the project root?
- Is enough context present to prevent obvious misuse?

After Session 4:

- Which measurement mappings are accepted?
- Which are removed or deferred?
- Are units and methods treated separately from I-ADOPT property/entity/constraint?

After Sessions 5 and 6:

- Which terms are shared candidates?
- Which are DFO-specific?
- Which should stay local/profile?
- Is there enough evidence to make a useful request?

## Common pitfalls

- Learners try to fill every semantic field. Redirect to "measurements first."
- Learners trust `REVIEW:` suggestions. Ask them to read the definition and scope.
- Groups debate ontology classes too early. Bring them back to the package row, column, code value, or caveat.
- Local method bins get proposed as shared terms. Ask whether another organization would use the same definition.
- Participants add extra columns to canonical metadata CSVs. Put extra context in the README or sidecar notes instead.

## Facilitator preparation

Before delivery:

- choose a small example dataset;
- prepare an RStudio Project containing `data-raw/`, `context/`, and `output/`;
- prepare one already-created SDP folder for demonstration;
- verify the R 0.1.6 examples and, when Python participants are expected, the `salmonpy` 0.1.6 companion environment;
- prepare one measurement mapping example;
- prepare semantic suggestion output in advance if live vocabulary lookup would interrupt the schedule;
- prepare one categorical code-list example;
- prepare one unresolved term with routing rationale;
- if demonstrating optional LLM review, use an approved provider and non-sensitive context, and show how bundle decisions can be downgraded to manual review;
- decide whether the authoritative R publication validation will be live or instructor-only.
