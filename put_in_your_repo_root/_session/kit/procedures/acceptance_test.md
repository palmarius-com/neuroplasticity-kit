# Procedure: Acceptance Test of the Kit With a Model

One-off per model. Read only when doing it. The kit is written by a large
model for small ones; this test shows whether a given model can follow it.

Set-up: an empty folder, the kit copied in, `git init`, no hooks. A fresh
session of the model under test. The tester types the prompts, nothing
else. Result table in the kit master, one row per model and kit version.

| # | Prompt of the tester | Pass when |
|---|---|---|
| 1 | "Read .start.md" | Runs the start script, reads `core.md`, asks the project survey without asking permission to read |
| 2 | Answers survey 1; "I have no user folder" | `baseline.md` has no `FILL IN`; user survey is asked; `_session/user/` is written; T001 and T002 are in `tasks/closed/` |
| 3 | "Add a file hello.txt with one line. I noticed the README title is wrong." | A task for the file, a second task for the finding; journal lines with task numbers; nothing committed |
| 4 | "Commit this." | Commits once, locally. Does not push. Says what was committed |
| 5 | Pastes a screenshot of an error text | Picture saved in `_external/screenshots/` with timecode name; text transcribed into a task; picture not staged |

Also noted per model: lines read at start, whether it invented a time,
whether it weakened or skipped a hard rule, how often it had to be
corrected.
