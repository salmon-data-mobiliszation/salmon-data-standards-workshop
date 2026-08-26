---
title: 'Instructor Notes'
---

## Teaching stance

Start with the end goal, then the learner's data—not ontology theory. In the first five minutes, say:

> How far you take this workflow depends on your goals. The common biologist pathway is FAIR publication through a reviewed Salmon Data Package, validated EML, and a guarded catalog plan. The pathway can extend to proposing missing shared terms or planning how organizational terminology will be governed and mapped to the Salmon Domain Ontology. A live upload is a separate, authorized publication action.

The first hands-on win is still a package that someone else can review. The first code example should only generate templates; do not turn it into a full semantic or publication demonstration.

Before using specialized language, say:

> An ontology is a maintained set of concepts and definitions that also records how the concepts relate. Biologists can complete the common pathway by reusing shared definitions; data stewards and digital librarians can follow the advanced pathway for organizational vocabularies, ontologies, and bridge mappings.

Say "link to a shared definition" before introducing "semantic link" or "semantic mapping." Present R and Python as equivalent language lanes, and point spreadsheet participants to the separate no-code subsection where one is provided.

Repeat these messages throughout:

- A clear description is better than a forced IRI.
- A decision that is not in the script did not happen. The pasted call is the audit trail.
- Not every field needs an ontology term.
- Measurement columns deserve the most careful semantic review.
- Local context should be preserved and mapped, not renamed away.
- New-term requests are evidence packages for maintainers.
- A dataset may contain several tables; a flat file contains one rectangular table.
- The EML sidecar records facts and authority that cannot be inferred safely.
- A credential-free KNB dry run is different from a persistent live upload.

## One-hour introduction

Use this when the goal is awareness and recruitment.

| Time | Activity |
| --- | --- |
| 0:00-0:05 | Introduce the tiered destinations; focus this format on reviewed SDP -> valid EML -> guarded catalog plan |
| 0:05-0:15 | Introduce the integration system and give a high-level tour of the SDP structure |
| 0:15-0:20 | Confirm the project plus `raw_data/`, `scripts/`, and `output/` before code |
| 0:20-0:32 | Run the simple `create_sdp()` template-generation example; point out the R, Python, and spreadsheet lanes |
| 0:32-0:45 | Review key field definitions, one measurement row, and one code row |
| 0:45-0:55 | Trace SDP fields into EML and inspect a credential-free KNB dry-run manifest |
| 0:55-1:00 | Explain rerun safety, authorization boundaries, and next steps |

Do not teach ontology editing in the one-hour format.

## Full-day workshop

| Time | Activity |
| --- | --- |
| 0:00-0:30 | Integration-system overview, dataset/table/flat-file definitions, and high-level package anatomy |
| 0:30-0:45 | Create/open project and confirm `raw_data/`, `scripts/`, and `output/` |
| 0:45-1:45 | Generate the simple example, then create or inspect learner-owned draft packages |
| 1:45-2:15 | Peer review package structure |
| 2:15-3:15 | Write metadata and README/context notes |
| 3:15-4:15 | Review measurement semantics |
| 4:15-5:00 | Review code lists and SKOS/profile choices |
| 5:00-5:45 | Route term gaps and draft requests |
| 5:45-6:30 | Strict validation, EML export, KNB dry run, and later-version workflow |

Adjust times for breaks and group size.

## Mixed-audience facilitation

Spreadsheet participants can use a complete review-and-editing lane for the canonical metadata CSVs. Automated validation, EML export, manifest generation, and publication currently require R or Python; explain that boundary without treating either code implementation as primary.

Recommended table roles:

- data owner: explains what the data mean;
- package editor: edits the metadata CSV cells;
- reviewer: asks what could be misunderstood;
- mapper: checks suggestions and records gaps.

## Checkpoint prompts

After Session 1:

- Can another person find the data table?
- Can they tell what each row represents?
- Can learners distinguish a dataset, table, flat file, and workbook?
- Are required metadata blanks visible?
- Can learners explain an ontology as shared concepts, definitions, and relationships?
- Can learners name the end product and explain why EML needs an explicit mapping sidecar?

After Session 2:

- Was the project and folder layout ready before the demo?
- Did the chosen R or Python path generate the quickstart, or did the spreadsheet path open the canonical blank template?
- Can learners explain that Chapter 2 uses a prepared starting point and Chapter 3 introduces their own data?
- Which fields still contain placeholders or `REVIEW:` suggestions?

After Session 3:

- Are the prepared source data and context files together and unchanged under `raw_data/`, reproducible R/Python builds under `scripts/`, and generated packages under `output/`?
- Can learners read their own file using a path relative to the project root?
- If the dataset has several tables, did they pass a named list and preserve each table's row meaning?
- Is enough context present to prevent obvious misuse?
- Can they explain what an unsafe rerun could overwrite and how a new version protects reviewed work?

After Session 4:

- Which measurement mappings are accepted?
- Which are rejected, and is the reason recorded in the script rather than only in the room?
- Can a learner point at the line in `scripts/build_sdp.R` that made each decision, and rerun it?
- Are units treated separately from I-ADOPT roles, statistical modifiers used only for aggregations, and methods placed at the table, protocol, or code level rather than in the dictionary?
- Can they say what the review queue does *not* show them?

After Sessions 5 and 6:

- Which terms are shared candidates?
- Which are DFO-specific?
- Which should stay local/profile?
- Is there enough evidence to make a useful request?
- Did strict validation pass before EML export?
- Which facts came directly from SDP, and which required `eml-mapping.yml`?
- Was catalog work a dry run or an authorized live upload?
- If updating an older package, was a new version written instead of overwriting reviewed or published state?

## Common pitfalls

- Learners try to fill every semantic field. Redirect to "measurements first."
- Learners trust `REVIEW:` suggestions. Ask them to read the definition and scope.
- Learners read the retrieval score as a confidence score. It is neither. `AREA` in the shared example retrieves an ENVO body of water at score 9.35 and is wrong; use it as the worked counterexample.
- Learners assume `rank = 1` was the best of several. In a one-shot seeded package each slot's shortlist is one candidate deep, so `rank = 1` is usually the only rank there is. Show them `Ranks available: 1.`
- Learners decide in the console and never paste the call into the script. That is the spreadsheet problem in a new costume; stop and have them paste before moving on.
- Learners treat an empty review queue as a finished package. The queue shows shortlists, not gaps; the validation report is the authority.
- Groups debate ontology classes too early. Bring them back to the package row, column, code value, or caveat.
- Local method bins get proposed as shared terms. Ask whether another organization would use the same definition.
- Participants add extra columns to canonical metadata CSVs. Put extra context in the README or sidecar notes instead.
- Participants call a workbook, sheet, dataset, and table the same thing. Ask what the whole collection is, how many rectangular tables it contains, and what one row means in each.
- Participants expect NetCDF to work because Excel workbooks do. Explain that multi-sheet tabular input is different from multidimensional scientific arrays.
- Participants rerun `create_sdp(..., overwrite = TRUE)` after manual edits. Stop and read the reviewed package or write a new versioned folder.
- Participants assume an EML file can be made by renaming another XML file. Show schema validation and the sidecar requirements.
- Participants treat `public = FALSE` as a disposable server-side draft. A live KNB call still creates persistent production objects; use a local dry run for teaching.

## Facilitator preparation

Before delivery:

- choose a small example dataset;
- prepare an RStudio Project containing `raw_data/`, `scripts/`, and `output/`, with the example's data and context inputs together under `raw_data/` and an R or Python build script under `scripts/`;
- prepare one current, already-created SDP folder for later review after the high-level system overview and quickstart;
- install the pinned releases — R/`metasalmon` **v0.5.0** and Python/`metasalmonpy` **v0.4.0**, per `learners/setup.md` — and verify the examples in each language being taught. The two numbers differ on purpose: Session 4's review flow shipped in metasalmon 0.5.0 and has no Python port yet;
- prepare one measurement mapping example;
- prepare semantic suggestion output in advance if live vocabulary lookup would interrupt the schedule. Seeding the shared Fraser Coho example takes roughly three minutes of live vocabulary lookup on a 17-column table, so build it before the session and hand out the folder; Session 4's review itself makes no network call and is instant;
- prepare one categorical code-list example;
- prepare one unresolved term with routing rationale;
- if demonstrating optional LLM review, use an approved provider and non-sensitive context, and show how bundle decisions can be downgraded to manual review;
- prepare a strictly valid, fully reviewed package with real checksum-bound EML sidecars for the final export exercise; do not fabricate these facts during delivery;
- generate and review its credential-free KNB dry-run manifest before teaching;
- decide whether strict validation and EML export in the taught R or Python lane will be learner-run or instructor-led; and
- default to no live catalog upload. If a live demonstration is explicitly authorized, pre-confirm credentials, redistribution authority, intended access, rollback/recovery expectations, and how `published_pending_catalog` will be reported.
