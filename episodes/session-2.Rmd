---
title: 'Reusing Terms — Search and Integrate Existing Vocabularies'
teaching: 90
exercises: 5
---

:::::::::::::::::::::::::::::::::::::: questions

-   Are the terms I need already defined somewhere else?
-   How can I responsibly reuse existing terms and URIs?
-   What are the benefits of aligning early rather than reinventing?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

-   Learn how to discover and evaluate existing vocabularies relevant to your domain (e.g., Darwin Core, WoRMS, OBO ontologies).
-   Understand how to reuse URIs and integrate external definitions into your own data dictionary.
-   Practice linking your data elements to authoritative terms where appropriate.

:::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

Every dataset — whether from your lab, your agency, or another research group — uses terms to describe its contents. Column headers, variable names, and codes all hold meaning, but often those meanings are assumed rather than shared.

When everyone invents their own terms for the same concept (e.g., SmoltCond, ConditionFactor, CF), it becomes difficult to integrate or compare data across projects.

Reusing existing terms — with clear definitions and persistent identifiers (URIs) — makes your data:

- Easier to share and integrate

- More interoperable and transparent

- Aligned with others in your community

- Future-proof for modeling and ontology building

This session helps you learn where to find existing vocabularies, how to decide what to reuse, and how to incorporate those terms into your own data dictionary.

::::::::::::::::::::::::::::::: callout

🧩 Core Ideas

Term reuse means adopting existing, well-defined concepts instead of inventing new ones.

Each reused term has a URI (Uniform Resource Identifier) that makes it globally recognizable.

Reusing does not mean losing your local context — you can still describe how your project uses a term, while referencing a shared definition.

This is a key first step in making your data “semantic” — meaning it can be understood by both humans and machines.

:::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::: instructor

1.  Warm-up Discussion (10 min) Ask:

“What challenges do you face when merging data from other sources?”

“Has anyone tried to interpret someone else’s dataset and gotten confused by a term?” → Summarize: inconsistent naming blocks reuse and synthesis.

2.  Concept: Why Reuse? (10 min) Explain that reusing existing terms ensures that data “speak the same language.” Example:

- Instead of inventing “broodYear”, reuse the URI <https://purl.dataone.org/odo/SALMON_00000520>.
- This URI points to a definition that others already understand.

3.  Demonstration: Searching Existing Vocabularies (15 min) Instructor shares screen:

- Search for “salmon” or “brood year” on BioPortal.bioontology.org or NVS.
- Show how to view term metadata (label, definition, URI, license).
- Demonstrate copying the URI into the Data Dictionary Template.

4. 🧠 Challenge / Activity 1: Find and Reuse (30 min)

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge 1: Find and reuse (30 min)

Goal: Identify existing vocabulary terms that match your own dataset.

Steps:

1.  Select 3–5 column names from your dataset.

2.  Search for equivalent terms in one or more repositories.

3.  Record matches in the Data Dictionary Template:

-   Your local term
-   External URI
-   Source vocabulary name
-   Notes on whether it’s an exact or close match

:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: instructor

Group Debrief (10 min)
Ask:

- Which terms were easy to find?
- Which were hard or missing?
- When would you decide to reuse vs. define your own?

5. Reflection (10 min)
Discuss the downstream benefits:

- Reusing terms enables automatic linking and machine-readability.
- Fewer mapping issues later when integrating salmon datasets.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::: solution

## Expected Outputs

Updated data dictionary with at least three reused terms and their URIs.

Learners understand how to find, evaluate, and record external vocabularies.

::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: keypoints

-   Controlled vocabularies capture shared meaning of terms.
-   Reusing existing URIs improves interoperability and credibility.
-   Reuse saves time, avoids duplication, and makes future integration easier.

::::::::::::::::::::::::::::::::::::::::::::
