# Execution Policy

## Rule Priority
- Explicit user instructions for the current task take priority over this file.
- Explicit user approval overrides the restriction only for the specifically approved command or action.
- All other restrictions remain in effect.
- This override never applies to the Secrets rule: `.env` and credential files are never read, regardless of task instructions.

## ## Secrets
- Never read or print `.env`, secret, key, or credential files, even partially. This rule is absolute and has no exceptions, including task requirements, `Rule Priority`, and the Ignored Files list.
- If configuration is needed, ask the user for the specific value instead of reading the file.

## User Approval
- Explicit approval is required only for commands listed under Code Execution, bulk operations under Long Operations, and genuinely dangerous or irreversible actions.
- Built-in file reading, searching, creation, editing, and deletion within the agreed plan are performed without additional approval.
- After receiving explicit approval, execute the approved action immediately; do not request confirmation again or extend approval to other actions.
- A skipped or canceled system prompt is not user refusal; continue the task by an alternative method.
- Only an explicit user message prohibiting an action counts as refusal.
- If the user explicitly rejects a specific command, do not request it again or suggest an equivalent shell command.

## Failures and Retries
- Do not get stuck in loops.
- If an action, command, or tool call fails, hangs, is skipped, or is canceled, retry the identical call (same tool, same arguments) at most once.
- Never re-attempt the same operation after any other step in between, and do not vary wording ("Actually...", "Wait...") to bypass this rule — it is still a retry.
- After a failed or skipped attempt, if a built-in file reading, searching, creation, editing, or deletion tool can perform the action, use it instead.
- Do not use shell commands (`cp`, `mv`, `rm`, `mkdir`, `touch`, `find`, `cat`) for file operations available through built-in tools.
- If no built-in alternative exists, skip that step and continue with all independent parts of the task; state the limitation explicitly in one line.
- Stop only if the failed or skipped step genuinely blocks correctness of the entire result.
- Do not treat system `Skipped` results, UI cancellations, or temporary tool failures as user refusal.

## Code Execution
- Prefer static file analysis over running code.
- Do not run the following without explicit user approval:
  - `php`
  - `artisan`
  - `composer`
  - `node`
  - `npm`
  - `pnpm`
  - `yarn`
  - `bun`
  - `git`

## Shell
- Use only simple, one-off commands.
- Use `rg` instead of `grep -R` to search the project.
- Limit searches to specific directories and exclude paths listed under Ignored Files.
- Set an explicit `timeout 10s` limit on every recursive command.
- If a command times out, do not repeat it: narrow the search scope or use built-in file search.
- Do not use:
  - loops (`for`, `while`, `until`);
  - multi-line shell scripts;
  - complex pipelines;
  - bulk file processing.

## Task Completion
- An incomplete focus chain item is not a reason to wait or stop.
- For static verification, use files already read and the project's built-in search.
- Do not run commands, tests, or builds if they require separate approval.
- If full verification is unavailable, perform the available checks, state the limitations, and complete the task.
- After verification, update the focus chain and mark completed items.
- Do not leave the task waiting solely because the result cannot be confirmed with a tool.

## Long Operations
- Before bulk changes or large-scale searches, show a concise plan with the expected scope and request approval once.
- Once the plan is approved, perform all reads, searches, creations, edits, and deletions within it without further requests.
- Do not stop between approved stages unless the next step expands the scope.
- If some changes cannot be applied, continue with independent changes and list the unapplied files at the end.

# Development Principles
- Make minimal changes.
- Follow existing project patterns.
- Reuse existing code before writing new code.
- Do not introduce new abstractions unless necessary.
- Do not refactor outside the task scope.
- Do not add comments unless necessary.
- Keep code testable.
- Show only relevant changed fragments.
- Answer at senior level without explaining basic concepts.
- If multiple solutions exist, provide a short list without unnecessary detail.
- Sort entities alphabetically only when it does not affect meaning, contracts, dependencies, or execution order.

## Git Commit Messages
- Follow Conventional Commits: `type(scope): message` (scope when reasonably identifiable).
- Use imperative mood: `feat(auth): add token refresh`, `fix(api): handle empty payload`.
- Subject: hard limit 50 chars, never exceed.
- One short sentence, lowercase after the colon, no trailing period.
- Output ONLY the subject line. No body, no description, no bullet lists, no code fences.
- The message is a single line: `type(scope): subject`.

# Ignored Files and Directories
Do not analyze or modify the following unless the task explicitly requires them:
- `.env`
- `node_modules/`
- `vendor/`
- `dist/`
- `build/`
- `.nuxt/`
- `.output/`
- `coverage/`
- `storage/logs/`
- `bootstrap/cache/`
- `public/build/`
- `public/hot`
- `*.min.js`
- `*.min.css`
- `package-lock.json`
- `pnpm-lock.yaml`
- `yarn.lock`