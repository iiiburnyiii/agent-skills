---
name: session-reflect
description: >
  Captures learnings from the current session and routes each one to its correct home:
  AGENTS.md for workspace conventions, Memory MCP for cross-session context,
  Notion/Obsidian for domain knowledge, or the current spec/page for task-specific findings.
  Use at the end of a productive session to prevent re-discovery.
  Triggers on: "reflect on session", "что вынесли из сессии", "save learnings",
  "сохрани инсайты", "capture session learnings", "what did we learn", "session summary",
  "save this to memory", "update AGENTS.md with".
---

# Session Reflect

Capture learnings from the session so future sessions can replicate the outcome without re-discovery. This is a review of the dialogue, not of the code.

## Process

### 1. Scan the session for non-obvious content

Ask yourself:
- What was hard or surprising?
- What did the user correct me on?
- What patterns did we settle on after deliberation?
- What external systems, flags, or configs did we touch that aren't self-evident from the code?
- What decisions did we reach that the spec or code doesn't explain?

Discard:
- Anything obvious from reading the current code or spec
- One-off debugging details (the commit message holds them)
- Anything already captured in AGENTS.md, existing docs, or memory

### 2. Route each learning

For each item worth keeping, decide where it belongs:

| Destination | What goes there |
|---|---|
| **AGENTS.md** | Workspace-wide conventions, preferences, things to always or never do |
| **Memory MCP** | References to external systems, user preferences, project context that applies across sessions |
| **Obsidian / Notion** | Domain knowledge that belongs with the specs or codebase docs |
| **Current spec/page** | Task-specific findings, deviations from plan, future work |

When unclear, ask the user. Don't guess the destination.

When routing to **AGENTS.md**, pick the right level:
- Always-applies, workspace-wide → **root AGENTS.md**
- Directory-specific conventions → **nested AGENTS.md** in that directory
- Deep domain workflows with side-effects → **skill** (`.agents/skills/`)
- Absolute deterministic, no-exception rules → **recommend a hook**, not an instruction

### 3. Write concise, actionable entries

Each entry must state:
- **What** — the rule or fact, one line
- **Why** — the reason (only if non-obvious; skip if self-evident)
- **How to apply** — when this kicks in (only if non-obvious)

Style: terse, no filler, lists over paragraphs, exact commands and file paths over "the appropriate command".

For entries routed to **AGENTS.md**:
- **Imperative, not advisory.** "Use X", "Never do Y" — not "prefer X", "be careful with Y".
- **Negative examples are as important as positive ones.** State what NOT to do with "never", "запрещено", "don't".
- **Deletion test:** if this line were removed, would the agent start making measurable mistakes? If not — omit.

### 4. Verify

Re-read each entry cold. Can a future fresh-context agent apply it without asking? If not, rewrite.

## Rules

- Don't document the obvious
- Don't duplicate across destinations — pick one home per learning
- Don't write aspirational content ("we should eventually...")
- Don't commit to AGENTS.md without showing the user the proposed diff
- Memory edits can happen directly (per memory usage guidelines in AGENTS.md)
- Never write without confirmation

For entries routed to **AGENTS.md**:
- Don't add rules for anything the agent can read from config files (`package.json`, `tsconfig.json`, `.eslintrc`)
- Don't add standard language/framework conventions already in training data
- Prefer hooks over instructions for absolute, no-exception rules
- Root AGENTS.md ≤ 200 lines. If approaching the limit — propose moving entries to nested AGENTS.md or skills
- Don't duplicate entries already in MEMORY.md unless they become team-wide conventions (then copy to AGENTS.md and remove from MEMORY.md)

## Output

```
## Session Learnings — <date>

### AGENTS.md additions
- <rule> — <why>

### Memory MCP
- <entity/observation to persist>

### Obsidian / Notion
- <page to update> — <what to add>

### Current spec
- <finding or deferral to record>
```

One-line summary to the user of what went where.
