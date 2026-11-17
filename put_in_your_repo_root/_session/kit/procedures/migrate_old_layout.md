# Procedure: Migrate a Repository From an Old Layout

One-off. Read only when doing it. Old layouts: `SESSION_BASELINE.md`,
`TASKLIST.md`, `JOURNAL.md`, `RULES.md`, `CLAUDE.md` or `AGENTS.md` in the
root.

Nothing that is there may get lost. Nothing is deleted in this procedure:
old files are moved, never removed, and the user removes them later.

## Before

1. This is a task in that repository. Ask the user first; say what will be
   moved.
2. The working tree should be clean, so the migration is one reviewable
   change. Dirty files that are not ours: name them and ask.
3. List the root files with size and lines. Map the headings of the big
   ones. Do not read project history in full.

## Steps

1. Copy the kit: `.start.md`, `_session/kit/`, the blank
   `_session/this_repo/` skeleton. Old `.start.md`: moved to the legacy
   folder first.
2. `.gitignore`: append the kit block, keep every existing line. If the
   repository already tracks files under `_external/`: stop and ask; they
   stay tracked until the user decides.
3. Legacy folder `_session/this_repo/legacy/<timecode>_old_layout/`: move
   the old session files there unchanged (old baseline, rules file, entry
   files, task list, journal). They stay readable and searchable.
4. Baseline: write `_session/this_repo/baseline.md` from the project parts
   of the old baseline (scope, branch and remote, project rules, tool
   notes that hold on every machine, pending). Session history in the old
   baseline is not copied; it stays in the legacy file, and `baseline.md`
   says where. The commit identity and the notes about one machine go to
   `_session/user/user.md` (step 8), not into `baseline.md`.
5. Rules in the old files that are not in the kit: project rules go to
   "Project Rules" (long ones: files in `project_rules/`, each with a row
   in "Project Topic Files"); rules that look general go to
   `kit_proposals.md` with their origin. Nothing is dropped silently: what is not taken over is
   listed in the migration task with the reason.
6. Tasks: one file per task. Open tasks get a full file. Closed tasks:
   one file each when the list is small; for a long list (hundreds) ask
   the user: files for all, or the old list stays in the legacy folder as
   the archive and only open tasks become files. Numbers are kept.
   A task-number prefix other than `T` is kept in the title; the file gets
   the `T` number.
7. Journal: an old journal stays in the legacy folder. Write one seed line
   per old task with a known date, marked `(seed)`, only if the user wants
   times for old work.
8. User: the user gives the path of an existing `_session/user/`, or T002
   is opened.
9. `README.md`: keep it; replace only the section that describes the
   session files.
10. Tools of the old layout (check scripts, hooks that name old files):
    list them in the task; do not delete.
11. With the user's word: `tools/task.ps1 index`, `tools/check.ps1`. One
    task per finding.
12. Report: what moved where, what was not taken over and why, what the
    user has to decide. No commit.
