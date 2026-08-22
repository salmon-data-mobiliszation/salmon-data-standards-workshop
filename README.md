# Salmon Data Standards Workshop

This workshop helps salmon biologists, data stewards, and data scientists turn familiar spreadsheets or CSV files into reviewable **Salmon Data Packages**. The end goal is practical publication: preserve the context behind local data, export reviewed metadata as a validated **EML 2.2 file**, and prepare or perform an authorized upload to an EML-aware catalog such as KNB. Code examples are R-first, with Python companion blocks for the core package-creation and review workflow.

The material is being refactored for the Salmon Ontology Development Working Group from an ontology-development-first course into an SDP-first learning path. An ontology is a maintained set of concepts and definitions that also records how the concepts relate. Learners use shared definitions where they help; they are not expected to build an ontology or give every field an ontology term.

## Learning Path

1. **Structure first**: create a draft Salmon Data Package from existing data with R/`metasalmon`, the paired Python/`metasalmonpy` workflow, or the blank SDP CSV template.
2. **Context next**: write dataset, table, column, code, caveat, and method notes that travel with the data.
3. **Meaning where it matters**: review suggested term mappings, focusing first on measurement columns and important code lists.
4. **Contribution paths**: route unresolved terms to the shared Salmon Domain Ontology, GC DFO Salmon Ontology, or a local/profile vocabulary or ontology.
5. **Publication**: map SDP fields into EML, validate the export, preview the exact catalog deposit, and upload only with appropriate credentials and redistribution authority.

## Audience

This workshop is designed for mixed groups:

- operational salmon biologists who mostly work in Excel;
- data stewards standardizing datasets for sharing;
- R or Python users who want a reproducible SDP workflow;
- ontology maintainers who need better evidence from contributors.

No terminology-standards background is assumed. Session 1 defines semantic links, vocabularies, code lists, and ontologies in plain language; later standards are introduced only when they help with a concrete review decision.

## R and Python compatibility

The R examples target the tagged `metasalmon` 0.3.0 release, which implements version `sdp-0.3.0` of the SDP specification. The Python companion is `metasalmonpy` 0.2.1 (renamed from `metaSmnPy`/`salmonpy`); its version is a parity claim against metasalmon 0.2.1, so it writes the earlier `sdp-0.2.0` package shape. Use R/`metasalmon` for strict final validation, EML export, and KNB/DataONE publication, migrating Python-created packages with `migrate_sdp_methods()` first.

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
