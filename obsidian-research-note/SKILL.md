---
name: obsidian-research-note
description: "Create or update practical Obsidian research notes in the user's vault using vault discovery, web research, source verification, wikilinks, categories, tags, and decision-oriented recommendations. Use for requests to research, compare, choose, shortlist, review options, make a buying guide, or turn web findings into an Obsidian note."
---

# Obsidian Research Note

Use this skill to create practical research notes for an Obsidian vault, matching the style of existing notes in `Resources/` folder.

The target output is not an academic report. It is a useful decision document: clear context, explicit criteria, shortlist, tradeoffs, risks, recommendation, and sources.

## Obsidian Tooling

When available, prefer Obsidian-specific tooling instead of treating the vault as a plain file tree:

- Use the `obsidian-cli` skill for vault-aware search, reading notes, creating notes, appending content, inspecting backlinks, and working with properties when the task involves a running Obsidian vault.
- Use the `obsidian-markdown` skill when creating or editing the final note so the result stays valid Obsidian-flavored Markdown.
- If the research output needs to connect to Obsidian-specific structures such as Bases or Canvas, use the matching Obsidian skills instead of inventing ad-hoc formats.

Prefer Obsidian-aware operations whenever they better preserve vault conventions, note identity, wikilinks, and metadata.

## Preferred Tools

Use the most appropriate tool for each step.

- **Vault discovery:** prefer `obsidian-cli` for note-aware search, backlinks, properties, and vault context. Use file search tools when the CLI is unavailable or when broad repo search is faster.
- **Note structure and final writing:** use `obsidian-markdown` so frontmatter, callouts, wikilinks, and tables stay valid for Obsidian.
- **Web research:** use `web_search` with `queries: [...]` for current information, especially on fast-moving topics. Prefer 2-4 varied search angles over one generic query.
- **Reading articles/docs/pages:** prefer `defuddle` for clean extraction of web pages before summarizing them into the note. Use `fetch_content` when a page, repo, or video needs close reading.
- **Obsidian-native structures:** if the result should integrate with Bases or Canvas, use `obsidian-bases` or `json-canvas` rather than inventing custom formats.

If a preferred tool is unavailable, fall back gracefully to general-purpose tools without changing the workflow expectations.

For web research, do not cite a source unless you opened, extracted, or otherwise inspected enough content to support the cited claim. Search snippets are leads, not evidence.

## Interaction Modes

Default mode is careful and interactive: vault discovery, clarifying questions, plan, user confirmation, then writing.

Use a lighter path when the user asks for a quick note, overview, or draft; when the topic is evergreen rather than a decision; or when missing details do not materially change the research direction. In light mode, ask at most 3-5 high-impact questions or state assumptions in the plan.

Use autonomous mode when the user says «сразу сделай», «без уточнений», «skip confirmation», «автономно», or equivalent. Still discover vault context first, state assumptions compactly, create or update the note, then report verification and unresolved assumptions.

## Core Workflow

1. Discover the current vault before anything else.
   - Run the vault-discovery checklist (below) to find existing notes, categories, tags, English names, and prior snapshots.
   - Build a compact link map: existing notes to link, likely parent categories, related concepts, and possible duplicate or overlapping notes.
   - Treat a wikilink as confirmed only if you actually found a matching note in the vault.
   - Prefer existing wikilinks for categories and related concepts instead of inventing new names.
   - If no exact note exists but the concept is a product, tool, technology, or proper name that may deserve a note later — mark it as a forward-link candidate. These still get wikilinks in the final note (so connections light up when the note is created), but list them in the plan under `Кандидаты` to distinguish from confirmed notes.
   - If a likely target note already exists, treat the task as a potential update and surface that option in the clarification step.

   **Vault-discovery checklist** — run as many of these as the topic warrants before producing a plan:
   - Search by Russian title variants with common morphology (root forms, plurals, synonyms).
   - Search by English product, tool, technology, and standard names.
   - Search by tag `resources/research` plus the likely domain tag.
   - Inspect backlinks on probable parent-category notes (`[[Category]]`).
   - Search by individual product/option names when this is a comparison.
   - Check for prior-year snapshots (`* - ресерч YYYY-1.md` or similar) and decide whether to update or supersede.
   - Check neighbouring conceptual notes that may already cover the topic.

2. Clarify before planning.
   - Run a dedicated clarification round before drafting the plan. Ask about every material dimension whose answer is not obvious from the request or vault context — see `Plan Format` for the materiality bar and required checklist.
   - It is better to ask many questions up front than to assume and produce a misaligned note.
   - Group questions thematically. Where a sensible default exists, state it explicitly so the user can confirm or override quickly.
   - For each existing-note candidate found in §1, ask whether to update it or create a new note.
   - See `examples/clarifying-questions.md` for good/bad patterns.

3. Produce the research plan after answers come in.
   - Use the structure in `Plan Format`. The `Ответы на уточнения` field reflects the answers from §2.
   - Do not create or edit the final note until the user confirms the plan, unless they explicitly asked to skip confirmation or use autonomous mode.
   - See `examples/plan-good-vs-bad.md` for a full good/bad pair.

4. Do the web research after the plan is confirmed.
   - Use current web sources for fast-changing topics: software, hardware, prices, models, specs, availability, ecosystems.
   - For evergreen topics, use authoritative sources and avoid over-indexing on the current year.
   - Aim for diverse coverage across source categories — see `Source Policy`.
   - If sources contradict each other on a material point, capture the conflict; do not silently average.

5. Write the note in Obsidian-flavored Markdown.
   - Use YAML properties, wikilinks, tables, and callouts where they improve readability.
   - Do not manually set `created` or `updated`; vault automation manages them.
   - When a folder has Templater automation, prefer the vault-aware creation path when available, then edit only user-controlled properties such as `categories` and `tags`.
   - Save under `Resources/` by default unless a more specific existing subfolder is clearly better or the user explicitly requested a different path.
   - For updates of existing notes, preserve current links and structure; summarise what is changing and why before applying.

6. Verify the finished note.
   - Run the full validation pass in `references/validation.md`: structural integrity, sources, wikilinks, web links, moderate brevity, and readability.
   - For updates: confirm previously valid wikilinks were not broken.
   - Inspect the final changed note or diff and report the note path plus unresolved assumptions.

## Plan Format

The plan is the output of a two-step interaction: a clarification round first (Core Workflow §2), then the plan that reflects those answers.

Present the plan with this checklist:

```markdown
## План ресерча

- **Тема:** <working title>
- **Цель:** <what decision or understanding the note should enable>
- **Критерии:** <3-7 comparison criteria, each measurable when possible>
- **Метаданные:** `categories`, `tags`, target path
- **Связи:** <confirmed existing notes/categories to link>
- **Кандидаты:** <products, tools, technologies, proper names that don't have notes yet but get forward-linked in the final note>
- **Структура:** <proposed section outline>
- **Источники:** <source types/search directions, broken down by category; mention freshness assumptions>
- **Ответы на уточнения:** <summary of the user's answers to the clarification round, including defaults you assumed>
- **Конфликты в источниках:** <optional — list any contradictions visible at planning time>
```

### Materiality bar for clarifying questions

Set the bar low. Ask about every dimension whose answer is not obvious from the request or vault context. "Obvious" means explicitly stated by the user or unambiguously implied by the wording. When in doubt, ask.

Required clarification topics — go through each one and ask unless the answer is already given:

- **Budget / price range** (for buying decisions).
- **Region / market** (availability, regional pricing, regulatory or shipping limits).
- **Platform / OS / ecosystem** (macOS/Linux/Windows/iOS/Android, Apple Silicon vs Intel, container runtime, etc.).
- **Primary use case** plus secondary use cases.
- **Existing setup and integrations** — current tools, workflows, vault structure, ecosystem the user is locked into.
- **Hard constraints / dealbreakers** — what disqualifies an option immediately.
- **Freshness expectation** — current-year snapshot vs evergreen reference.
- **Scope** — short shortlist (top 3) vs deeper comparison (5-10 options).
- **Update vs create** — if a likely existing note was found in vault discovery.
- **Decision horizon** — choice for now vs 3-year outlook.
- **Opinion level** — hedged neutral overview vs opinionated recommendation.

Where you can offer a sensible default, state it: «по умолчанию приму X, поправь если не так». This lets the user skim and only correct cases where the default is wrong.

For non-decision evergreen notes, skip buying-specific questions such as budget, region, and platform unless they affect the research outcome.

See `examples/clarifying-questions.md` for good/bad patterns.

## Metadata Conventions

Follow the vault's existing research-note conventions:

```yaml
---
categories:
  - "[[Category]]"
tags:
  - resources/research
  - <domain/tag>
---
```

Guidelines:

- Use `resources/research` for research notes.
- Propose `categories` and `tags` in the plan before writing.
- Choose the note title according to vault naming conventions: technical notes use English Title Case; Russian inbox or evergreen notes use descriptive Russian titles.

## Default Note Structure

Adapt the structure to the topic, but keep this backbone when it fits:

```markdown
# <Title>

## Контекст

<User scenario, constraints, criteria, assumptions.>

> [!important] Главный практический вывод
> <The decision-level conclusion in 1-3 sentences.>

## Короткий Шортлист

<Ranked list or compact table of top options.>

## Сравнение

<Comparison table with criteria relevant to the decision.>

## Детальный Шортлист

<Per-option notes: why it matters, strengths, risks, fit.>

## Что Выбрать

<Scenario-based recommendation.>

## Практические Замечания

<Operational caveats, buying/usage tips, migration notes, testing advice.>

## Расхождения В Источниках

<Optional. Include only when two or more material contradictions in sources affect the recommendation. Summarise what disagrees, who says what, and how it shifts the choice. For a single minor contradiction, use inline attribution in the relevant section instead.>

## Предварительный Рейтинг Под Запрос

<Optional. Include only when (a) the user explicitly asked for a ranking, or (b) the topic is naturally scored — benchmarks, official ratings, measurable performance. Otherwise omit.>

## Источники

- [Source title](https://example.com)
```

Use alternative section names when they better fit the domain. For example, software tools may need `## Для Личного Использования`, `## Для Работы`, or `## Что Тестировать Перед Выбором`; hardware buying guides may need `## Рекомендованные Связки`.

If the topic is not a choice or comparison, replace shortlist sections with sections such as `## Основная Идея`, `## Карта Понятий`, `## Что Важно Запомнить`, `## Практическое Применение`, and `## Открытые Вопросы`.

## Writing Style

- Write primarily in Russian.
- Use English names for products, tools, standards, and APIs when that improves searchability.
- Be practical and opinionated, not neutral to the point of being unhelpful.
- State assumptions explicitly when the user's context is incomplete.
- Prefer concise paragraphs, ranked lists, and comparison tables.
- Include risks and disqualifiers, not only pros.
- Avoid marketing language and generic filler.
- Avoid pretending certainty when sources are weak, stale, or contradictory.

## Source Policy

### Diversity is the goal, not count

A research note should rest on sources from several categories. Cover at least three of the four when sources are available:

1. **Primary sources** — official docs, specs, release notes, vendor pricing, platform support matrices, capability lists.
2. **Reputable reviews and benchmarks** — independent reviews, measurement-based comparisons, benchmark suites, hardware/software publications with editorial standards.
3. **Community signal** — forum threads, Reddit/HN discussions, GitHub issues, Discord/Telegram threads, real-user reports. Useful for failure modes, longevity, and tradeoffs primary docs hide.
4. **Recent comparison articles** — third-party comparisons published in the relevant year for fast-moving topics.

Quantity is not the target. Three diverse, high-signal sources beat ten near-duplicate marketing pages. Do not hoard sources to inflate the list; if a category has nothing strong, say so.

If coverage of a required category is thin or missing, name the gap in the plan and in the note rather than papering over it.

### Currency and primacy

- Use current sources for fast-changing topics. Search with the current year when appropriate.
- Prefer primary sources for specs, pricing, docs, release status, platform support, and official capabilities.
- Prefer independent reviews, measurements, benchmarks, issue trackers, and community discussions when you need real-world tradeoffs that vendors will not surface.

### Conflict handling

When sources contradict each other on something that affects the recommendation:

- Do not silently average or pick a side without saying so.
- For minor contradictions, mention them inline with brief attribution: «По DPReview ~14 дней; в обсуждениях Reddit — 7-10 при тяжёлой нагрузке».
- For two or more material contradictions, add a `## Расхождения В Источниках` section near the top of the note (see Default Note Structure) summarising what disagrees, who says what, and how it shifts the recommendation.

### Placement

- Keep external links in `## Источники` by default.
- When `## Источники` has 6+ entries, group them with subheadings: `### Primary`, `### Reviews & Benchmarks`, `### Community`, `### Сравнения и обзоры`. Below 6 entries a flat list is fine.
- Add inline links only for claims that are especially important, surprising, disputed, or likely to change.

### Honesty

- Never invent sources. If source coverage is thin, say so in the note or plan.
- If a source could not be accessed or read, drop it from `## Источники` rather than guessing at its contents.

See `examples/note-fragments-good-vs-bad.md` for source-section and conflict-handling examples.

## Vault Integration

### Wikilink rules

- Use `[[wikilinks]]` for internal concepts, categories, tools, and related notes that exist in the vault or are clearly stable enough to deserve a note.
- **Products, tools, technologies, and proper names get wikilinks on first occurrence even if a dedicated note doesn't exist yet.** When the note is created later, backlinks connect automatically. Prefer the most natural note name: `[[Claude Code]]`, `[[ESLint]]`, `[[Zod]]`.
- Use pipe display text when the visible text should differ from the note name: `[[PostgreSQL|Postgres]]`, `[[Anthropic|Антропик]]`.
- Do not wikilink generic concepts or common nouns — only named things that could plausibly become a standalone note.
- Do not wikilink the same term twice. First occurrence only (excluding frontmatter).
- Reuse existing categories and tag style where possible.

### Plan and discovery

- Before creating a note, explicitly research existing notes so links are based on the user's current knowledge graph, not generic assumptions.
- In the plan, `Связи` lists only confirmed existing notes/categories.
- Forward-link candidates (products/tools/tech without notes yet) go under `Кандидаты` in the plan.
- In the final note, forward-linked candidates appear as regular `[[wikilinks]]` in prose — no separate section needed. Their presence in the plan's `Кандидаты` is the record.
- If you are unsure whether a note exists or whether a term is notable enough for a future note, ask. Don't guess.
- Do not modify unrelated notes unless the user explicitly asks.

See `examples/note-fragments-good-vs-bad.md` for wikilink and candidate-section examples.

## Quality Checklist

The finishing checklist lives in `references/validation.md` (sections E and F cover brevity, readability, and decision quality). Run it as part of Core Workflow §6.
