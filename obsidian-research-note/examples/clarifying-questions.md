# Clarifying Questions — Good vs Bad

Scenario: user asks «помоги выбрать компактную электронную книгу на 2026 год, хочу читать PDF и EPUB и делать пометки».

The clarification round runs **before** the plan. The bar is the materiality checklist in `SKILL.md → Plan Format`. Go through every item; ask unless the answer is obvious from the request or vault context.

---

## Bad 1: one vague question

```text
Какой у вас бюджет?
```

Why it is bad:

- Skips ten other material dimensions (region, OS integration, screen size, PDF handling, secondary use, decision horizon, etc.).
- Forces the user to guess what else matters and volunteer it, or accept silent assumptions.
- Breaks `Plan Format → materiality bar`: «ask about every dimension whose answer is not obvious».

---

## Bad 2: empty "tell me more"

```text
Уточните задачу подробнее, тогда я смогу помочь.
```

Why it is bad:

- Pushes all framing work back to the user.
- Tells nothing about what the assistant already inferred or what is still unknown.
- A user who knew which dimensions matter would not have asked vaguely in the first place.

---

## Bad 3: straight to plan without asking

```text
Хорошо, делаю план: бюджет $200-300, экран 6", только EPUB, Россия...
```

Why it is bad:

- Invents constraints (budget, region, format support) and presents them as user-stated.
- Sets the user up to discover misalignment only after the note is written.
- Breaks `Core Workflow §2`: «better to ask many questions up front than to assume».

---

## Good: thematic checklist with declared defaults

```text
Прежде чем составить план, прохожу по чек-листу — отметь, где значения отличаются от моих дефолтов.

**Бюджет и регион**
- Бюджет: по умолчанию приму до $400. Скорректировать?
- Регион покупки и доставки: по умолчанию Россия / самовывоз из ЕС. Если иначе — поправь.

**Платформа и экосистема**
- Основная связка с Obsidian: на устройстве (Android-устройство с Obsidian) или экспорт-в-vault через десктоп? По умолчанию приму вторичный сценарий — пометки делаются на ридере, синк руками.
- Привязка к экосистеме (Amazon/Kindle Unlimited, ЛитРес, локальная библиотека EPUB)?

**Use case**
- Основной: чтение PDF (научные статьи, технические книги) или EPUB (художка)? По умолчанию приму PDF-приоритет.
- Заметки: подсветка/маргиналии или полноценные рукописные заметки стилусом?
- Вторичный сценарий: чтение в дороге, ванна, на ярком солнце?

**Hard constraints**
- Размер экрана: ты упомянул компактный — приму 7-8". Если строго 6" — скажи.
- Front-light с регулировкой температуры — обязательно или nice-to-have?
- Open Android (sideload Obsidian / KOReader) — обязательно или можно проприетарный софт?

**Scope & freshness**
- Снапшот 2026 (модели текущего года) или evergreen-обзор? По умолчанию снапшот.
- Шортлист 3-5 моделей или детальный разбор 7-10?

**Update vs create**
- В Resources я уже нашёл `Resources/E-Readers - ресерч 2024.md` (если он там есть). Обновлять её или сделать новую заметку для 2026?

**Тон рекомендации**
- Чёткая рекомендация под твой профиль или нейтральный обзор с парой ветвлений? По умолчанию приму нейтральный/сбалансированный обзор (balanced).

Жду ответы по пунктам, где значение отличается от дефолта; остальное приму как написано.
```

Why it is good:

- Honours every required clarification topic from `Plan Format → materiality bar`.
- Groups questions thematically so the user can answer in chunks.
- Declares defaults for items where a reasonable guess exists, letting the user skim and only override mismatches.
- Surfaces a likely existing vault note (from `Core Workflow §1` discovery) and asks `update vs create` explicitly.
- Treats «компактный» as ambiguous and pins it down with a concrete range plus an out for stricter constraint.

---

## Good (compressed): when context already answered most items

If the user's request already covered most of the checklist — for example «нужен PDF-reader на Android до $400, для научных статей, заметки стилусом не нужны, обновляю старую заметку про e-readers» — skip what is answered and ask only the residual:

```text
Большая часть чек-листа закрыта твоим описанием. Осталось три уточнения:

- Регион покупки — для проверки доступности и цен. По умолчанию приму Россия / ЕС.
- Front-light с регулировкой температуры — обязательно или nice-to-have? По умолчанию приму обязательно.
- Шортлист 3-5 моделей или детальный разбор 7-10? По умолчанию шортлист 5.

Если все три дефолта подходят — просто скажи «ок», иду в план.
```

Why it is good:

- Demonstrates that the materiality bar does not mean «always 10 questions»; it means «ask everything not obvious».
- Names the dimensions actively skipped (implicitly — by omission) and the user can spot if something important was wrongly assumed.
- Provides a cheap "ок" path so a confident user is not slowed down.
