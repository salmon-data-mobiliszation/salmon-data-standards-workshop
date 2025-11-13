---
title: 'Bonus Session'
teaching: 90
exercises: 3
---
# Ontology Game Workshop
## Making Sense of Salmon Research Data

:::::::::::::::::::::::::::::::::::::: questions 

- What is an ontology, and how does it differ from a data dictionary?
- Why does salmon research data need clearer semantics?
- What challenges arise when different people organize the same vocabulary?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Define “ontology” in the context of data integration.
- Recognize data ambiguity problems common in salmon science.
- Connect these problems to ontology-based solutions.
- Recognize why implicit structures must become explicit in an ontology.
- Reflect on the need for controlled vocabularies.

::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Facilitator Tips

- Keep the tone light and curious — emphasize exploration, not correctness.  
- Encourage laughter when groups disagree — it mirrors real data harmonization.  
- Use salmon-specific examples participants recognize to ground abstraction.  
- End with a call to action: share a link or example ontology relevant to their domain (e.g., EnvO, Darwin Core, OBO Foundry).


Introduction 

- Welcome participants and outline the workshop structure.
- Introduce the idea that ontologies = shared meaning frameworks — not just fancy dictionaries.
- Use a relatable example:
 "If one project measures 'juvenile abundance' and another measures 'smolt density', do we know if those data can be compared?"


Slide or flipchart talking points:

- Data integration challenges in salmon research:
  - Different terms for similar things.
  - Ambiguous definitions.
  - Data collected at different scales or life stages.
  
- How ontologies help:
  - Clarify relationships between terms.
  - Enable machine-readable data structures.
  - Support data discovery and reuse.


Transition:

"Let’s explore how our own thinking about salmon data reflects some of these challenges."

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

An ontology acts as the database schema or rule book for your knowledge model. It defines:

Types of *nodes (entities)*: "Person," "Film," "Genre."

Types of *edges (relationships)*: A "Person" can "direct" or "star in" a "Film."

*Properties* for entities and relationships: A "Person" has a "name" and "birth year."

Ontologies provide foundational rules and structure, ensuring consistent interpretation by both humans and machines.

## Understanding transitive properties 

A **transitive property** is a relationship where if A relates to B, and B relates to C, then A relates to C.

Here is an example of how different life stages of salmon relate to spawning events, using a few clear classes and one transitive property.

We often record salmon data at different points in their life cycle — for example, a smolt *Migration Event* one year and a *Spawning Event* several years later.

By using a transitive property like _hasLifeStageEvent_, we can reason that the same Stock is connected across all those events.

### Transitive properties help us:

- Represent hierarchies (e.g., Species → Population → Individual).

- Capture temporal or process chains (e.g., Smolt → Adult → Spawner).

- Enable reasoning that connects related concepts without manually writing every link.

::::::::::::::::::::::::::::::::::::: callout

```
Stock_A hasLifeStageEvent SmoltMigration_2022 .

SmoltMigration_2022 hasLifeStageEvent Spawning_2025 .
```
thus 
```
Stock_A hasLifeStageEvent Spawning_2025 .
```

:::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Sorting the Vocabulary Soup (20 min)

**Goal:** Experience how people intuitively categorize domain concepts — and how different those categories can be.

### Materials
- Card sets with one term per card (20–30 total per table)
- Example terms:  
  `water temperature`, `age`, `length`, `weight`, `life stage`, `spawn date`, `smolt`, `tag ID`, `river reach`, `capture event`, `habitat type`, `species`, `sex`, `growth rate`, `migration timing`
- Timer (10–15 minutes)
- Table space or wall for grouping

### Instructions
1. Each group gets a shuffled deck of term cards.
2. Ask them to **organize terms into groups that make sense to them**.  
   No rules — they can group by theme, data type, biological scale, etc.
3. Once grouped, have each group name their categories.
4. Optional: groups walk around and view each others' arrangements.

:::::::::::::::::::::::::::::::::::::::::::::::

## Implicit meanings of compound terms

We often see compound terms within dataset columns, yet compound terms often embed multiple concepts. 
For example, "smolt-to-adult return rate" includes:

- Entity: smolt, adult
- Property: return rate
- Process: migration

We cannot express these implicit meanings inside the table without first decomposing the term. 
Understanding these components helps clarify meaning and supports data integration.


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Debrief Discussion (10 min)
 
Prompt questions:

- What patterns did you notice?  
- Did your groups agree easily? Where did disagreements arise?
- Were any terms hard to place?
- What kinds of groupings emerged — by measurement type, by organism, by process?

Facilitator takeaway:

"This shows how even shared vocabulary can have different implicit structures — an ontology helps make those structures explicit."

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Dissecting Salmon Terms (20 min)

**Goal:** Reveal the *hidden components* and embedded meanings in compound terms.

### Materials
- Each group receives 4–6 “compound” term cards.  
  Examples:
  - `Life stage`
  - `Spawner abundance`
  - `Tag detection event`
  - `Smolt-to-adult return rate (SAR)`
  - `Migration success`
  - `Egg-to-fry survival`
- Blank mini-cards or sticky notes
- Pens or markers
- Labels for concepts: *Entity*, *Property*, *Process*, *Event*, *Assertion*, etc.

### Instructions
1. Each group **breaks down each compound term into its atomic concepts**.
   - Example:  
     `Life stage` → organism + developmental phase + (implied) habitat + age range  
     `Tag detection event` → tagged individual + receiver + location + time
2. Write each sub-concept on separate sticky notes.
3. Label the type of each component (e.g. property, process).
4. Optional challenge: *Which team can identify the most distinct sub-concepts in 5 minutes?*

:::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor
Miro key: 

Spawner abundance | adult salmon population | abundance | census count at weir
Capture efficiency | Sampling method event | error | statistical model, such as mark-recapture
Ocean-age 3 | population demographic | count | age classification, but how?? 


Discussion (10 min)

- Which terms were most complex or ambiguous?
- How could decomposition help when mapping data between projects?
- Do you see examples where datasets might use the same word but mean different things?

Facilitator takeaway:

"Ontologies make these hidden structures explicit. When we define relationships clearly, our data become easier to integrate and reason over."


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Build a Mini-Ontology (20 min)

**Goal:** Experience how explicit relationships can organize knowledge.

### Materials
- Blank cards or sticky notes (reuse from previous task)
- Printed relationship arrows or connectors labeled:
  - `is a`
  - `has property`
  - `occurs at`
  - `involves`
  - `measured in`
  - `related to`
- Optional: string or tape to connect items on a wall or table

### Instructions
1. Using the decomposed concepts from Task 2, groups now **connect them into a network** using relationship arrows.
   - Example:  
     `Tag detection event` **involves** `tagged individual`  
     `Tag detection event` **occurs at** `location`  
     `location` **has property** `river reach`
2. Encouraged to **build small hierarchies** (e.g., *smolt* **is a** *juvenile* **is a** *life stage*).
3. Optional: introduce a “data integration twist” — merge two groups’ mini-ontologies and reconcile overlapping terms.

:::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: instructor

Discussion

- How did your structure clarify meaning?
- What relationships felt intuitive vs forced?
- Where did alignment challenges appear when merging?

Facilitator takeaway:

"Ontologies don’t just name concepts — they define how those concepts relate. This structure is what lets systems automatically align datasets."


Wrap-Up and Reflection (10 min)

Group discussion prompts:

- Where in your research workflows do you see ambiguity in data terms?
- Which tasks today reflected real challenges in your projects?
- What would be the first step towards adopting an ontology in your work?

Facilitator closing:

"By making meaning explicit, ontologies turn local data into shared, interoperable knowledge. Even small steps — like decomposing terms or defining relationships — move us toward more integrated salmon science."


Optional Gamification Ideas

- Ontology Bingo:
  Each participant gets a bingo sheet with boxes like “Found a synonym”, “Identified hidden concept”, “Merged two groups”, “Defined an ‘is-a’ relationship”.  
  Mark off during tasks; first to shout “Semantic alignment!” wins a small prize.

- Ontology Auction: 
  Each group receives a “dataset” card (e.g., spawn timing dataset, tag detections, habitat surveys).  
  They can “bid” for ontology terms (like event, location, organism, measurement) to integrate their data — illustrating the value of reusability.


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints 

- Ontologies go beyond vocabulary—they structure meaning.

- Shared semantics make integration and reuse possible.

- Even small conceptual differences can block interoperability.

::::::::::::::::::::::::::::::::::::::::::::::::

