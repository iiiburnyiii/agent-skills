# Final Note Fragments — Good vs Bad

Per-section fragments from the final note. Each block names the `SKILL.md` rule it depends on.

---

## `## Источники` — diversity and grouping

### Bad

```markdown
## Источники

- [Boox official site](https://www.boox.com)
- [PocketBook overview](https://pocketbook.com)
```

Problems:

- Only vendor primary pages → no independent verification.
- Misses three of four categories from `Source Policy → diversity`.
- Two entries — well under the 6+ threshold where grouping kicks in, but the diversity gap is the real failure.

### Bad — quantity without diversity

```markdown
## Источники

- [Boox official](https://www.boox.com/note-air4c)
- [Boox press release](https://www.boox.com/news/...)
- [Boox YouTube channel](https://youtube.com/@boox)
- [Boox blog post about Note Air](https://www.boox.com/blog/...)
- [Boox specs page](https://www.boox.com/note-air4c/specs)
- [Boox compared to itself](https://www.boox.com/compare)
- [Boox reseller listing](https://store.example.com)
- [Boox marketing thread](https://forum.boox.com/...)
```

Problems:

- Eight entries, but all from one vendor's ecosystem. Quantity ≠ diversity.
- Breaks `Source Policy → "Quantity is not the target. Three diverse, high-signal sources beat ten near-duplicate marketing pages"`.

### Good

```markdown
## Источники

### Primary

- [Boox Note Air4 C — specs page](https://www.boox.com/note-air4c)
- [PocketBook InkPad Color 3 — product page](https://pocketbook.com/...)
- [Kobo Libra Colour — product page](https://kobo.com/...)

### Reviews & Benchmarks

- [The eBook Reader — Boox Note Air4 C review (March 2026)](https://...)
- [Good e-Reader — PocketBook InkPad Color 3 hands-on (2026)](https://...)
- [Notebookcheck — display measurements, Kaleido 3 panels (2026)](https://...)

### Community

- [r/Boox — Note Air4 C battery thread](https://reddit.com/...)
- [mobileread forum — KOReader on Boox Note Air4 C sideload thread](https://...)
- [GitHub — KOReader issue #XXXX (PDF reflow regression on Kaleido 3)](https://github.com/...)

### Сравнения и обзоры

- [My Deep Guide — Best e-readers for PDF in 2026](https://youtube.com/...)
- [Habr — обзор compact e-readers 2026 для русскоязычного рынка](https://habr.com/...)
```

Why it works:

- All four `Source Policy` categories represented.
- Grouped because total count is ≥ 6 (`Placement` rule).
- Mix of vendor docs (specs), third-party reviews (independent verification), community (failure modes / sideload reality), and recent comparisons (peer overview).
- Russian-language source included where the user's region matters.

---

## `## Что Выбрать` — scenario-based recommendation

### Bad

```markdown
## Что Выбрать

Зависит от ваших потребностей. Если вам важна автономность — выбирайте автономную модель. Если важна цена — более бюджетную. Если важно качество экрана — модель с лучшим экраном.
```

Problems:

- Restates the criteria as the answer. The user came for a recommendation.
- No mapping from user profile to specific options.
- Breaks `Writing Style → "Be practical and balanced, not neutral to the point of being unhelpful"`.

### Good

```markdown
## Что Выбрать

> [!important] Главный практический вывод
> При бюджете ≤ $400, профиле PDF/EPUB 60/40 и требовании sideload Obsidian — **Boox Note Air4 C** под основной сценарий. PocketBook InkPad Color 3 — fallback при нежелании возиться с прошивкой.

Три сценария под близкие профили:

- **PDF-приоритет, готов настраивать прошивку, нужен Obsidian на устройстве** — Boox Note Air4 C. Open Android, sideload Obsidian работает (см. mobileread thread), PDF reflow приличный. Минусы: батарея 2-3 недели вместо заявленных 4, прошивка обновляется неровно.
- **EPUB-приоритет, минимум вмешательства, ок с экспортом заметок в vault вручную** — PocketBook InkPad Color 3. Цвет полезен для обложек, не для научных PDF. Vendor-lock мягче, чем у Kindle, но Obsidian только через десктоп.
- **Готов отказаться от цвета ради автономности и цены** — Kobo Libra Colour (моно-режим) или Kobo Clara BW. ~$280-310, недели на одной зарядке, экспорт заметок в Markdown через Pocket/Readwise.

Что **не** брать под этот профиль:

- Kindle Scribe / Paperwhite — закрытая экосистема, sideload Obsidian не поддерживается, дисквалификатор.
- reMarkable 2 — стилус-первый девайс, PDF без подсветки, выходит за бюджет.
```

Why it works:

- Decision-level conclusion in the callout, supported by scenario-mapped recommendations.
- Explicit dealbreakers under «Что не брать» — saves the user from re-evaluating already-rejected options.
- Each option's strengths and risks are named, not hidden behind «зависит от потребностей».

---

## Wikilinks and Candidates

### Bad

```markdown
В смежных нотах см. [[Электронные книги]], [[E-Ink]], [[KOReader]], [[Obsidian Mobile]], [[Чтение PDF]].
```

Problems:

- None of these `[[…]]` were verified during vault discovery. Each one is a phantom link if the note does not exist.
- Breaks `Vault Integration → "Treat a wikilink as confirmed only if you actually found a matching note in the vault"`.

### Good

```markdown
## Связанные

- [[Resources/Reading]]
- [[Resources/E-Readers - ресерч 2024]]
- [[Resources/Obsidian Mobile]]

В основном тексте forward-link candidates получают `[[wikilink]]` на первом смысловом упоминании: [[KOReader]], [[E-Ink Carta 1300]], [[Kaleido 3]], [[sideload Obsidian on Android]], [[front-light CCT]]. Отдельный раздел для них не нужен; список кандидатов фиксируется в плане.
```

Why it works:

- Only verified vault notes get `[[wikilinks]]`.
- Plausible-but-missing concepts are forward-linked once in prose, so backlinks work when dedicated notes are created later.
- The plan remains the record of which links were forward-link candidates rather than confirmed vault notes.

---

## `## Сравнение` — useful columns vs decorative columns

### Bad

| Модель | Цена | Внешний вид | Бренд | Цвет корпуса |
|---|---|---|---|---|
| Boox Note Air4 C | $400 | стильный | Boox | чёрный |
| PocketBook InkPad Color 3 | $370 | классический | PocketBook | серый |

Problems:

- «Внешний вид», «Бренд», «Цвет корпуса» do not affect the decision and are not in the criteria from the plan.
- The columns that matter — sideload Obsidian, PDF reflow, autonomy — are absent.
- Breaks `Quality Checklist → "Tables have useful criteria rather than decorative columns"`.

### Good

| Модель | Цена | Диагональ | PDF reflow | Obsidian sideload | Front-light CCT | Автономность (обзоры) | Vendor-lock |
|---|---|---|---|---|---|---|---|
| Boox Note Air4 C | $399 | 7.8" Kaleido 3 | приличный | да (open Android) | да | 2-3 нед. | низкий |
| PocketBook InkPad Color 3 | $369 | 7.8" Kaleido 3 | средний | только через десктоп | да | ~3 нед. | средний |
| Kobo Libra Colour | $230 | 7" Kaleido 3 | слабый для научных PDF | нет | да | ~4 нед. | средний (Pocket/Readwise) |
| Kindle Scribe | $400 | 10.2" mono | хороший | **нет** (дисквалификатор) | да | ~5 нед. | высокий |

Why it works:

- Every column maps to a criterion declared in the plan.
- Disqualifiers (Kindle: no sideload) are visible in the comparison instead of being hidden in prose.
- Autonomy is attributed to «обзоры», signalling that this is third-party data, not vendor spec.

---

## `## Расхождения В Источниках`

### Bad — silent averaging

Body of note:

```markdown
Автономность Boox Note Air4 C — около 3 недель.
```

Sources behind this: vendor claims «до 4 недель»; The eBook Reader review «2-3 недели в типичных сценариях»; r/Boox threads «7-10 дней с включённой подсветкой и Wi-Fi».

Problems:

- Picks an unannotated midpoint.
- User cannot judge confidence without re-reading sources.
- Breaks `Source Policy → "Do not silently average or pick a side without saying so"`.

### Good — inline attribution (single minor conflict)

```markdown
Автономность Boox Note Air4 C расходится: вендор заявляет «до 4 недель», The eBook Reader получили 2-3 недели в смешанном сценарии, в r/Boox чаще встречается 7-10 дней при включённой подсветке и активной Wi-Fi-синхронизации. Реалистичный ориентир для PDF-нагрузки — около 10-14 дней.
```

### Good — dedicated section (≥2 material conflicts)

```markdown
## Расхождения В Источниках

Два материальных расхождения, влияющих на выбор:

- **Автономность Boox Note Air4 C.** Вендор — «до 4 недель»; The eBook Reader — 2-3 недели; r/Boox — 7-10 дней при тяжёлой нагрузке. В шортлисте использую консервативные 10-14 дней.
- **Качество PDF reflow на Kaleido 3.** Good e-Reader называет его «приличным», тогда как issue в KOReader (#XXXX) описывает регрессию на двухколоночных научных PDF. Под профиль научных статей это сдвигает рекомендацию в сторону Boox с open Android (можно поставить альтернативный reader), а не PocketBook.

Если у тебя другая нагрузка (тонкие EPUB-художки, мало PDF) — оба расхождения становятся несущественными, и PocketBook поднимается выше.
```

Why it works:

- Each conflict names *who says what* and *how it shifts the recommendation*.
- The section is conditional — it appears only when ≥ 2 material contradictions exist (`SKILL.md → Default Note Structure`).
- Tells the reader when the section can be ignored (different load → no impact), so it is not noise for unrelated profiles.
