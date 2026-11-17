# Project Survey (Task T001)

Kit file. Asked once, when `_session/this_repo/baseline.md` still holds
`FILL IN`. Six questions, each with four options; the question tool adds
"other". Two popups: questions 1 to 4, then 5 and 6. No question tool: ask
as plain text with numbered options.

First let the start script's output answer what the environment already
shows (version control present, shell, machine). Do not ask what is known.

Every answer changes a file. Write the answers into `baseline.md`,
"Settings", with the date; then do what the right column says.

| # | Question | Options | Sets |
|---|---|---|---|
| 1 | What kind of project is this? | Software; Firmware with hardware; Documents and design; Mixed | `baseline.md` Scope; active topic files (`hardware.md` only with hardware); first paragraph of `README.md` |
| 2 | Who is it for? | Myself; A customer, no NDA; A customer, under NDA; Public or open source | `baseline.md` setting `nda` and Scope; under NDA: note in Project Rules; public: `_session/user/` and `_external/` must stay ignored |
| 3 | Version control? | Git with a remote; Git, local only; No git yet, set it up; No version control | `baseline.md` setting `git`, Version Control section (branch, remote; the commit identity goes to `user.md`); `rules/git.md` active or not; "set it up" is its own task |
| 4 | What leaves the project? | Software releases; Hardware units; Documents or packages; Nothing | active topic files `release.md`, `messages.md`; folders `releases/`, `transfer/` created or not |
| 5 | How is time handled? | Billed per task; Tracked, not billed; Tracked for some tasks; Not tracked | `baseline.md` setting `time`; not tracked: hooks optional, no gap questions |
| 6 | The repository already has a `.gitignore`. What with the kit's lines? | Add the kit block to it; Show me the lines, I add them; Track everything, no kit block; No `.gitignore` here | root `.gitignore`; "track everything": originals are committed, say so in Project Rules |

Question 6 is asked only when a `.gitignore` exists; else the kit's
`.gitignore` is used as it is.

After the answers:

1. Fill `baseline.md`: Scope, Settings, Version Control, active topic
   files. Nothing per person or per machine: that is `_session/user/`.
2. Write the project paragraph of `README.md` and show it to the user.
3. Journal line with the answers in short form. Close T001.
