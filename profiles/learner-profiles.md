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

- can generate a package, guide Excel review, rerun checks without discarding reviewed metadata, produce a term-request plan, and export validated EML from a finalized package.

## Python-capable data steward

Needs:

- a reproducible `metasalmonpy.create_sdp()` path;
- the same project layout and package files used in the R walkthrough;
- accurate Python calling conventions for review and gap-detection functions;
- current Python examples for strict validation, EML export, and guarded KNB publication.

Risk:

- assumes behavioral parity removes the need to review language-specific calling conventions and dependencies.

Success:

- can create, review, strictly validate, and export a package in Python, then preview or perform an authorized catalog publication using the same guarded workflow.

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
- a clear transition from package drafting to governance and catalog publication;
- a one-hour format for outreach and a full-day format for practice.

Risk:

- the workshop promises tooling or automation that the community cannot maintain.

Success:

- participants leave with reusable packages, a visible SDP-to-EML path, clear next actions, and fewer avoidable term requests.
