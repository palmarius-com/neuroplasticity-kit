# Core

Always read at session start. Everything in `_session/kit/` is the same in
every repository and is never edited in a repository: it is replaced as a
whole by a newer kit. Kit version: `_session/kit/version`.

Three owners:

| Folder | Holds | Changed by |
|---|---|---|
| `_session/kit/` | the method: rules, procedures, tools | kit update only |
| `_session/user/` | the person: who, preferences, principles | the person |
| `_session/this_repo/` | the project: baseline, tasks, journal | every session |

## Priority

When two rules pull apart:

1. Hard Rules (below).
2. The user's explicit words in this session.
3. `_session/this_repo/baseline.md` (project rules and settings).
4. `_session/user/` (preferences and principles).
5. The topic rules in `_session/kit/rules/`.
6. Writing things down beats saving tokens. Save tokens on reading, never
   on capture.

Never assume. Not a break, not a number, not what the user did, not the
next step. What is not known is asked or marked "assumption".

## Hard Rules

Always in force. "Without the user's word" means: the user asked for that
exact thing, or confirmed after being asked.

1. **Version control** (if the project uses git): no `git add`, commit,
   push, pull, fetch or rebase without the user's word. No commit ever on
   the assistant's own decision. Push only when the user says "push" in
   that very message. Approval covers one batch only.
2. **Destructive**: nothing destructive or hard to reverse (delete source
   files, overwrite configs or project files, rewrite history, erase or
   flash a device, upload to a third party) without asking first.
3. **Running things**: no tests, builds, exports, scripts, hardware-facing
   commands, nothing billed or metered, without the user's word. Tell the
   cost first. Timeouts: 10 minutes or less. Approved without asking:
   reading the session files, `_session/kit/tools/start.ps1`, and what
   `baseline.md` lists under "Allowed without asking".
4. **The user's machine**: no take-over of pointer, keyboard or mail client
   without asking and WAITING for the OK.
5. **Code**: ask before changing existing code. Explain before
   implementing. Never change something without understanding the impact.
6. **Terminal**: short single-line commands only. Never multi-line or
   here-string commands. Files are written with the file tools.
7. **Facts**: what the user observed firsthand is truth once stated.
   Numbers the user states are used exactly as given, never replaced by an
   estimate, a plan value or a web snippet.
8. **Honesty**: never report a guess as a fact. Keep apart what is known,
   what is assumed and what was not checked.
9. **Record**: every piece of work is a task, every event gets a journal
   line, docs are updated in the same session. Nothing stays only in the
   chat.
10. **Memory**: the gist of everything is in the repository at all times.
    No local or cross-session memory, no scratchpad for anything worth
    keeping. Originals may be git-ignored (`_external/`); their gist is
    not.
11. **Confidential**: no whole files in replies, no secrets in version
    control, no private details in any memory, nothing uploaded to a third
    party.
12. **Rules**: the assistant never weakens, drops or reinterprets a rule.
    A rule is relaxed only by the user's own words, quoted with the date.
    In doubt the stricter reading holds. A new rule that looks general is
    written into `baseline.md`, "Rule Candidates"; only the user promotes
    it into the kit.

## Session Start

1. Run `_session/kit/tools/start.ps1` and read its output. It writes the
   session start line and reports: kit version, machine, UTC offset,
   version control and identity, the tasks worked on last that are still
   open, open gaps, missing files.
2. Read `_session/user/user.md` and `_session/user/preferences.md`. If
   they are missing: task T002 ("introduce yourself").
3. Read `_session/this_repo/baseline.md`. If it still holds `FILL IN`:
   task T001 (project survey).
4. Open gaps reported by the start script: ask the user with the question
   tool (`rules/tasks.md`, "Gaps"). Ask also for work done without the
   assistant.
5. Reply with a short summary and ask only: "Anything changed since last
   session?" and whether to continue the last open task.

Not read at start: `README.md` (it is for humans), task files, closed
tasks, journal files, topic rules, procedures. A session is never closed
explicitly; the next start settles the open end.

## Formats

Timecode: `yyyyMMdd_HHmmss`, local time, from the clock, never invented.
Names of files and folders in `_session/`: lower case a-z, digits, `-`,
`_`, `.`. No spaces, no umlauts, nothing that breaks XML, a console or
another receiver of text. Dated names start with the timecode.

Journal: `_session/this_repo/journal/<yyyyMMdd>_<machine>.md`, append only,
one line per event:

```
- <timecode> <Tnnn> <text>
```

`T000` is "no task". Lines the tools understand:

```
- 20261114_090000 T000 session start utc+01:00 machine NAME
- 20261114_090500 T029 prompt
- 20261114_091200 T029 reply
- 20261114_091300 T029 opened: title of the task
- 20261114_180000 T029 closed
- 20261114_180500 T332 run start deep-sleep test, 14 h
- 20261115_081000 T332 run end
- 20261115_081500 T029 gap 20261114_180000 0.75h
- 20261115_081600 T029 adjust +1.50h phone call with the customer
- 20261115_081700 T000 renumber T031 -> T033
```

`prompt` and `reply` are written by the harness hooks
(`tools/hooks/readme.md`). Without hooks the assistant writes them, with
the time from the clock. Everything else is free text after the task
number: decisions and statements of the user in the user's words, things
received or sent, commits, builds, tests.

Task: one file `_session/this_repo/tasks/open/tNNN.md`. The folder is the
status: closing a task is moving its file, unchanged, to `tasks/closed/`.
The file holds no status and no time. Time lives only in the journal and in
the generated `timetable.md`. Current task: the one line in
`_session/this_repo/current_task`.

Generated files (`tasklist.md`, `timetable.md`, `kit/manifest`) are never
edited by hand.

## Which Topic File When

| Before | Read `_session/kit/rules/` |
|---|---|
| Opening, closing, splitting a task; a finding; gaps and time | `tasks.md` |
| Talking a decision through, asking, drafting a plan | `working.md` |
| Using a number, a source, a statement of the user | `facts.md` |
| The user gives a picture, file, log, mail; writing docs | `capture.md` |
| Creating or naming files, scripts, generated output | `files.md` |
| Any version control action | `git.md` |
| Hunting a fault | `debugging.md` |
| Running or writing a test, release check, driving the real window | `testing.md` |
| Flashing, bench work, wiring | `hardware.md` |
| Release, shipping, sending a package | `release.md` |
| Mail, forum or chat drafts, documents for customers | `messages.md` |

`baseline.md` lists the topic files that are active in this project; the
others do not apply here. One-off jobs (new repository, kit update,
migration, moving a repository, acceptance test) are in
`_session/kit/procedures/` and are read only when that job is done.
