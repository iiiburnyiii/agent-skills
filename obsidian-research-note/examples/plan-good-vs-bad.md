# Plan — Good vs Bad

Same topic, same hypothetical user answers, two plans. The contrast shows what `Plan Format` requires beyond surface compliance.

Scenario assumptions (answered in the clarification round):

- Budget ≤ $400.
- Region: Russia / EU import.
- Primary use: reading PDF research papers + EPUB fiction, ratio ~60/40.
- Annotations: highlights and short typed notes; no stylus required.
- Ecosystem: Obsidian via Android sideload preferred; vendor lock-in unacceptable.
- Freshness: 2026 snapshot.
- Scope: shortlist of 5.
- Update vs create: existing `Resources/E-Readers - ресерч 2024.md` found in vault; user chose **create new** for 2026.
- Tone: balanced.

---

## Bad plan

```markdown
## План ресерча

- **Тема:** Электронные книги
- **Цель:** Выбрать электронную книгу
- **Критерии:** хороший экран, нормальная цена, удобство, автономность
- **Метаданные:** categories — [[Электронные книги]]; tags — `resources/research`, `gadgets`; путь — Resources/
- **Связи:** [[Электронные книги]], [[Чтение]]
- **Кандидаты:** —
- **Структура:** Контекст, Сравнение, Что выбрать, Источники
- **Источники:** обзоры, сайты производителей
- **Вопросы:** Какой бюджет?
```

What is wrong:

- **Тема / Цель / Критерии** are too vague to discriminate options. «Хороший экран» does not exclude anything; «нормальная цена» dodges the budget that the user already named.
- **Метаданные**: `[[Электронные книги]]` is presented as confirmed without checking whether it exists in the vault — likely a phantom link. Title in the plan is generic.
- **Связи** mixes confirmed and unconfirmed wikilinks. `Plan Format` requires only confirmed entries here.
- **Кандидаты** is empty even though `[[Чтение]]`, `[[E-Ink]]`, `[[KOReader]]` and the existing `Resources/E-Readers - ресерч 2024.md` are obvious candidates to flag.
- **Структура** drops sections the topic needs: shortlist, detailed shortlist, practical notes.
- **Источники** is one undifferentiated word — fails `Source Policy → diversity`.
- **Вопросы** asks one item already answered in clarification. The plan should reflect answers in `Ответы на уточнения`, not re-ask them.
- No mention of the existing 2024 note found during vault discovery; the user's choice to create-new vs update is invisible.

---

## Good plan

```markdown
## План ресерча

- **Тема:** Compact e-readers for PDF + EPUB with Obsidian-friendly workflow (snapshot 2026)
- **Цель:** Выбрать конкретную модель ридера под профиль: 60% PDF научных статей, 40% EPUB художки, типизированные заметки, сайдлоад Obsidian, бюджет ≤ $400, без вендор-лока.
- **Критерии:**
  - Диагональ 7-8" (компромисс между переносимостью и читабельностью PDF без зума).
  - Поддержка PDF без обязательной конвертации, с reflow или приличной навигацией по двухколоночной вёрстке.
  - Open Android или иной способ установить Obsidian / KOReader без джейлбрейка.
  - Front-light с регулировкой температуры.
  - Автономность ≥ 2 недель при ~1 ч/день при включённой подсветке.
  - Цена ≤ $400 с учётом доставки в РФ/ЕС.
  - Отсутствие жёсткого вендор-лока (нет принудительного облака, нельзя выпилить из устройства).
- **Метаданные:**
  - `title`: «Compact E-Readers 2026»
  - `categories`: `[[Resources/Reading]]` (подтверждена в vault)
  - `tags`: `resources/research`, `hardware/e-reader`
  - target path: `Resources/Compact E-Readers 2026.md`
- **Связи (подтверждены в vault):**
  - `[[Resources/Reading]]`
  - `[[Resources/E-Readers - ресерч 2024]]` (предыдущий снапшот; сошлюсь на него в `## Контекст`)
  - `[[Resources/Obsidian Mobile]]`
- **Кандидаты (не существуют в vault, получат forward-links на первом упоминании):**
  - KOReader, Obsidian-on-Android sideload, E-Ink Carta 1300, frontlight CCT.
- **Структура:**
  - Контекст (профиль, ограничения, что изменилось с 2024)
  - Главный вывод (callout)
  - Короткий шортлист (5 моделей, табличка)
  - Сравнение (критерии × модели)
  - Детальный шортлист (per-model: сильные стороны, риски, fit к профилю)
  - Что выбрать (3 сценария: PDF-приоритет, EPUB-приоритет, гибкость)
  - Практические замечания (импорт, прошивки, sideload-гайд)
  - Расхождения в источниках (если выявятся материальные)
  - Источники (сгруппированные)
- **Источники (по категориям):**
  - **Primary**: страницы продуктов Boox, PocketBook, Kindle, Kobo, reMarkable; release notes по прошивкам 2025-2026.
  - **Reviews & Benchmarks**: The eBook Reader, Good e-Reader, Notebookcheck, German DPReview-аналог, измерения времени отклика и точки белого.
  - **Community**: r/eink, r/Boox, mobileread forums, GitHub issues KOReader, Telegram-каналы по ридерам (рус.).
  - **Сравнения и обзоры 2026**: сводные обзоры YouTube-каналов (My Deep Guide, Joel Goodman), сравнительные статьи 2026 года.
  - **Freshness assumption**: цены и ассортимент проверяю на текущий месяц 2026; модели старше 2024 включаю только при отсутствии замены.
- **Ответы на уточнения:**
  - Бюджет ≤ $400, регион Россия + EU import.
  - PDF/EPUB 60/40, типизированные заметки, без стилуса.
  - Obsidian sideload обязателен; вендор-лок — дисквалификатор.
  - 2026 snapshot, шортлист 5, balanced тон.
  - В vault найдена `Resources/E-Readers - ресерч 2024.md` — пользователь выбрал **создать новую заметку** для 2026, на старую сошлюсь.
  - Front-light с регулировкой температуры: обязательно.
- **Конфликты в источниках:** на этапе плана значимых нет; если всплывут (типично — автономность по обзорам vs практике форумов) — отражу инлайн или в отдельной секции.
```

Why it works:

- **Тема / Цель** map directly to the user's actual decision, not a generic restatement.
- **Критерии** are measurable: дюймы, недели автономности, ценовая граница, конкретные технические требования.
- **Метаданные** declare which wikilinks are confirmed and which are candidates, honouring `Vault Integration`.
- **Связи** contain only nodes verified during vault discovery; everything else is parked in **Кандидаты**.
- **Структура** anticipates the optional `Расхождения В Источниках` section without adding a separate candidate section.
- **Источники** is split by category and honours `Source Policy → diversity`; ratio across primary/reviews/community/comparisons is balanced.
- **Ответы на уточнения** records the user's answers so the plan can be confirmed at a glance.
- **Конфликты в источниках** is present even when empty, to signal that the dimension is being watched.
- The existing 2024 note is named explicitly and the user's create-new decision is reflected in the path and title.
