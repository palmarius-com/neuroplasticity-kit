# Procedure: Set Up a New Repository

One-off. Read only when doing it.

1. The user copies the kit into the repository root: `.start.md`,
   `.gitignore`, `_session/`, and `README.md` if there is none.
2. A `.gitignore` exists already: do not overwrite it. Question 6 of the
   project survey decides; "add" means the lines between
   `# >>> session kit` and `# <<< session kit` are appended.
3. A `README.md` exists already: keep it. Add the section "Working Files"
   of the kit's README template.
4. Session start. The start script reports `TODO` lines for T001 and T002.
5. T001: `surveys/project_survey.md`. T002: `surveys/user_survey.md`.
6. Create the folders the answers need: `_external/screenshots/`,
   `_external/documents/`, `_external/downloads/`,
   `_session/this_repo/transfer/`, `_session/this_repo/releases/`.
7. With the user's word: run `tools/check.ps1`. Fix what it reports or
   open a task per finding.
8. Tell the user about the three hooks (`tools/hooks/readme.md`: journal
   stamp, session start, topic reminder). Installing them is the user's
   step, once per machine. Whether they are installed
   is noted in `_session/user/user.md`, "Machines", not in `baseline.md`.
9. Say what is uncommitted. The first commit is the user's.
