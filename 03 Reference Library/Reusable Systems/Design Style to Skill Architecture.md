# Design-Style-to-Skill Architecture

Reusable structure for turning a design style (poster system, UI trend, typography system, whatever) into a self-contained skill folder. Reverse-engineered from `github.com/LiamGvchi/gc-minimal-zine-poster` — see `typography/minimal-zine-poster/SKILL.md` for the reference instance.

Use this whenever you have a design direction you've locked in (approved references, a moodboard, a set of "keeper" outputs) and want it to become a repeatable generator instead of a one-off.

## Why this shape

A style spec that's just "here are some rules and some examples" degrades fast — the model either ignores the rules under time pressure or reuses the same recipe every time because nothing forces variation. This structure exists to close both gaps.

## The 7 layers

**1. Frontmatter trigger**
`name` + `description` written as a pattern-match target, not documentation. Pack in every synonym for the input shape a request might arrive in, so vague asks still route here.

**2. Mode Policy**
One paragraph, even if there's only one mode today. Exists as the extension point — lets you add "High-Fidelity Mode" or "Batch Mode" later without restructuring.

**3. Prompt Compiler — inclusion/exclusion list, before any rules**
State what to pull from the style research (visual identity, concrete rules, non-negotiables, variable slots, negative constraints, structural template) and what to explicitly ignore (source metadata, rationale prose, example-specific captions/objects/text, checklist phrasing that isn't a visual constraint). This firewalls the *taste rationale* from the *output* so the model doesn't leak meta-commentary into the generated prompt/design.

**4. First-Principles Fields — fixed order, spatial → abstract**
The actual design system, as N numbered rendering questions in a fixed order. Order should mirror how the medium resolves: frame → where the eye goes → what it lands on → how that's rendered → text/content → the highest-risk variable → medium/texture → felt quality → hard bans. For the zine poster this was 9 fields (Canvas, Attention Geometry, Image Anchor, Anchor Treatment, Typography System, Color Logic, Reproduction Texture, Emotional Temperature, Hard Avoids). Count and names change per style; the ordering principle doesn't.

**5. A dedicated sub-engine for the single highest-risk variable**
Whichever axis is most likely to make the style collapse into generic/boring or into gaudy/off-brand gets its own section with hard numbers, not adjectives — percentages, ranges, counts — plus an explicit forbidden-words list. For the zine poster this was Color (0.8–2.5% of canvas, ban `pale`/`muted`/`faded`/`pastel`/`low saturation`). For a UI style it might be information density or motion duration. For a typography system (see `typography/nature-poster-style/` in this folder) it's the font-pairing + color-follows-photo rule.

**6. Variation Engine — orthogonal axes, not templates**
5-8 independent axes (layout, anchor/subject, content-treatment, texture/finish, mood) with 6-9 options each, plus an explicit instruction: *if recent outputs used the same option on an axis, pick differently.* This is what makes a batch look like a system instead of one template copy-pasted — the zine skill gets hundreds of distinct recipes from ~40 total option-lines.

**7. Workflow → Negative Constraints → Output Format → Quality Gate**
A closed loop:
- **Workflow**: parse input → select variation recipe → compile using the First-Principles Fields in order → generate → self-inspect at the harshest real viewing condition (thumbnail, phone screen, whatever the medium's worst case is) → regenerate once if it fails → return.
- **Negative Constraints**: the ban list, restated standalone and categorized, so it's scannable independent of where it's referenced inline.
- **Output Format**: a fixed template for what gets returned (image + prompt + recipe note, or component + rationale + variant list — whatever fits the medium).
- **Quality Gate**: every upstream rule, restated as a yes/no checklist item. Not new information — the compiler's own rules turned into a self-check the model runs before returning.

## Template skeleton

```
---
name: <skill-id>-v0-1
description: <trigger phrase covering every input shape a request might arrive in>
---

# <Style Name> v0.1

## Mode Policy
Standard Mode only for now (extension point for future modes)

## Standard Mode Compiler
- PULL from style research: [visual identity, concrete rules, non-negotiables, variable slots, negative constraints, structural template]
- IGNORE: [source metadata, rationale prose, example-specific details]

## First-Principles Fields (fixed order, spatial → abstract)
1. Canvas/Frame — output surface and dimensions
2. Attention Geometry — eye path, empty vs. filled ratio
3. Subject/Anchor — the one focal thing
4. Anchor Treatment — material/stylistic process applied to it
5. Content System — how text/copy/UI content behaves
6. [Highest-Risk Variable] Logic — the one axis with numbers, not adjectives
7. Medium/Texture — the physical or output-format finish
8. Emotional Temperature — felt quality before conscious identification
9. Hard Avoids — what breaks the style

## Standard [Risk-Variable] Engine
Numeric bounds (percentages/ranges/counts) + forbidden-word list

## Variation Engine
5-8 orthogonal axes × 6-9 options each
Explicit anti-repeat instruction: don't reuse the prior recipe's choice on an axis

## Standard Output Shape
Fixed N-part structure, each part's job stated in one line

## Workflow
1. Determine mode
2. Parse input → extract the one core idea
3. Select variation recipe (roll axes, avoid repeats vs. recent outputs)
4. Compile using the First-Principles Fields, in order
5. Generate
6. Self-inspect at harshest real viewing condition; regenerate once if failed
7. Return output + spec used + recipe note

## Negative Constraints
Restated ban list, categorized

## Output Format
Fixed markdown template for what gets returned

## Quality Gate
Every upstream rule restated as a yes/no checklist item
```

## Applying it — checklist for a new style

1. Gather references (approved examples, moodboard, "keeper" outputs from past sessions) — same as `typography/nature-poster-style/` and `typography/html-built/` already do for the nature-poster system.
2. Write the plain-language style summary first (identity + anti-identity) — don't skip to rules.
3. Identify the First-Principles Fields for this medium — usually 6-10, always spatial-to-abstract order.
4. Identify the ONE highest-risk variable and give it numbers + a forbidden-word list. If you can't name one, you haven't looked hard enough at what makes past attempts fail.
5. Build the Variation Engine axes from real variation already seen in references — don't invent axes that have no grounding in what "this style" actually tolerates.
6. Write the Quality Gate last, by restating every rule above as a question.
7. Save as `<category>/<style-name>/SKILL.md` under this `HTML Design/` folder (e.g. `typography/<style-name>/SKILL.md`), following the naming pattern `<style-id>-v0-1`.

## Existing instances in this vault

- `typography/minimal-zine-poster/SKILL.md` — quiet paper-poster / zine editorial style, image-generation output
- `typography/README.md` — nature typography poster system; same underlying logic (non-negotiables + variable slots + variation systems A/B/C), written before this architecture was formalized. Worth re-casting into the SKILL.md shape if it becomes a frequently-invoked generator rather than a reference doc.
