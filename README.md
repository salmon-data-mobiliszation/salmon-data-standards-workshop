# Salmon Data Standards Workshop

This workshop helps salmon biologists, data stewards, and data scientists turn familiar spreadsheets or CSV files into reviewable **Salmon Data Packages**. The common biologist pathway is practical FAIR publication: preserve the context behind local data, link selected meanings to shared definitions, export reviewed metadata as a validated **EML 2.2 file**, and prepare or perform an authorized upload to an EML-aware catalog such as KNB. Depending on the learner's goals, the pathway can extend to proposing missing shared terms or planning how an organizational vocabulary or ontology will be governed and mapped to the Salmon Domain Ontology. Code-driven activities include R and Python examples, with separate spreadsheet instructions where a no-code path is useful.

The material is being refactored for the Salmon Ontology Development Working Group from an ontology-development-first course into an SDP-first learning path. An ontology is a maintained set of concepts and definitions that also records how the concepts relate. Biologists can complete the common pathway by reusing shared definitions where they help; they do not need to build an ontology or give every field an ontology term. The advanced stewardship pathway addresses organizational vocabularies, ontologies, and bridge mappings for learners whose roles require them.

## Learning Path

1. **Structure first**: create a draft Salmon Data Package from existing data with R/`metasalmon`, the paired Python/`metasalmonpy` workflow, or the blank SDP CSV template.
2. **Context next**: write dataset, table, column, code, caveat, and method notes that travel with the data.
3. **Meaning where it matters**: review suggested term mappings, focusing first on measurement columns and important code lists.
4. **Contribution and stewardship paths**: route unresolved terms to the shared Salmon Domain Ontology, GC DFO Salmon Ontology, or a local/profile vocabulary or ontology; where needed, plan how organizational terms will be governed and mapped to shared anchors.
5. **Publication**: map SDP fields into EML, validate the export, preview the exact catalog deposit, and upload only with appropriate credentials and redistribution authority.

## Audience

This workshop is designed for mixed groups:

- operational salmon biologists who mostly work in Excel;
- data stewards standardizing datasets for sharing;
- R or Python users who want a reproducible SDP workflow;
- ontology maintainers who need better evidence from contributors.

No terminology-standards background is assumed. Session 1 defines semantic links, vocabularies, code lists, and ontologies in plain language; later standards are introduced only when they help with a concrete review decision.

## R and Python implementations

The R package `metasalmon` and Python package `metasalmonpy` are intended to remain behaviorally aligned, but the current workshop records an open catch-up window: R is pinned to `metasalmon` `v0.5.0`, while Python is pinned to `metasalmonpy` `v0.4.0`. Session 4's native semantic-review workflow is therefore taught only in R until the Python port lands. Examples use idiomatic syntax for each language rather than forcing literal API mimicry; deliberate differences are recorded in the [metasalmonpy parity guide](https://salmon-data-mobilization.github.io/metasalmonpy/guides/parity.html).

## Formats

The same materials support two delivery modes:

- **One-hour introduction**: end-goal framing, SDP anatomy and example CSVs, a short package demo, one measurement mapping review, and an SDP-to-EML/catalog preview.
- **Full-day workshop**: hands-on package creation, context capture, mapping review, measurement decomposition, code-list review, term-request planning, EML export, and a credential-free KNB publication dry run.

## Repository Contents

- `episodes/`: learner-facing workshop sessions.
- `learners/setup.md`: setup guidance for R/metasalmon, Python/metasalmonpy, and spreadsheet participants.
- `learners/reference.md`: glossary, decision aids, and core workflow checks.
- `instructors/instructor-notes.md`: facilitation plans for one-hour and full-day delivery.
- `profiles/learner-profiles.md`: persona notes for designing and testing the workshop.
- `docs/entrypoints.md`: short map of the lesson entry points and local checks.

## Related Components

- [Salmon Data Package specification](https://github.com/salmon-data-mobilization/smn-data-pkg)
- [metasalmon R package](https://github.com/salmon-data-mobilization/metasalmon)
- [metasalmonpy Python package](https://github.com/salmon-data-mobilization/metasalmonpy)
- [Salmon Domain Ontology](https://github.com/salmon-data-mobilization/salmon-domain-ontology)
- [GC DFO Salmon Ontology](https://github.com/dfo-pacific-science/dfo-salmon-ontology)

## Development Status

This lesson is under active development.

- Explore the **Issues** tab to find ways to contribute.  
- Join our discussions on the **SDM Discord Server**.  
- Share your feedback to improve and expand the workshop's impact.

---

For more information, visit the [Salmon Data Mobilization GitHub Organization](https://github.com/salmon-data-mobilization) or contact us directly.
