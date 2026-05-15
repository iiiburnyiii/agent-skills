---
name: step-back
description: >
  Circuit breaker — stop all current attempts, diagnose why the approach is failing,
  propose a fundamentally new direction before trying again. Use when stuck in a loop,
  when multiple attempts have failed, or when the current approach feels wrong.
  Triggers on: "step back", "что-то идёт не так", "let's reconsider", "stop, переосмыслим",
  "we're going in circles", "this isn't working", "start over", "wrong approach",
  "circuit breaker", "take a step back".
---

# Step Back — Circuit Breaker

Stop all current attempts. Do not try another fix or another approach variation.

Follow these steps in order:

## 1. State the real goal

Go back to what was originally asked for. Not "make this error go away" — the actual user-facing goal. One sentence.

## 2. Trace the path

List the last 3-5 things tried, briefly. For each, note what went wrong. Look for a pattern:
- Are all failures related to the same root cause?
- Are you fighting a library/framework not designed for this?
- Did an early assumption turn out wrong?
- Is the approach fundamentally incompatible with the constraints?

## 3. Identify the core issue

Name the real blocker in one sentence. Common patterns:
- "I assumed X but actually Y" (wrong mental model)
- "This library doesn't support Z" (wrong tool)
- "The architecture makes this hard because..." (need to change approach)
- "I'm overcomplicating this — the simple solution is..." (overthinking)
- "The spec is ambiguous on X — we need to decide before proceeding"

## 4. Propose a new direction

Fundamentally different, not a variation of what failed:
- What the new approach is (one paragraph max)
- Why it avoids the problems that blocked previous attempts
- Any trade-offs or risks

## Rules

- Do NOT proceed until the user confirms the new direction. The whole point is to break the cycle.
- If the blocker is an ambiguous requirement, surface the ambiguity explicitly — don't guess around it.
- If the blocker is a missing assumption, name it as AS-style and ask the user to resolve it.
