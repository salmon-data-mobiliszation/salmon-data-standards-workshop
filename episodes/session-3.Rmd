---
title: 'Documenting Terms — Write Clear, Useful Definitions'
teaching: 90
exercises: 5
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can I make sure others understand and correctly use my terms?
- What makes a good definition or label?
- How should I record units, examples, and relationships between terms?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Extract and describe terms from their dataset.
- Write unambiguous, well-structured definitions.
- Record associated metadata (units, codes, examples).

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

You’ve identified the key terms used in your datasets — and maybe even found some existing ones to reuse.
Now comes the part that makes your work understandable, trustworthy, and reusable: clear documentation.

Inconsistent or missing definitions are one of the biggest barriers to data reuse. For example:

What does “sample date” really mean — collection date, processing date, or submission date?

Does “juvenile” refer to an age class, a length range, or a life stage?

What are the units? Are they consistent across datasets?

This session will help you document your terms precisely, so anyone — whether a collaborator, data manager, or future researcher — can understand exactly what you meant.

::::::::::::::::::::: callout

🧩 Core Ideas

Documentation is data. It’s the layer that makes data understandable and reusable.

A well-documented term includes:

- Preferred label: the human-readable name.
- Definition: what the term means and how it’s used.
- Units or scale: how it’s measured.
- Example values: what typical data look like.

Notes: clarifications, special cases, or links to other terms.

Think of your data dictionary as a user manual for your dataset.

:::::::::::::::::::::::::::::

### Example

| Term                 | Definition                                                                    | Units                 | Example    | Notes                                                   |
| -------------------- | ----------------------------------------------------------------------------- | --------------------- | ---------- | ------------------------------------------------------- |
| **Condition factor** | A measure of fish body condition, typically calculated as weight/length³.     | dimensionless         | 1.05       | Used as an indicator of energy reserves at smolt stage. |
| **Smolt age**        | The age (in years) of a salmon when it migrates from freshwater to the ocean. | years                 | 2          | Derived from scale analysis.                            |
| **Capture date**     | The date when a specimen was physically collected in the field.               | ISO 8601 (YYYY-MM-DD) | 2023-05-14 | Not to be confused with processing or tagging date.     |


The more clearly you describe your terms now, the easier it becomes to share, integrate, and align your data later — especially when mapping to vocabularies or building ontologies.

::::::::::::::::::::::::::::::::::::::: instructor

1. Concept: What Makes a Good Definition? (15 min)
Show two examples:
❌ “Run timing: when fish come back.”
✅ “Run timing: The seasonal period during which adult salmon return from the ocean to their natal freshwater spawning areas.”
Discuss why clarity, precision, and context matter.

2. Demonstration: Documenting a Term (10 min)
Instructor walks through one dataset column, filling in the template:

Label: brood_year

Definition: “The calendar year when the majority of parental salmon spawned.”

Unit: “Year (YYYY)”

Example: “2017”

Notes: “Equivalent to term in DFO Salmon Concept Scheme.”

3. Activity: Extract and define (40 min)

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1: Extract and define (40 min)

Goal: Create clear, consistent documentation for your own dataset terms.

Review your dataset and list 10–15 column names. Record in a shared data dictionary template (CSV):

- Label (term name)

- Definition (clear, context-rich description)

- Units or codes used

- Example value(s)

- Notes on ambiguity or uncertainty

::::::::::::::::::::::::::::::::::::::::::::::: 

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

4. Discussion: Patterns and Pitfalls (15 min)

Which terms were hardest to define?

Were there local abbreviations or codes that need clarification?

How can we document uncertainty? (e.g., “derived from visual estimate”).

5. Reflection (10 min)
Connect to next steps:

A well-documented data dictionary is the foundation for term alignment.

Later modules will link these definitions to others via mappings.

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: solution 

## Expected Outputs

- A draft data dictionary covering at least 10 key terms.

- Peer-reviewed feedback on definition clarity.

- Improved awareness of semantic gaps in existing data.

:::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::: keypoints

- A data dictionary is the bridge between raw data and understanding.
- Good definitions reduce misinterpretation and support machine processing.
- Documentation is both a social and technical task.

::::::::::::::::::::::::::::::::::::::::::::
