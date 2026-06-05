# Validation (post-write QA pass)

Read this when verifying a finished research note — during Core Workflow §6, or when the user asks to validate, check, QA, lint, or review an existing note.

## Mode

- Fix mechanical issues directly: malformed link syntax, duplicate wikilinks, broken wikilink targets, title/H1/filename mismatch, invalid frontmatter.
- Propose brevity and readability edits as suggestions; do not apply them silently — they change meaning and tone.
- Never drop a source, risk, disqualifier, or source conflict to make the note shorter.
- Touch only what validation flags. Do not refactor unrelated prose or restructure sections.

## Tooling

- Use `obsidian-cli` to resolve wikilinks and inspect backlinks. A wikilink is valid only if it resolves to a real note or is an intentional forward-link candidate.
- Live web-link reachability (HTTP/fetch) is off by default — slow and prone to false 403/timeout. Check format and placement only; run live checks (`defuddle`/`fetch_content`) only when the user explicitly asks.

## A. Structural integrity

- Frontmatter is valid YAML.
- The note title, the H1, and the filename are consistent.
- `categories` are wikilinks to `System/Categories/` notes, not bare strings; `tags` follow vault namespacing.

## B. Sources and claims

- No fabricated sources. Drop any source that can't be confirmed rather than guessing its contents.
- Source coverage satisfies the diversity rule in `Source Policy`; name thin or missing categories honestly instead of papering over them.
- External links live in `## Источники`; inline links only for important, surprising, disputed, or volatile claims.
- The recommendation follows from the stated criteria.

## C. Wikilinks

Verify against the Wikilink rules in `SKILL.md`:

- Every product, tool, technology, and proper name is wikilinked on its first prose occurrence (not in code blocks, not in frontmatter).
- No term is wikilinked more than once.
- Generic concepts and common nouns are not wikilinked.
- Each link resolves to an existing note or is a deliberate forward-link candidate; report links that are neither.
- Pipe display text is used where the visible text differs from the note name.
- For updates: previously valid wikilinks were not broken.

## D. Web links

- Markdown link syntax is well-formed; no bare URLs where a titled link is expected.
- Anchor text is descriptive, not "click here" or a raw URL.
- No duplicate links to the same URL in `## Источники`.
- With 6+ entries, `## Источники` is grouped (`### Primary`, `### Reviews & Benchmarks`, `### Community`, `### Сравнения и обзоры`); below 6 a flat list is fine.

## E. Moderate brevity

Goal is moderate, not aggressive. Cut padding, keep substance.

- Flag for removal: filler words, marketing language, generic boilerplate, re-narration of what a table already shows, and any conversation bleed (references to the request, the session, or the chat).
- Preserve technical precision, numbers, risks, disqualifiers, and source conflicts. Brevity never means losing a finding.
- Prefer one sentence over a paragraph that repeats itself, but keep context the note needs to stand alone in six months.
- Output cuts as suggestions with rationale, not silent edits.

## F. Readability

- The note answers the user's actual decision or research question.
- The decision-level conclusion is visible near the top (e.g. the `> [!important]` callout) and supported later.
- Section order is scannable: context → shortlist → comparison → detail → recommendation.
- Comparison tables have decision-relevant criteria, not decorative columns.
- Headings are meaningful and match the content under them.
- The note stands alone months later: context, assumptions, and source freshness are understandable without the originating conversation.

## Report format

Produce a compact report grouped by action, then apply the mechanical fixes:

```markdown
## Validation: <note title>

### Fixed (mechanical)
- <what was fixed and where>

### Suggested cuts (need confirmation)
- <location>: <quote or paraphrase> → why it can go

### Flags (judgment / can't auto-resolve)
- <unresolved wikilink, thin source category, weak recommendation, etc.>
```

Omit empty sections. Attach evidence (a quote, a line reference) only to flags and surprises; passed checks get at most one summary line. If everything passes, say so in one line.
