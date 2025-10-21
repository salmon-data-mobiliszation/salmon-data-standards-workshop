---
title: 'Aligning with Others — Create Mapping Tables and Crosswalks'
teaching: 90
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do I connect my terms with those used in other datasets or agencies?
- What relationships exist between similar terms?
- How do I clarify whether two terms really mean the same thing?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Build a mapping table (crosswalk) comparing terms across datasets.
- Use simple semantic relationship types (same_as, close_match, broader_than, narrower_than).
- Learn how to identify equivalent or near-equivalent terms through metadata review and consultation.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: instructor
1. Concept: Why Alignment Matters (10 min)
Explain that mapping terms is how we translate between datasets.
Example:

Dataset A: sex (M/F)

Dataset B: gender_code (1/2)
→ Both represent the same concept but use different encodings.

2. Demonstration: Creating a Crosswalk (15 min)
Instructor compares two small CSVs, shows how to:

Identify possible term matches

Decide on relationship type (same_as, close_match, etc.)

Record reasoning in the notes field

3. 🧠 Challenge / Activity 1: Build a Mapping Table (40 min)
4. 🧠 Challenge / Activity 2: Semantic Refinement (15 min)
::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1: Build a Mapping Table (40 min)

Goal: Align terms across two datasets and document relationships.
Steps:

Each group works with two provided datasets.

Identify at least 5 potential overlapping terms.

For each pair, fill out the crosswalk template with:

Dataset A term

Dataset B term

Relationship type

Notes on definition differences or units

If a match is uncertain, discuss how you’d clarify (e.g., contact data author).
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge 
## Challenge 2: Semantic Refinement (15 min)

Goal: Describe hierarchical relationships.

Choose one pair and add hierarchical detail:

e.g., “Chinook” is narrower_than “Salmonid species”

“Adult return timing” is broader_than “Peak migration week.”
:::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::instructor
5. Discussion & Reflection (10 min)
Prompt questions:

What kinds of differences were most common?

How can mapping tables reduce confusion across projects?

How might you maintain or share these mappings?
:::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::: solution 

## Expected Outputs

- Completed mapping table linking terms across two datasets.

- Understanding of how to express equivalence or relatedness.

- Foundation for the next stage: governance and publication of vocabularies.
:::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::: keypoints
- Alignment makes data interoperable across organizations.
- Mapping tables document where meaning overlaps or diverges.
- Relationships like same_as, close_match, broader_than provide clarity for integration.
::::::::::::::::::::::::::::::::::::::::::::
