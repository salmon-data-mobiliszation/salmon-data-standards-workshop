---
title: 'Concept Decomposition'
teaching: 90
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are the components that make up a concept?
- How do I tell when two terms are the same, related, or overlapping?
- What patterns or relationships exist among my documented terms?
- How can I show these relationships clearly?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Decompose complex concepts into simpler, more explicit parts.
- Identify relationships (e.g., broader, narrower, related) among terms.
- Use visual mapping to show how concepts connect.
- Prepare a set of refined concepts that can be formalized in a schema.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction 

Now that your terms are well-defined and documented, the next step is to look beneath the surface — to unpack how those terms relate to one another.

This process, called concept decomposition, helps you:

- See what each concept really means.
- Identify overlaps or hidden distinctions between terms.
- Prepare for formal modeling (where meaning becomes machine-readable).

For example:  
The term “juvenile salmon” might seem simple — until you realize it includes age, size, and life stage. By decomposing it into parts (“life stage: juvenile”, “species: salmon”, “habitat: freshwater”), you make the meaning explicit and ready for alignment with other datasets or vocabularies.

:::::::::::::::::: callout

🧩 Core Ideas

- Concept decomposition means breaking a term down into its essential pieces of meaning.

- It helps you move from words → structure.

- Relationships matter: knowing how one term connects to another is as important as defining it.

- Visualizing your terms helps spot patterns and inconsistencies.

::::::::::::::::::::::::::

### Example

| Term                 | Broader Concept | Narrower Concept | Related Concept |
| -------------------- | --------------- | ---------------- | --------------- |
| **Juvenile salmon**  | Salmon          | Parr             | Smolt           |
| **Smolt**            | Juvenile salmon | —                | Ocean migrant   |
| **Spawning habitat** | Habitat         | Redd site        | —               |


From this, we can see that _Smolt_ is a narrower stage within _Juvenile salmon_, and that _Spawning habitat_ relates to but is distinct from _Redd site_ — these are building blocks for the next module, where we’ll start expressing these ideas formally.

::::::::::::::::::::::::::::::::::::::: instructor

1. Welcome & Overview (10 min)
Instructor Talking Points

“We’ve documented and clarified what our terms mean — now we’ll start exploring how they relate to each other.”

“This process helps identify overlaps, redundancies, and relationships that will make your vocabulary more consistent and integrable.”

“You’ll learn to see terms not just as words, but as concepts in a network of meaning.”

Key Framing Questions

- What happens when two teams use different terms for the same thing?
- How can we make these relationships visible and agreed upon?
- How might this help us integrate data across programs or agencies?
- Encourage learners to see this as a detective exercise: uncovering the hidden structure of their vocabulary.

2. Guided Example: Breaking Down a Concept (10 min)
Instructor Demo

Use a familiar term, e.g., “juvenile salmon”, and walk through decomposing it into component ideas.

Ask aloud:

- What is the core idea here?
- What attributes or qualifiers are implied (e.g., life stage, species, habitat)?
- Is this term broader or narrower than another concept we’ve seen?

Discussion Prompt

Ask participants:

“Can you think of a term in your data that’s used differently by different teams or datasets?”
Use these examples to highlight why decomposition and mapping relationships improves clarity.

3. Activity: Decompose and Map Your Own Terms (30 min)

Instructor Tips

Encourage them not to overthink — this is exploratory, not final.

If they get stuck, prompt with:

“What is this a type of?”

“What does this include?”

“What is this related to but not the same as?”

Walk around (or circulate in breakout rooms) and listen for examples that highlight ambiguity or hierarchy.

::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1: Build a Mapping Table (40 min)

1. Pick 3–5 documented terms from their Module 2 work.

2. Break each term down into its essential pieces of meaning.

3. Identify any broader/narrower/related concepts.

4. Sketch a mini concept map (e.g., on whiteboard, MS Paint, or sticky notes).

:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::: instructor

4. Discussion & Wrap-Up (10 min)
Group Discussion

Invite volunteers to share their concept maps or a tricky example they encountered.

Ask:

“Where did you find terms that overlap or conflict?”

“How might this process help clarify things for your collaborators?”

“What relationships were hardest to define?”

Encourage connections to real-world integration challenges — e.g., two agencies using different terms for similar stages or metrics.

💡 Instructor Notes & Tips
Common Challenges

Learners get bogged down in wordsmithing — remind them that this stage is about structure, not final phrasing.

Difficulty identifying relationships — use analogies (e.g., “species is to genus as narrower is to broader”).

Too narrow a focus — encourage learners to zoom out to see relationships across datasets, not just within one.

Optional Extension

If time allows, show a quick example of a simple schema diagram (e.g., a few boxes and arrows).
Explain that this is where they’re heading: transforming their decomposed concepts into a formal structure that can support data interoperability.

::::::::::::::::::::::::::::::::::::::::::::::::::


:::::::::::::::::::::::::::::::::: keypoints

- Relationships reveal meaning.
- Decomposing terms uncovers hidden assumptions.
- Mapping across datasets helps identify where vocabularies can be aligned.
- Concept decomposition prepares you for formalization in SKOS and ontology modeling (coming next!).

::::::::::::::::::::::::::::::::::::::::::::
