---
name: obsidian-research-note
description: "Create high-quality Obsidian research notes in the user's `Resources/` vault by combining web research with vault context. Use this skill whenever the user wants to research, compare, choose, shortlist, review, or create/update a \"ресерч\" note, especially for notes under `Resources/`, software or hardware comparisons, buying decisions, current-year overviews, or Russian Obsidian notes with sources. Trigger this skill even when the user phrases the task loosely, for example: \"разобраться\", \"сравнить варианты\", \"выбрать\", \"сделать ресерч\", or \"собрать заметку\"."
---

# Obsidian Research Note

Use this skill to create practical research notes for an Obsidian vault, matching the style of existing notes such as `Resources/* - ресерч YYYY.md`.

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
- **Web research:** use `websearch` for current information, especially on fast-moving topics.
- **Reading articles/docs/pages:** prefer `defuddle` for clean extraction of web pages before summarizing them into the note.
- **Obsidian-native structures:** if the result should integrate with Bases or Canvas, use `obsidian-bases` or `json-canvas` rather than inventing custom formats.

If a preferred tool is unavailable, fall back gracefully to general-purpose tools without changing the workflow expectations.

## Core Workflow

1. Research the current vault before writing.
   - Search `Resources/` and adjacent vault areas for related notes, categories, tags, aliases, and naming patterns.
   - Build a compact link map: existing notes to link, likely parent categories, related concepts, and possible duplicate or overlapping notes.
   - Treat a wikilink as confirmed only if you actually found a matching note in the vault.
   - Prefer existing wikilinks for categories and related concepts instead of inventing new names.
   - If no exact note exists but a related concept may deserve a note later, keep it out of confirmed links and mention it separately as a candidate.
   - If a likely target note already exists, ask whether to update it or create a new one.
2. Produce a short research plan before creating or editing the note.
   - Do not create the final note until the user confirms the plan, unless they explicitly asked to skip confirmation.
   - Keep the plan concise and actionable.
3. Research with both web and vault context.
   - Use current web sources for fast-changing topics like software, hardware, prices, models, specs, availability, and tool ecosystems.
   - Use vault context for categories, tags, related concepts, and prior preferences.
   - For evergreen topics, use authoritative sources and avoid over-indexing on the current year.
4. Write the note in Obsidian-flavored Markdown.
   - Use YAML properties, wikilinks, tables, and callouts where they improve readability.
   - Save under `Resources/` by default unless a more specific existing subfolder is clearly better or the user explicitly requested a different path.
5. Verify the finished note.
   - Check that frontmatter is valid YAML.
   - Check that the title and first H1 match.
   - Check that sources exist and are not fabricated.
   - Check that the recommendation follows from the stated criteria.

## Plan Format

Before writing the final note, present this checklist:

```markdown
## План ресерча

- **Тема:** <working title>
- **Цель:** <what decision or understanding the note should enable>
- **Критерии:** <3-7 comparison criteria>
- **Метаданные:** `categories`, `tags`, `aliases`, target path
- **Связи:** <confirmed existing notes/categories to link>
- **Кандидаты:** <possible future notes or uncertain concepts that were not found as existing notes>
- **Структура:** <proposed section outline>
- **Источники:** <source types/search directions; mention freshness assumptions>
- **Вопросы:** <only questions that materially change the output>
```

Keep the questions few. Ask only about constraints that materially change the note: budget, region, platform, use case, non-negotiable requirements, or whether to update an existing note.

## Metadata Conventions

Follow the vault's existing research-note conventions:

```yaml
---
title: <Russian title> - ресерч <year>
categories:
  - "[[Category]]"
tags:
  - resources/research
  - <domain/tag>
aliases:
  - <English alias or alternative title>
created: YYYY-MM-DDTHH:mm
updated: YYYY-MM-DDTHH:mm
---
```

Guidelines:

- Use `resources/research` for research notes.
- Propose `categories` and `tags` in the plan before writing.
- Prefer Russian titles for the note body and English aliases for discoverability.
- Use `categories: "[[Single Category]]"` only if that style is already dominant in nearby notes; otherwise use a YAML list for multiple categories.
- Use the current year in the title when freshness matters. If the topic is evergreen, omit the year unless the user asks for a current-year snapshot.
- Use local ISO-like timestamps consistent with the vault, e.g. `2026-04-27T14:17`.

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

## Предварительный Рейтинг Под Запрос

<Optional scored ranking when the topic is evaluative.>

## Источники

- [Source title](https://example.com)
```

Use alternative section names when they better fit the domain. For example, software tools may need `## Для Личного Использования`, `## Для Работы`, or `## Что Тестировать Перед Выбором`; hardware buying guides may need `## Рекомендованные Связки`.

## Writing Style

- Write primarily in Russian.
- Use English names for products, tools, standards, APIs, and aliases when that improves searchability.
- Be practical and opinionated, not neutral to the point of being unhelpful.
- State assumptions explicitly when the user's context is incomplete.
- Prefer concise paragraphs, ranked lists, and comparison tables.
- Include risks and disqualifiers, not only pros.
- Avoid marketing language and generic filler.
- Avoid pretending certainty when sources are weak, stale, or contradictory.

## Source Policy

- Use current sources for fast-changing topics. Search with the current year when appropriate.
- Prefer primary sources for specs, pricing, docs, release status, platform support, and official capabilities.
- Prefer reputable reviews, measurements, benchmarks, issue trackers, and community discussions when you need real-world tradeoffs.
- Keep external links in `## Источники` by default.
- Add inline links only for claims that are especially important, surprising, disputed, or likely to change.
- Never invent sources. If source coverage is thin, say so in the note or plan.

## Vault Integration

- Use `[[wikilinks]]` for internal concepts, categories, tools, and related notes that exist in the vault or are clearly stable enough to deserve a note.
- Do not over-link every term. Link only concepts useful for navigation.
- Reuse existing categories and tag style where possible.
- Before creating a note, explicitly research existing notes so links are based on the user's current knowledge graph, not generic assumptions.
- In the plan, include a compact `Связи` line with only confirmed existing notes/categories.
- If you are unsure whether a note exists, verify first. If verification is incomplete, say so explicitly instead of presenting the link as real.
- Put non-existing but plausible future notes under `Кандидаты`, not under `Связи`.
- In the final note, prefer links discovered in the vault over newly invented links. Do not create speculative wikilinks by default.
- Do not modify unrelated notes unless the user explicitly asks.

## Quality Checklist

Before finishing, ensure:

- The note answers the user's actual decision or research question.
- The recommendation is visible near the top and supported later.
- Tables have useful criteria rather than decorative columns.
- Tradeoffs and risks are explicit.
- The note can stand alone months later: context, assumptions, and source date/freshness are understandable.
- The file path, frontmatter title, and H1 are consistent.
