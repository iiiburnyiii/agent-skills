---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit or optimize an existing skill, run evals to test a skill, benchmark skill variants, or improve metadata so the right skill triggers for the right task.
---

# Skill Creator

A skill for creating new skills and improving them through repeated testing.

At a high level, the workflow looks like this:

- Decide what the skill should do and roughly how it should do it
- Write a draft of the skill
- Create a few realistic test prompts and run the agent with and without the skill
- Help the user evaluate the results qualitatively and quantitatively
  - While the runs are in progress, draft quantitative assertions if needed
  - Use `eval-viewer/generate_review.py` to let the user review outputs and benchmark data
- Rewrite the skill based on user feedback and benchmark findings
- Repeat until the skill is good enough
- Expand the test set and rerun at larger scale if needed

Your job when using this skill is to figure out where the user is in this workflow and help them move forward. If the user says "turn this workflow into a skill", help capture intent, draft the skill, write test cases, run evaluations, and iterate. If the user already has a draft, go straight to evals and revision.
Stay flexible. If the user does not want a full benchmarking loop and only wants help drafting or refining the skill, do that.
After the main workflow is stable, you can also improve the skill's metadata and trigger description so the right situations activate it more reliably.

## Communicating with the user

This skill may be used by people with very different levels of technical familiarity. Adapt your wording to the user's context.

In the default case:

- "evaluation" and "benchmark" are usually fine
- "JSON" and "assertion" may need a short explanation unless the user is clearly comfortable with them

If you are unsure whether the user will understand a term, explain it briefly and move on.

---

## Creating a skill

### Capture Intent

Start by understanding the user's intent. The current conversation may already contain the workflow the user wants to capture. If so, extract what you can from the conversation first: tools used, the order of steps, corrections the user made, input and output formats, and signs of what success looks like. Then ask only for the missing pieces.

1. What should this skill enable the agent to do?
2. When should this skill trigger? What user phrases or contexts should cause that?
3. What output should the skill produce?
4. Should you set up test cases? Skills with objectively verifiable outputs usually benefit from test cases. Skills for subjective output often do not need formal evals.

### Interview and Research

Ask about edge cases, example inputs, output formats, dependencies, and success criteria. Wait to write test prompts until this is clear.

Check available tools and subagents. If research would help, do it in parallel when possible. Come back with context instead of making the user do all the work.

### Write the SKILL.md

Based on the user interview, fill in these components:

- **name**: Skill identifier
- **description**: What the skill does and when it should trigger. This is often the primary routing signal, so include both capabilities and concrete trigger contexts. Put the "when to use" guidance here rather than burying it in the body. Many agents undertrigger skills, so descriptions should be slightly proactive.
- **compatibility**: Required tools, dependencies, or environment assumptions if needed
- **the rest of the skill**

### Skill Writing Guide

#### Anatomy of a Skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic or repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

#### Progressive Disclosure

Skills usually work best with three layers:

1. **Metadata** (name and description): lightweight routing context
2. **SKILL.md body**: loaded when the skill is in use
3. **Bundled resources**: referenced only when needed

The exact mechanics depend on the platform, but the design principle is the same: keep the top layer short and route-specific, keep the body focused, and put bulky material in references or scripts.
**Key patterns:**

- Keep `SKILL.md` reasonably compact; if it grows too large, split detailed material into references and point to them clearly
- Reference files explicitly from `SKILL.md` and say when to read them
- For large reference files, include a table of contents

**Domain organization**: When a skill supports multiple domains or frameworks, organize by variant:

```
cloud-deploy/
├── SKILL.md (workflow + selection)
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

The agent should only read the relevant reference file.

#### Principle of Lack of Surprise

Skills must not contain malware, exploit code, or instructions that would compromise system security. The behavior of a skill should match what its description leads the user to expect. Do not help create misleading skills or skills intended for unauthorized access, exfiltration, or other malicious activity.

#### Writing Patterns

Prefer imperative instructions.

**Defining output formats**:

```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern**:

```markdown
## Commit message format
**Example 1:**
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

### Writing Style

Explain why the guidance matters instead of relying on rigid commandments. Keep the skill general enough to transfer across prompts and users. Write a draft, reread it critically, and improve it.

### Test Cases

After writing the first draft, create 2-3 realistic test prompts. These should sound like things a real user would actually say. Share them with the user before running them. For example: "Here are a few test cases I want to try. Do these look right, or do you want to add more?"

Save test cases to `evals/evals.json`. Do not write assertions yet. Draft assertions in the next step while the runs are in progress.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

See `references/schemas.md` for the full schema, including the `assertions` field.

## Running and evaluating test cases

This section is one continuous sequence. Do not stop halfway through and lose the loop.

Put results in `<skill-name>-workspace/` as a sibling to the skill directory. Within that workspace, organize results by iteration (`iteration-1/`, `iteration-2/`, etc.). Inside each iteration, each test case gets its own directory. Do not create every directory up front. Create them as needed.

### Step 1: Spawn all runs in the same turn

For each test case, spawn two runs in the same turn when the environment supports it:

- one run with the skill enabled
- one baseline run without it, or with the previous version if this is an improvement cycle

Do not run all skill-enabled cases first and come back for baselines later. Launch all of them together so they finish at roughly the same time.

**With-skill run:**

```
Execute this task:
- Skill path: <path-to-skill>
- Task: <eval prompt>
- Input files: <eval files if any, or "none">
- Save outputs to: <workspace>/iteration-<N>/eval-<ID>/with_skill/outputs/
- Outputs to save: <what the user cares about>
```

**Baseline run:**

- **Creating a new skill**: no skill at all. Same prompt, save to `without_skill/outputs/`.
- **Improving an existing skill**: use the prior version as baseline. Before editing, snapshot the skill, then point the baseline run at that snapshot. Save to `old_skill/outputs/`.

Write an `eval_metadata.json` for each test case. Assertions can be empty at first. Give each eval a descriptive name based on what it is testing. Use that name for the directory too.

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name-here",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

If this iteration introduces new or changed eval prompts, create fresh metadata files for those evals rather than assuming old metadata still applies.

### Step 2: While runs are in progress, draft assertions

Do not sit idle while the runs complete. Draft quantitative assertions and explain them to the user. If assertions already exist in `evals/evals.json`, review them and explain what they measure.

Good assertions are objectively verifiable and descriptive. Someone looking at the benchmark should immediately understand what each assertion checks. Do not force assertions onto output that requires human taste or judgment.

Once drafted, update both `eval_metadata.json` and `evals/evals.json`. Also explain to the user what they will see in the viewer: qualitative outputs plus the quantitative benchmark.

### Step 3: As runs complete, capture timing data

When each run completes, capture the runtime metrics immediately if the environment exposes them. Save them to `timing.json` in the run directory.

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

If your environment provides different metrics, preserve them too, but keep these canonical fields when possible so later tooling can consume them consistently.

### Step 4: Grade, aggregate, and launch the viewer

Once all runs finish:

1. **Grade each run**. Spawn a grader subagent or grade inline. Read `agents/grader.md` and evaluate each assertion against the outputs. Save results to `grading.json` in each run directory. The expectations array must use the exact fields `text`, `passed`, and `evidence` because the viewer expects them.

2. **Aggregate into a benchmark**. Run the aggregation script from the skill directory:

   ```bash
   python -m scripts.aggregate_benchmark <workspace>/iteration-N --skill-name <name>
   ```

   This produces `benchmark.json` and `benchmark.md` with pass rate, timing, and token usage for each configuration. If you build `benchmark.json` manually, follow the exact schema in `references/schemas.md`.

   Put each `with_skill` version before its baseline counterpart.

3. **Do an analyst pass**. Read the benchmark results and look for patterns the aggregate numbers hide. Use `agents/analyzer.md` to look for non-discriminating assertions, flaky evals, high-variance cases, and performance tradeoffs.

4. **Launch the reviewer** with both qualitative outputs and quantitative data:

   ```bash
   nohup python <skill-creator-path>/eval-viewer/generate_review.py \
     <workspace>/iteration-N \
     --skill-name "my-skill" \
     --benchmark <workspace>/iteration-N/benchmark.json \
     > /dev/null 2>&1 &
   VIEWER_PID=$!
   ```

   For iteration 2 and later, also pass `--previous-workspace <workspace>/iteration-<N-1>`.

   If the environment is headless or cannot open a browser, use `--static <output_path>` to write a standalone HTML file instead of starting a server. In static mode, feedback will usually be downloaded as `feedback.json`. Copy that file into the workspace after the user exports it.

   Use `generate_review.py`. Do not build a custom reviewer UI unless there is a concrete reason.

5. **Tell the user what to do next**. For example: "I've opened the results. The Outputs tab lets you review each test case and leave feedback. The Benchmark tab shows the quantitative comparison. When you're done, come back here and tell me."

### What the user sees in the viewer

The "Outputs" tab shows one test case at a time:

- **Prompt**: the task that was given
- **Output**: the produced files, rendered inline where possible
- **Previous Output**: collapsed section showing the previous iteration output when available
- **Formal Grades**: collapsed section showing assertion pass/fail when grading was run
- **Feedback**: a text box that auto-saves
- **Previous Feedback**: prior comments, shown on later iterations

The "Benchmark" tab shows pass rates, timing, token usage, per-eval breakdowns, and analyst observations.

Navigation is through next and previous buttons or arrow keys. When finished, the user submits all reviews and the tool saves `feedback.json`.

### Step 5: Read the feedback

When the user says they are done, read `feedback.json`:

```json
{
  "reviews": [
    {"run_id": "eval-0-with_skill", "feedback": "the chart is missing axis labels", "timestamp": "..."},
    {"run_id": "eval-1-with_skill", "feedback": "", "timestamp": "..."},
    {"run_id": "eval-2-with_skill", "feedback": "perfect, love this", "timestamp": "..."}
  ],
  "status": "complete"
}
```

Empty feedback usually means the user thought the output was fine. Focus improvements on runs where they had concrete complaints.

Kill the viewer process when you are done with it:

```bash
kill $VIEWER_PID 2>/dev/null
```

---

## Improving the skill

This is the core iteration loop. You have outputs, user feedback, and benchmark data. Use them to make the skill better.

### How to think about improvements

1. **Generalize from the feedback.** The user is reviewing a small set of examples because that is fast, not because those examples should become the whole shape of the skill. Avoid overfitting. If a problem keeps coming up, look for the deeper reason and encode that.

2. **Keep the prompt lean.** Remove instructions that are not helping. Read transcripts when possible, not just final outputs. If the skill is causing the agent to burn time on unproductive work, simplify it.

3. **Explain the why.** Models respond better to grounded reasoning than to piles of rigid commands. If you find yourself writing in all caps or adding too many inflexible rules, treat that as a warning sign and reframe the instruction around purpose.

4. **Look for repeated work across test cases.** If multiple runs independently invent the same helper script or follow the same multi-step process, bundle that logic into `scripts/` and tell the skill to use it.

Take your time. This work is high leverage. Write a revision, then reread it critically before you rerun the evals.

### The iteration loop

After improving the skill:

1. Apply the changes to the skill
2. Rerun all test cases into a new `iteration-<N+1>/` directory, including baselines
3. Launch the reviewer with `--previous-workspace` pointing to the prior iteration
4. Wait for the user to review and tell you they are done
5. Read the new feedback, improve again, and repeat

Keep going until:

- the user says they are happy
- the feedback is empty across the board
- you are no longer making meaningful progress

---

## Advanced: Blind comparison

If the user wants a more rigorous comparison between two versions of a skill, use the blind comparison system. Read `agents/comparator.md` and `agents/analyzer.md`.

The basic idea is simple: give two outputs to an independent evaluator without saying which one came from which version, let it judge quality, then analyze why the winner won.

This is optional. Most users do not need it.
---

## Description Optimization

The `description` field in `SKILL.md` frontmatter is often the main routing signal that determines whether a platform invokes a skill. After creating or improving a skill, offer to optimize the description so it triggers in the right situations more reliably.

If the platform does not use the `description` field for routing, adapt this section to whatever routing metadata it does use.

### Step 1: Generate trigger eval queries

Create 20 eval queries: a mix of should-trigger and should-not-trigger. Save them as JSON:

```json
[
  {"query": "the user prompt", "should_trigger": true},
  {"query": "another prompt", "should_trigger": false}
]
```

The queries must be realistic and detailed. Use the kinds of prompts users actually type in an agentic environment: file paths, job context, vague recollections of filenames, URLs, column names, conversational wording, typos, shorthand, and incomplete but recognizable requests.

Bad: `"Format this data"`, `"Extract text from PDF"`, `"Create a chart"`

Good: `"ok so my manager just sent me this spreadsheet in downloads, maybe called 'Q4 sales final FINAL v2.xlsx', and I need a new column for profit margin as a percentage. Revenue should be in column C and costs in D I think"`

For the **should-trigger** queries, aim for coverage. Use different phrasings of the same intent, including cases where the user does not name the skill explicitly but clearly needs it.

For the **should-not-trigger** queries, focus on near misses. The best negatives are not irrelevant prompts. They are prompts that share language or context with the skill but should route elsewhere.

### Step 2: Review with the user

Present the eval set to the user for review using the HTML template:

1. Read the template from `assets/eval_review.html`
2. Replace the placeholders:
   - `__EVAL_DATA_PLACEHOLDER__` -> the JSON array of eval items, without quotes
   - `__SKILL_NAME_PLACEHOLDER__` -> the skill name
   - `__SKILL_DESCRIPTION_PLACEHOLDER__` -> the current description
3. Write the result to a temp file such as `/tmp/eval_review_<skill-name>.html`
4. Open it if the environment supports opening local HTML files
5. Let the user edit queries, toggle `should_trigger`, add or remove entries, then export the final eval set
6. Check the user's download directory or chosen export path for the newest `eval_set.json`

Bad eval queries lead to bad optimization. This review step matters.

### Step 3: Run the optimization loop

Tell the user this can take a while and will run in the background.

Save the eval set into the workspace, then run the optimization loop using whatever CLI or script adapter your environment provides. For example:

```bash
python -m scripts.run_loop \
  --eval-set <path-to-eval-set> \
  --skill-path <path-to-skill> \
  --model <current-model-id> \
  --max-iterations 5 \
  --verbose
```

Use the same model or agent family the user actually relies on so the routing test matches real behavior as closely as possible.

While it runs, periodically check progress and report which iteration it is on and how the scores are changing.

The loop should evaluate the current description, propose improvements based on failures, reevaluate, and keep the best result based on held-out performance rather than training-only performance.

### How skill triggering works

Skill routing usually works by exposing a list or registry of available skills with metadata such as name and description. The agent or router decides whether to consult a skill based on that metadata plus the current task.

One important implication: simple one-step tasks often will not trigger a skill even when the description matches, because the agent can handle them directly. More complex, multi-step, or specialized tasks are much better trigger tests.

This means your eval queries should be substantive enough that a skill would actually help. Queries like "read file X" are usually poor trigger tests.

### Step 4: Apply the result

Take `best_description` from the optimization output and update the skill frontmatter. Show the user the before and after versions and report the evaluation scores.

---

### Package and Present (only if a packaging or file-presentation tool exists)

If the environment supports packaging skills into an installable artifact, do that at the end:

```bash
python -m scripts.package_skill <path/to/skill-folder>
```

Point the user to the resulting artifact path.

---

## Chat-Only Environments

In a chat-only environment, the core workflow stays the same, but some mechanics change because you may not have subagents, a writable browser session, or background jobs.

**Running test cases**: Without subagents, execute test cases one at a time. Read the skill, then follow it yourself to complete each prompt. This is less rigorous than independent runs because you wrote the skill and know what it says, but it still provides a useful sanity check.

**Baseline runs**: If independent baselines are not practical, skip them and focus on qualitative review. If you can still preserve an older version and compare manually, do that.

**Reviewing results**: If you cannot open the HTML reviewer, present outputs directly in the conversation. Show the prompt and the result for each eval, and ask for inline feedback.

**Benchmarking**: Skip quantitative benchmarking if the environment cannot support a meaningful baseline or repeatable execution. Focus on user review.

**Description optimization**: Only run it if the platform provides a CLI or API path that can test skill routing. If not, skip it.

**Packaging**: If the packaging script works in the environment, use it. Otherwise leave the skill as a directory.

**Updating an existing skill**: Preserve the original name. If the installed location is read-only, copy the skill to a writable temp directory, edit there, and package from the copy.

---

## Headless or Server Environments

In headless environments, most of the workflow still works, but browser-dependent pieces need adaptation.

- If subagents exist, use them for the main eval loop
- If opening a browser is not possible, generate static HTML with `--static <output_path>` and give the user the file path
- In static mode, the review tool may export `feedback.json` instead of sending it back to a live server; copy that file into the workspace after the user downloads and returns it
- Packaging still works as long as Python and the filesystem are available
- Delay description optimization until the skill itself is already in good shape

No matter what environment you are in, generate the review UI before you start manually judging outputs. Human review should happen early.

---

## Reference files

The `agents/` directory contains instructions for specialized subagents. Read them when you need them.

- `agents/grader.md` - how to evaluate assertions against outputs
- `agents/comparator.md` - how to do blind comparison between two outputs
- `agents/analyzer.md` - how to analyze why one version beat another

The `references/` directory contains supporting documentation:

- `references/schemas.md` - JSON structures for `evals.json`, `grading.json`, and related files

---

The core loop again, in short:

- Figure out what the skill is about
- Draft or edit the skill
- Run the skill on test prompts
- Evaluate the outputs with the user
  - Create `benchmark.json` and run `eval-viewer/generate_review.py`
  - Run quantitative evals where they make sense
- Repeat until the skill is good enough
- Package the final skill if packaging exists

If you use a task list, add reminders so you do not forget important steps. In particular: create the evals JSON, run `eval-viewer/generate_review.py`, get human review, then revise.
Good luck.
