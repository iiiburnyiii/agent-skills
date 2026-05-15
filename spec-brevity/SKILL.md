---
name: spec-brevity
description: >
  Reviews and compresses existing Markdown specs, ADRs, and Notion/Obsidian pages
  by applying brevity principles: remove orphan text, conversation bleed, re-narration,
  and padding. Produces a diff with explanations of what to cut and why.
  Triggers on: "review my spec", "сожми эту спеку", "почисти от воды",
  "check for conversation bleed", "compress this doc", "clean up this spec",
  "remove fluff from", "brevity review".
---

# Spec Brevity Review

Apply brevity principles to a Markdown spec, ADR, or documentation page. Output is a proposed diff with explanations — nothing is written without confirmation.

## When to invoke

- Before publishing a spec to Notion or sharing with the team
- After a long design dialogue that produced a draft with conversation bleed
- When a spec feels too long but you're not sure what to cut
- Periodic cleanup of Obsidian notes that have grown stale

## Process

1. **Read the target file** in full.
2. **Apply the five brevity checks** (see below) — annotate each issue.
3. **Produce a proposed diff** — show what to cut/rewrite and why.
4. **Wait for confirmation** before writing changes.

## The Five Brevity Checks

### 1. Omit, don't fill
Scan for subsections whose content is "none", "n/a", "no open questions", "TBD", or similar defaults.
- **Action:** delete the subsection entirely. Absence of the header is the signal.

### 2. Evidence only on surprise
Scan for evidence citations (command output, file:line refs, grep results) attached to checks that simply passed.
- **Action:** drop evidence from passed checks. Keep evidence only on failures, deferrals, or surprising passes.

### 3. Don't re-narrate
Scan for prose that summarizes what a diff, commit, or linked artifact already shows.
- **Action:** replace with a SHA + short name, or delete entirely.

### 4. One sentence, not a paragraph
Scan for multi-sentence bullets or paragraphs where the second+ sentence adds no new information.
- **Action:** cut to one sentence. If the second sentence is genuinely new info, keep it but flag for review.

### 5. No orphan text (conversation bleed)
Scan for text that references the conversation, the current task, a recent critique, or session semantics.
- **Test:** does this line help a stranger understand the artifact six months from now? If no, it's orphan.
- **Common patterns:**
  - "(Both resolved in design dialogue; kept here as record.)"
  - "As discussed, we decided to..."
  - "Per your feedback, I changed..."
  - Comments that narrate why a value was set rather than what it means
- **Action:** cut. Exception: naming another long-lived file (e.g., "Dispatched from `up:ureview`") is wiring, not bleed — keep.

## Output format

```
## Brevity Review: <filename>

### Issues found

**[Omit-don't-fill]** Line 42: `### Unknowns` section contains only "none". Delete section.

**[Conversation bleed]** Lines 15-17: "(Both resolved in design dialogue; kept here as record.)" — references the conversation, not the artifact. Cut.

**[Re-narration]** Lines 55-58: Prose summarizes the diff already in commit abc1234. Replace with: `See commit abc1234.`

**[One sentence]** Line 71: Second sentence "This was decided because the team preferred simplicity." adds no new info beyond the first. Cut.

### Proposed changes

<diff or rewritten sections>

### Summary
- N issues found
- Estimated reduction: ~X lines / ~Y%
```

## Rules

- Never write changes without user confirmation
- Never cut failures, deviations, deferrals, or known risks — these always keep their evidence and "why"
- Never modify code blocks, inline code, URLs, file paths, or technical terms
- If unsure whether something is orphan or wiring, flag it as "uncertain — review" rather than cutting

## References

- `skills/_shared/brevity.md` — full brevity principles with examples
