---
title: 'From Terms to Meaning: Framing Knowledge with Competency Questions'
teaching: 90
exercises: 2
---

::: questions
-  What is a Competency Question (CQ) and how does it help in ontology development?
:::

::: objectives
-   Explain what a Competency Question (CQ) is and why it’s useful in ontology development.
-   Formulate domain-relevant CQs that reveal how concepts connect and what data relationships matter.
-   Use CQs to guide vocabulary refinement and early ontology design.
-   Understand how CQs validate whether a knowledge model meets its intended purpose.
:::

## Introduction

### Why Competency Questions?

Think of CQs as the "user stories" of ontology design — they describe what users (researchers, managers, etc.) need to know or compare, and ensure your data terms and structures can support those needs.

They help you: - Focus on purpose-driven vocabulary development - Identify data gaps early - Build alignment between scientists, data managers, and modelers

Example: Salmon Data Integration Context

Imagine you have multiple datasets on sockeye salmon:

-   Fraser River dataset: smolt length, weight, and ocean entry date
-   Bristol Bay dataset: similar metrics, but uses different column names and sampling protocols

Possible Competency Questions might be:

-   “Is the average smolt condition at ocean entry higher in one population than another?”
-   “Do differences in smolt condition explain variation in adult return rates?”

From these questions, you can see what concepts need alignment: condition factor, smolt stage, population, region, and return abundance.

::: instructor
1.  Concept Introduction (15 min)

Prompt discussion:

“If your vocabulary or ontology were a smart assistant, what questions would you want it to answer?”

Use this to introduce Competency Questions as a design tool.

Explain: Competency Questions (CQs) help define:

What knowledge must be represented.

How concepts are related.

Which data connections are needed to answer real-world questions.

Example:

“Are differences in sockeye smolt condition at ocean entry contributing to differences in adult return abundances between Fraser River and Bristol Bay populations?” → This implies relationships between smolt condition, population, location, ocean entry timing, and adult return abundance.

Show how each CQ points toward relationships that need to exist in the ontology (e.g., “hasCondition,” “occursAt,” “belongsToPopulation”).

2.  Demonstration: Deriving CQs from Data (10 min)

Instructor uses one term from the data dictionary (e.g., brood_year) and models a possible CQ:

“How does brood year relate to adult return abundance?”

“Which brood years correspond to years of low marine survival?”

Show how these questions hint at:

Entities: brood year, adult return, marine survival rate

Relationships: occurs_in_year, affects, has_rate

Explain that this is the first step in translating vocabulary terms into knowledge relationships.

3.  🧠 Challenge / Activity 1: Writing Competency Questions (35 min)
:::

::: challenge
## Challenge 1: Identify decision points

Goal: Draft and refine CQs that reflect the research or management needs represented by your data.

Steps:

1.  Review your vocabulary terms or data dictionary from earlier modules.

2.  In small groups, brainstorm 3–5 natural-language questions that:

-   Are answerable using your data (or could be if integrated).
-   Require multiple terms or relationships to answer.
-   Reflect real research or management scenarios.

3.  Write each question on a sticky note or digital card.

4.  Group similar questions and discuss:

-   Which terms appear most often?
-   What relationships are implied?
:::

::: instructor
Facilitator Notes:

Encourage specificity. Instead of “What affects salmon survival?”, refine to “Does earlier ocean entry date affect survival of Fraser River Chinook smolts?”

Keep language natural — these aren’t queries yet, just conceptual targets.

4.  🧩 Challenge / Activity 2: Extracting Relationships (20 min)
:::

::: challenge
## Challenge 2: Write your own competency questions

Goal: Identify which terms and relationships are needed to answer each CQ.

Instructions:

In small groups or pairs, write 2–3 CQs that your data integration or modeling efforts should be able to answer.

Focus on specific, realistic, and answerable questions — avoid vague ones like “What is salmon health?”

Check your questions:

-   Are key concepts clearly defined?
-   Do you know what data source could answer it?
-   What relationships would your ontology need to represent?

🧩 Example Revision:

Too broad: “What affects salmon survival?”

Better: “Does smolt condition at ocean entry affect adult return rates by region?”
:::

::: solution
You can add a line with at least three colons and a `solution` tag.
:::

::: challenge
## Challenge 3: Connect CQs to terms

Using your data dictionary from Modules 1–3:

-   Highlight which terms appear in your CQs.
-   Identify any missing terms or unclear definitions.
-   Note which terms might need alignment across datasets (e.g., “region,” “population,” “condition”).
:::

::: keypoints
-   Competency Questions express the intended use of an ontology in natural language.
-   They help translate real-world research and management questions into conceptual structures.
-   CQs are iterative, evolving as you refine your vocabulary and build your ontology.
-   Good CQs are specific, testable, and connected to real data needs.
:::
