---
name: chezmoi
description: Manage chezmoi dotfiles safely. Use this skill whenever the user mentions chezmoi, dotfiles, source state, target state, chezmoi status/diff/apply/git, adding/removing/forgetting files from dotfiles, .chezmoiignore, templates, secrets, machine-specific config, or asks why dotfiles are still present, untracked, not applied, or out of sync. Also use before editing likely dotfile-managed paths such as ~/.config, shell rc files, ~/.agents/skills, or app config files, so changes happen in the correct chezmoi source/target location and are verified before apply/commit/push.
compatibility: Requires the chezmoi CLI and git. Some workflows may use password-manager CLIs only when the existing dotfiles setup already uses them.
---

# Chezmoi Dotfile Management

Use this skill to manage dotfiles through chezmoi without confusing the **source state** (`~/.local/share/chezmoi` by default), the **destination/target files** in `$HOME`, and the **git repository** that stores the source state.

The goal is boring reliability: inspect first, edit the right side of the chezmoi model, preview, apply only when intended, and leave both chezmoi and git clean.

## Mental Model

- **Destination / target state**: real files in the user's home directory, for example `~/.zshrc` or `~/.config/app/config.toml`.
- **Source state**: files in the chezmoi source directory, usually `~/.local/share/chezmoi`. This is what gets committed to git.
- **Computed target state**: what chezmoi would generate from the source state after applying attributes, templates, ignores, externals, and local data.
- `chezmoi diff` compares computed target state with actual destination files.
- `chezmoi apply` changes destination files to match computed target state.
- `chezmoi git ...` runs git inside the source directory. It is about the dotfiles repository, not about whether destination files match target state.
- `chezmoi status` is chezmoi drift/status; `chezmoi git status` is git status of the source repo. They answer different questions.

## First Response Checklist

Before **any** chezmoi operation that adds, removes, forgets, or modifies a file:

1. **Ask intent** — should this file be synced across machines, local-only, or deleted?
2. **Inspect** — `chezmoi status <path>` and `chezmoi managed <path>`.
3. **Locate source** — `chezmoi source-path <path>` if managed.
4. **Scan for secrets** — tokens, keys, emails, work identifiers. Never add raw secrets.
5. **Dry run first** — `chezmoi apply -n -v` before broad applies.

These steps are repeated inline inside each workflow below. **Do not skip them.**

## Safe Editing Workflow

When editing an already managed dotfile:

### Pre-check

1. Confirm the file is managed:
   ```bash
   chezmoi status ~/.zshrc
   chezmoi source-path ~/.zshrc
   ```

### Edit

2. Edit the source state:
   ```bash
   chezmoi edit ~/.zshrc
   ```
   Or edit the file returned by `chezmoi source-path ~/.zshrc`.
3. Preview the exact effect:
   ```bash
   chezmoi diff ~/.zshrc
   ```

### Apply

4. Apply only after the diff is expected:
   ```bash
   chezmoi apply ~/.zshrc
   ```

### Post-verify

5. Confirm both chezmoi and git state:
   ```bash
   chezmoi status ~/.zshrc
   chezmoi git status
   ```
6. To commit, use `chezmoi cd` (sets proper env vars):
   ```bash
   chezmoi cd
   git add -A
   git commit -m "..."
   exit
   ```
   You can also `chezmoi cd ~/.zshrc` to jump straight to the source file's directory.

### Re-add: capturing manual destination edits

If the user has already edited the destination file directly and wants to keep that change in chezmoi, use `re-add`. This syncs the destination file back into the source state:

#### Pre-check

1. Confirm the file is managed and has drifted:
   ```bash
   chezmoi status ~/.config/fish/config.fish
   ```

#### Execute

2. Sync destination into source state:
   ```bash
   chezmoi re-add ~/.config/fish/config.fish
   ```

#### Post-verify

3. Preview what changed in source:
   ```bash
   chezmoi diff ~/.config/fish/config.fish
   chezmoi git diff
   ```
4. Show the diff and wait for confirmation before committing.

## Adding Files to Chezmoi

Use this when the user wants a file synchronized by dotfiles:

### Pre-check

1. **Ask intent** — does the user want this file synced across machines, or is it local-only? If local-only, add to `.chezmoiignore` instead.
2. **Check current state**:
   ```bash
   chezmoi status ~/.config/app/config.toml
   chezmoi managed ~/.config/app/config.toml
   ```
3. **Scan for secrets** — read the file content. Look for `api_key`, `token`, `secret`, `password`, `client_secret`, private keys, emails, and hostnames. If found, **STOP** and warn the user. Suggest `chezmoi add --encrypt`, a password manager template, or adding to `.chezmoiignore`.

### Add

4. Add the file:
   ```bash
   chezmoi add ~/.config/app/config.toml
   ```
5. For machine-specific content, add as a template:
   ```bash
   chezmoi add --template ~/.config/app/config.toml
   ```
6. If permissions matter, inspect the generated source name and apply attributes:
   - `private_` for private permissions.
   - `executable_` for executables/scripts.
   - `readonly_` for readonly targets.
   - `symlink_` for symlinks.

### Post-verify

7. Confirm source was created and diff is expected:
   ```bash
   chezmoi source-path ~/.config/app/config.toml
   chezmoi diff ~/.config/app/config.toml
   chezmoi git diff
   ```
8. Show the diff to the user and wait for confirmation before committing.

## Removing or Unmanaging Files

Be precise about the user's intent:

### Stop managing but keep the target file

Use `forget` (alias `unmanage`). This removes the target from source state and leaves the destination file in place.

#### Pre-check

1. Confirm the file is currently managed:
   ```bash
   chezmoi managed ~/.config/app/local-only.toml
   chezmoi status ~/.config/app/local-only.toml
   ```
2. Confirm the user wants to keep the file on disk (not delete it).

#### Execute

3. Stop managing it:
   ```bash
   chezmoi forget ~/.config/app/local-only.toml
   ```

#### Post-verify

4. **Critical:** confirm the destination file still exists:
   ```bash
   ls ~/.config/app/local-only.toml
   ```
5. Confirm chezmoi no longer manages it:
   ```bash
   chezmoi status ~/.config/app/local-only.toml
   ```
   Expected: `not managed`.
6. Commit the removal in git:
   ```bash
   chezmoi git status
   chezmoi git add -A
   chezmoi git commit -m "forget: stop managing ~/.config/app/local-only.toml"
   ```

### Delete from the destination via chezmoi

Use `remove_` source-state entries or direct removal workflows only when the user wants chezmoi to remove the target file from machines. Preview before applying.

### Remove stale local files after source deletion

If a file was removed from chezmoi source but still exists locally and `chezmoi status <path>` says it is not managed, chezmoi will not clean it up. Delete it manually only after confirming it should not remain.

```bash
chezmoi status ~/.agents/skills/old-skill
# if "not managed" and user wants it gone:
rm -rf ~/.agents/skills/old-skill
```

## Local-Only Files and `.chezmoiignore`

Use this when some directory or file should never be synchronized by chezmoi.

Important rule from chezmoi docs: patterns in `.chezmoiignore` match **target paths**, not source-state paths. In a normal source tree, a target path such as `~/.config/opencode/skills` is represented as `private_dot_config/opencode/skills` in source state, but the ignore pattern should be written for the target path form as chezmoi sees it.

The correct pattern uses the **target path** (what the file is called in `$HOME`), not the source-state name. For example, a file that lives in source state as `private_dot_config/opencode/skills/` maps to the target path `.config/opencode/skills/`. The ignore entry should be:

```text
.config/opencode/skills
```

Note: this user's `.chezmoiignore` currently uses `private_dot_config/opencode/skills` (source-path form). That appears to work only because no source files currently exist in that directory. If a file is later added there, the ignore will silently fail because `private_dot_config/opencode/skills` does not match the target path `.config/opencode/skills`. Consider fixing this entry.

When adding an ignore:

#### Pre-check

1. **Check if file is currently managed**:
   ```bash
   chezmoi managed ~/.config/opencode/work.json
   chezmoi status ~/.config/opencode/work.json
   ```
   If managed, run `chezmoi forget` first to stop tracking it in source state.

2. **Check for untracked source copies**:
   ```bash
   chezmoi source-path ~/.config/opencode/work.json
   ```
   If a source file exists, delete it from the source directory.

#### Execute

3. Edit `.chezmoiignore` in the source directory:
   ```bash
   chezmoi edit .chezmoiignore
   ```
   Use the **target path** form: `.config/opencode/work.json`.
4. Remove any untracked copy in source state — `.chezmoiignore` prevents future tracking but does not delete existing source files.

#### Post-verify

5. Confirm clean state:
   ```bash
   chezmoi status
   chezmoi git status
   ```
6. Commit:
   ```bash
   chezmoi git add .chezmoiignore
   chezmoi git commit -m "ignore: stop syncing ~/.config/opencode/work.json"
   ```

If the destination local-only files should remain, keep them in `$HOME` and delete only the accidental source-state copy.

## Templates and Machine-Specific Config

Use templates when a file should be mostly shared but vary by OS, host, user, work/personal context, or available tools.

Ways to create templates:

```bash
chezmoi add --template ~/.zshrc
chezmoi chattr +template ~/.zshrc
```

Template basics:

```gotemplate
{{ if eq .chezmoi.os "darwin" }}
# macOS config
{{ else if eq .chezmoi.os "linux" }}
# Linux config
{{ end }}
```

Useful checks:

```bash
chezmoi data
chezmoi execute-template '{{ .chezmoi.hostname }}'
chezmoi execute-template < ~/.local/share/chezmoi/dot_zshrc.tmpl
chezmoi cat ~/.zshrc
```

When embedding config languages that also use `{{ ... }}` syntax, watch for collisions with Go templates. Use raw strings, escaping, helper templates, or non-template source files when templating is not actually needed.

### `.chezmoidata` — per-machine data without templates

If a file is not a template but you still need machine-specific variables, put them in `.chezmoidata.$FORMAT` in the source directory (supported formats: `json`, `jsonc`, `toml`, `yaml`). Data from these files is available in templates across the entire source state.

Example `.chezmoidata.yaml`:

```yaml
email: me@work.com
work: true
```

Then in a template: `{{ if .work }}...{{ end }}`.

### `.chezmoitemplates` — reusable template fragments

Put shared fragments in `.chezmoitemplates/` in the source directory. Include them in any `.tmpl` file:

```gotemplate
{{ template "my-fragment" . }}
```

### `.chezmoiexternal.$FORMAT` — external repos and files

Use `.chezmoiexternal.toml` (or `.yaml`) to pull in external repos, archives, or files during `chezmoi apply`. This is useful for third-party skills, themes, or configs maintained elsewhere.

```toml
[".config/some-app"]
type = "archive"
url = "https://example.com/config.tar.gz"
```

External state is cached. Refresh with `chezmoi apply --refresh-externals` or `-R always`.

## Secrets Policy

**STOP** before adding or committing any dotfile:

- Scan the file content for: `api_key`, `token`, `secret`, `password`, `client_secret`, private keys, service URLs, emails, and work-only identifiers.
- **Do not commit raw secrets.** If found, warn the user and offer:
  - `chezmoi add --encrypt <path>` (age/GPG encryption in source state)
  - Password manager template functions (1Password, Bitwarden, pass) — use only if the existing dotfiles setup already uses one
  - Add to `.chezmoiignore` (local-only, no sync)
- Be extra careful with `autoPush`; official docs warn that accidentally adding a secret can push it to a public repo.
- **If a secret may already have been committed, stop immediately.** Tell the user. Do not continue with normal cleanup until they decide how to rotate or remove the leaked secret.

## Source-State Naming Cheat Sheet

Common source-state attributes:

| Attribute | Meaning |
|---|---|
| `dot_` | Target name starts with `.` |
| `private_` | Remove group/world permissions from target |
| `executable_` | Make target executable |
| `readonly_` | Remove write permissions |
| `empty_` | Keep an empty file that chezmoi would otherwise ignore/remove |
| `create_` | Create if missing, but do not overwrite existing target |
| `modify_` | Apply a script to modify an existing target |
| `remove_` | Remove target if it exists |
| `symlink_` | Create a symlink instead of a regular file |
| `run_` | Treat source as a script to run |
| `once_` / `onchange_` | Run script once or when contents/name change |
| `before_` / `after_` | Run script before or after updating destination |
| `exact_` | (directories) remove anything not managed by chezmoi inside this dir |
| `.tmpl` | Interpret source file contents as a template |
| `literal_` / `.literal` | Stop attribute parsing for literal names |

**Prefix order matters.** For a regular file the order is: `encrypted_`, `private_`, `readonly_`, `empty_`, `executable_`, `dot_`. For directories: `remove_`, `external_`, `exact_`, `private_`, `readonly_`, `dot_`. `chezmoi chattr` handles the ordering automatically.

**`exact_` directories**: useful for keeping a directory clean. If a source directory is named `exact_dot_config/myapp/`, chezmoi will remove any files in `~/.config/myapp/` that are not in the source state. Use carefully — it is destructive.

## Command Reference for Common Tasks

```bash
# Where is the source directory?
chezmoi source-path

# Source path for a target
chezmoi source-path ~/.zshrc

# List managed entries
chezmoi managed
chezmoi managed ~/.config
chezmoi managed --path-style=source-relative ~/.config

# Preview destination changes
chezmoi diff
chezmoi diff ~/.zshrc

# Show concise chezmoi state
chezmoi status
chezmoi status ~/.zshrc

# Apply target changes
chezmoi apply ~/.zshrc
chezmoi apply -n -v

# Work with the source git repo
chezmoi git status
chezmoi git diff
chezmoi git add -A
chezmoi git commit -m "..."
chezmoi git push origin main

# Pull and apply latest source changes
chezmoi update

# Pull without applying, then inspect
chezmoi git pull -- --autostash --rebase
chezmoi diff

# Stop managing a file while keeping it locally
chezmoi forget ~/.config/app/local-only.toml
```

If a user mistypes a chezmoi command (for example `doff` or `applu`), do not infer that a real operation succeeded. State the typo briefly and use/offer the correct command (`diff`, `apply`) after checking current state.

## Clean Finish Checklist

At the end of any chezmoi task, report:

- What changed in destination files, if anything.
- What changed in the chezmoi source repo.
- Whether `chezmoi status` is clean.
- Whether `chezmoi git status` is clean or ahead/behind.
- Whether a commit/push was made, and the commit hash if applicable.
- Any local-only files deliberately left outside chezmoi.
- Optionally run `chezmoi verify` to confirm all managed targets match their target state.

Prefer leaving the user with one of these states:

```text
chezmoi status: clean
chezmoi git status: clean, ahead by N commits
```

or

```text
chezmoi status: clean
git changes intentionally left uncommitted: <paths>
```

## References Consulted

- Official quick start: `https://chezmoi.io/quick-start/`
- Official daily operations: `https://chezmoi.io/user-guide/daily-operations/`
- Official `.chezmoiignore` reference: `https://chezmoi.io/reference/special-files/chezmoiignore/`
- Official status command reference: `https://chezmoi.io/reference/commands/status/`
- Official source-state attributes reference: `https://chezmoi.io/reference/source-state-attributes/`
- Official templating guide: `https://chezmoi.io/user-guide/templating/`
- Official password-manager integration guide: `https://chezmoi.io/user-guide/password-managers/`
- Existing community chezmoi skills were reviewed for workflow ideas, but this skill is written for this user's pi/opencode/chezmoi workflow.
