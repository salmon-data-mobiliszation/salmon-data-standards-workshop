# Salmon Data Standards Workshop

This workshop helps salmon biologists, data stewards, and data scientists turn familiar spreadsheets or CSV files into reviewable **Salmon Data Packages**. The focus is practical: preserve the context behind local data, make the package understandable to colleagues, and add shared semantic links only where they improve reuse.

The material is being refactored for the Salmon Ontology Development Working Group from an ontology-development-first course into an SDP-first learning path. Learners should leave with a package they can review, validate, and improve, not with the impression that every field needs a new ontology term.

## Learning Path

1. **Structure first**: create a draft Salmon Data Package from existing data using either the blank SDP CSV template in Excel/Calc or `metasalmon::create_sdp()`.
2. **Context next**: write dataset, table, column, code, caveat, and method notes that travel with the data.
3. **Meaning where it matters**: review suggested term mappings, focusing first on measurement columns and important code lists.
4. **Contribution paths**: route unresolved terms to the shared Salmon Domain Ontology, GC DFO Salmon Ontology, or a local/profile vocabulary or ontology.

## Audience

This workshop is designed for mixed groups:

- operational salmon biologists who mostly work in Excel;
- data stewards standardizing datasets for sharing;
- R or Python users who want a reproducible SDP workflow;
- ontology maintainers who need better evidence from contributors.

No ontology background is assumed. Concepts such as IRI, SKOS, OWL, and I-ADOPT are introduced only when they help with a concrete review decision.

## Formats

The same materials support two delivery modes:

- **One-hour introduction**: system overview, SDP anatomy, a short package demo, one measurement mapping review, and one term-gap routing example.
- **Full-day workshop**: hands-on package creation, context capture, mapping review, measurement decomposition, code-list review, and term-request planning.

## Repository Contents

- `episodes/`: learner-facing workshop sessions.
- `learners/setup.md`: setup guidance for Excel-first and R/metasalmon participants.
- `learners/reference.md`: glossary, decision aids, and core workflow checks.
- `instructors/instructor-notes.md`: facilitation plans for one-hour and full-day delivery.
- `profiles/learner-profiles.md`: persona notes for designing and testing the workshop.
- `docs/entrypoints.md`: short map of the lesson entry points and local checks.

## Related Components

- [Salmon Data Package specification](https://github.com/salmon-data-mobilization/smn-data-pkg)
- [metasalmon R package](https://github.com/salmon-data-mobilization/metasalmon)
- [salmonpy Python package](https://github.com/Br-Johnson/salmonpy)
- [Salmon Domain Ontology](https://github.com/salmon-data-mobilization/salmon-domain-ontology)
- [GC DFO Salmon Ontology](https://github.com/dfo-pacific-science/dfo-salmon-ontology)

## Development Status

This lesson is under active development.

- Explore the **Issues** tab to find ways to contribute.  
- Join our discussions on the **SDM Discord Server**.  
- Share your feedback to improve and expand the workshop's impact.

---

For more information, visit the [Salmon Data Mobilization GitHub Organization](https://github.com/salmon-data-mobilization) or contact us directly.
