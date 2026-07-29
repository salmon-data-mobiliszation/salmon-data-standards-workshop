---
title: Learner Profiles
---

## Spreadsheet-based operational biologist

Needs:

- a familiar spreadsheet surface;
- plain-language explanation of package files;
- clear stop points that do not require R;
- reassurance that local caveats and constraints will not be erased.

Risk:

- leaves if the workshop starts with ontology tools, URIs, or code.

Success:

- can create or review a draft package and identify what still needs context.

## R-capable data steward

Needs:

- a reproducible `metasalmon::create_sdp()` path;
- review-state and final validation commands;
- guidance for semantic suggestions and gap detection;
- clarity on what not to automate.

Risk:

- over-focuses on strict validation before the data holder has reviewed meaning.

Success:

- can generate a package, guide Excel review, rerun checks, and produce a term-request plan.

## Python-capable data steward

Needs:

- a reproducible `salmonpy.create_sdp()` path;
- the same project layout and package files used in the R walkthrough;
- accurate Python calling conventions for review and gap-detection functions;
- a clear handoff to the normative R publication validator.

Risk:

- assumes matching package versions imply that every validator and term source is identical.

Success:

- can create and review a compatible package in Python, then arrange the authoritative R publication check.

## Ontology or vocabulary maintainer

Needs:

- high-quality requests with definitions, sources, examples, and routing rationale;
- conservative SMN promotion criteria;
- clear distinction between SKOS code lists and OWL structure;
- mapping strength and review state.

Risk:

- receives many vague "please add this column name" requests.

Success:

- receives evidence-rich requests that can be accepted, revised, or routed without rediscovering context.

## Community infrastructure sponsor

Needs:

- a workshop that scales across spreadsheet, R, and Python users;
- low maintenance burden;
- clear handoff from package drafting to governance;
- a one-hour format for outreach and a full-day format for practice.

Risk:

- the workshop promises tooling or automation that the community cannot maintain.

Success:

- participants leave with reusable packages, clear next actions, and fewer avoidable term requests.
