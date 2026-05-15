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

### 3. Write concise, actionable entries

Each entry must state:
- **What** — the rule or fact, one line
- **Why** — the reason (only if non-obvious; skip if self-evident)
- **How to apply** — when this kicks in (only if non-obvious)

Style: terse, no filler, lists over paragraphs, exact commands and file paths over "the appropriate command".

### 4. Verify

Re-read each entry cold. Can a future fresh-context agent apply it without asking? If not, rewrite.

## Rules

- Don't document the obvious
- Don't duplicate across destinations — pick one home per learning
- Don't write aspirational content ("we should eventually...")
- Don't commit to AGENTS.md without showing the user the proposed diff
- Memory edits can happen directly (per memory usage guidelines in AGENTS.md)
- Never write without confirmation

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
