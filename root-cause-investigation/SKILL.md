---
name: root-cause-investigation
description: >
  Four-phase root-cause investigation for bugs, unexpected behavior, and reverse engineering.
  Enforces systematic analysis — reproduce, pattern-match, hypothesize, document — with a hard rule
  against symptom patches and guessing. Adapted for analysts: phase 4 produces a findings document,
  not a code fix.
  Triggers on: "почему этот код делает X", "разберись в баге", "reverse engineer this feature",
  "investigate this behavior", "root cause of", "why does X happen", "trace this bug",
  "what causes X", "investigate why".
---

# Root-Cause Investigation

**Iron law:** no conclusions without systematic investigation first. Guessing is failure.

## When to invoke

Any technical issue: unexpected behavior, performance regression, integration failure, "why does this code do X". Especially when:
- Under time pressure (makes guessing tempting)
- You already tried 1+ explanations
- The problem "seems simple" (simple-looking bugs still have root causes)

## Phase 1 — Reproduce and trace data flow

You cannot explain what you cannot observe. Make the behavior happen on demand, then follow the data.

1. Read the error or behavior description completely — stack trace, file, line, error codes. No skimming.
2. Reproduce it — exact steps. Every time? Sometimes? If you can't reproduce: gather more data, don't guess.
3. Check recent changes — git diff, recent commits, new deps, config drift, env differences.
4. Instrument component boundaries — log what enters and exits each boundary to see *where* it breaks before deciding *what* causes it.
5. Trace data flow backward — where does the bad value originate? What called this with the bad value? Keep tracing up until you find the source.

## Phase 2 — Pattern analysis against a working example

Bugs rarely occur in isolation. Find similar code that works, understand *why* it works, then enumerate every difference.

1. Find working examples in the same codebase. What works that's similar?
2. Read reference implementations completely — don't skim, don't adapt something you didn't fully understand.
3. List every difference between working and broken. Don't assume "that can't matter."
4. Enumerate dependencies and assumptions — configs, env vars, adjacent components.

## Phase 3 — Single hypothesis, minimal test

One cause at a time. Stacked guesses turn explanations into guesses about guesses.

1. Form a single hypothesis. Write it: "I think X is the root cause because Y."
2. Test minimally — smallest possible change or observation. One variable at a time.
3. Verify or discard. Confirmed → Phase 4. Not confirmed → new hypothesis.
4. If you don't know, say so. Research, ask. Don't pretend.

## Phase 4 — Document findings

For analysts: the output is a findings document, not a code fix. Findings go to the spec, ADR, or research note.

1. State the root cause in one sentence.
2. Document the evidence trail: what you observed, what you ruled out, what confirmed the hypothesis.
3. Name the pattern behind the bug in one sentence — grep the rest of the code for the same shape and report matches.
4. Propose mitigations or next steps (for the team to implement).
5. Note any assumptions that held or failed (AS-style).

## Output format

```markdown
## Investigation: <topic>

### Root cause
<one sentence>

### Evidence
- Phase 1: <what was observed at each boundary>
- Phase 2: <working example vs broken — key differences>
- Phase 3: <hypothesis tested, result>

### Pattern
<name the pattern in one sentence>
Similar occurrences found: <file:line refs or "none found">

### Mitigations
- <proposed fix or next step>

### Assumptions checked
- AS1 — <assumption> — held / failed
```

## Red flags — STOP, return to Phase 1

These thoughts mean you're about to guess:
- "Quick explanation for now, investigate later"
- "Just try changing X and see if it works"
- "It's probably X, let me explain that"
- "Pattern says X but I'll adapt it differently"
- Proposing solutions before tracing data flow
- "One more attempt" when 2+ have already failed

## When root cause really is environmental

After systematic investigation, if the issue is timing, external, or truly non-deterministic:
- Document what you investigated
- Describe appropriate handling (retry, timeout, loud error)
- Add logging / monitoring recommendations

But 95% of "no root cause" verdicts are incomplete investigations. Double-check before settling for this.
