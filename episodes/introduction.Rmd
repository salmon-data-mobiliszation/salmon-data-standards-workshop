---
title: "Introduction to Salmon Knowledge Modelling"
teaching: 10
exercises: 2
---

::: questions
-   How do you write a lesson using Markdown and `{sandpaper}`?
:::

::: objectives
-   Explain how to use markdown with The Carpentries Workbench
-   Demonstrate how to include pieces of code, figures, and nested challenge blocks
:::

## Introduction

This workshop helps participants collaboratively develop, document, and align controlled vocabularies to improve data interoperability in salmon research and management. It emphasizes practical, community-centered steps that support long-term reusability and transparency, while remaining adaptable to other organizations or domains.

### Why Controlled Vocabularies Matter

Inconsistent terminology prevents data integration and makes shared understanding difficult across agencies, researchers, and Indigenous knowledge systems. Controlled vocabularies address this by:

-   Capturing and standardizing the meaning of key terms

-   Enabling clear documentation and communication

-   Forming the foundation for ontologies and semantic integration

### Learning Approach

This is a Carpentry-style, hands-on workshop. Each module builds on your own data and progresses from discovering terms you already use → documenting them clearly → aligning them with others.

::: instructor
Inline instructor notes can help inform instructors of timing challenges associated with the lessons. They appear in the "Instructor View"
:::

::::: challenge
## Challenge 1: Can you do it?

What is the output of this command?

``` r
paste("This", "new", "lesson", "looks", "good")
```

::: solution
## Output

``` output
[1] "This new lesson looks good"
```
:::

## Challenge 2: how do you nest solutions within challenge blocks?

::: solution
You can add a line with at least three colons and a `solution` tag.
:::
:::::

## Figures

You can use standard markdown for static figures with the following syntax:

`![optional caption that appears below the figure](figure url){alt='alt text for accessibility purposes'}`

![Blue Carpentries hex person logo with no text.](https://raw.githubusercontent.com/carpentries/logo/master/Badge_Carpentries.svg)

::: callout
Callout sections can highlight information.

They are sometimes used to emphasise particularly important points but are also used in some lessons to present "asides": content that is not central to the narrative of the lesson, e.g. by providing the answer to a commonly-asked question.
:::

## Math

One of our episodes contains $\LaTeX$ equations when describing how to create dynamic reports with {knitr}, so we now use mathjax to describe this:

`$\alpha = \dfrac{1}{(1 - \beta)^2}$` becomes: $\alpha = \dfrac{1}{(1 - \beta)^2}$

Cool, right?

::: keypoints
-   Use `.md` files for episodes when you want static content
-   Use `.Rmd` files for episodes when you need to generate output
-   Run `sandpaper::check_lesson()` to identify any issues with your lesson
-   Run `sandpaper::build_lesson()` to preview your lesson locally
:::
