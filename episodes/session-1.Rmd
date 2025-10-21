---
title: 'Reusing Terms — Search and Integrate Existing Vocabularies'
teaching: 10
exercises: 2
---

::: questions
-   Are the terms I need already defined somewhere else?
-   How can I responsibly reuse existing terms and URIs?
-   What are the benefits of aligning early rather than reinventing?
:::

::: objectives
-   Learn how to discover and evaluate existing vocabularies relevant to your domain (e.g., Darwin Core, WoRMS, OBO ontologies).
-   Understand how to reuse URIs and integrate external definitions into your own data dictionary.
-   Practice linking your data elements to authoritative terms where appropriate.
:::

## Introduction

Concept decomposition is the process of breaking down complex terms into smaller, more granular concepts. This is particularly useful in data analysis, where terms may be used inconsistently across different datasets. By decomposing terms, we can ensure we understand the underlying concepts and can integrate the data more effectively.

This lesson will guide you through the process of decomposing terms found in different datasets, using real-world juvenile sockeye datasets as examples.

::: challenge
## Challenge 1: Search for existing vocabularies using repositories like FAIRsharing.org, Linked Open Vocabularies (LOV), or w3id.org.
:::

::: solution
``` output
[1] "This new lesson looks good"
```
:::

::: challenge
## Challenge 2: For 3–5 of your dataset’s column names, find potential matches in an existing vocabulary.
:::

::: solution
You can add a line with at least three colons and a `solution` tag.
:::

::: instructor
Discussion: When to reuse vs. when to define new terms.
:::

::: challenge
## Challenge 3: Update your data dictionary to include external URIs and citation links.
:::

::: keypoints
-   Use `.md` files for episodes when you want static content
-   Use `.Rmd` files for episodes when you need to generate output
-   Run `sandpaper::check_lesson()` to identify any issues with your lesson
-   Run `sandpaper::build_lesson()` to preview your lesson locally
:::
