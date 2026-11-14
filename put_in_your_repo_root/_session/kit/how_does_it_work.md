# How Does It Work?

A set of files that gives every AI session the same start: same rules,
same memory, no explaining things twice. For humans; the assistant reads
`core.md`.

## The Idea

The assistant remembers nothing between sessions. Only files count. So
everything a session must know is written down, in three places with three
owners:

| Folder | What | Who changes it |
|---|---|---|
| `_session/kit/` | The method: rules, procedures, tools. The same in every repository. | Nobody, here. It is replaced by a newer kit. |
| `_session/user/` | You: who you are, how you like to work. | You. |
| `_session/this_repo/` | This project: what it is, the tasks, the journal. | Every session. |

The root of the repository keeps only `.start.md` (the pointer) and
`README.md` (for humans).

## Setup (once per repository)

1. Copy the content of the kit folder into the root of the repository:
   `.start.md`, `.gitignore`, `_session/`, and `README.md` if there is
   none (else keep yours; the survey adds a section).
2. Start a session and say: "Read .start.md"
3. The assistant asks two short surveys: about the project (task T001) and
   about you (task T002, "introduce yourself"). If you have a user folder
   from another project, give its path instead.
4. Optional, once per machine: install the hooks
   (`_session/kit/tools/hooks/readme.md`), so the times in the journal come
   from the clock and not from the assistant.

Details: `procedures/setup_new_repo.md`.

## Every Session

```
You: "Read .start.md"
   |
start.ps1         prints: kit version, machine, git identity, the tasks
   |              worked on last, time since then, open gaps
core.md           the rules that always hold (12 hard rules first)
user/             who you are
this_repo/baseline.md   what this project is
   |
"Anything changed since last session?"  +  questions about gaps
   |
Work. Every topic is a task (one file). Every event is a journal line.
Topic rules are read when their topic comes up.
```

You never close a session. The next start asks how long you still worked.

## What Is in Version Control and What Is Not

Clean room: as little as possible is exposed.

| In version control | Not in version control |
|---|---|
| Tasks, journal, baseline | `_session/user/` (personal) |
| Transcripts and descriptions (the gist) | `_external/screenshots/` |
| `_session/this_repo/transfer/` folders | `_external/documents/` |
| The kit | `_external/downloads/` |
| | `_session/this_repo/releases/`, sent `*.zip` |

The gist is in the repository at all times: every screenshot, document or
download gets a transcription or description there. The originals live on
the disk where they were saved. Carry them to another machine by hand if
you need them there, and back them up; the user survey asks how.
`_session/user/` is carried by hand too.

## Tasks

One file per task in `_session/this_repo/tasks/open/`. A task is closed by
moving its file, unchanged, to `tasks/closed/`: the folder is the status.
`tasklist.md` is a generated index.

## Journal and Time

`_session/this_repo/journal/` holds one file per day and machine. Only
appended, never changed. Every line: time, task number, what happened.

Time is your real time. It is never typed into a task; `times.ps1`
computes `timetable.md` from the journal:

- `user`: from a reply to your next prompt (reading, thinking, writing);
- `assistant`: from your prompt to the reply, also when you are away;
- `running`: jobs that run alone (`run start` to `run end`);
- `adjust`: what you dictate ("add 1.5 hours, phone call").

No break is ever assumed. Up to 2 hours between two lines counts in full
and is listed, so you can correct it. More than 2 hours counts zero until
you answered the question at the next session start.

## How Rules Change

- Tell the assistant when it does something you do not like. The fix is
  written into `baseline.md`, "Rule Candidates", with your words and the
  date, and holds in that project at once.
- The assistant never loosens a rule on its own. Only your own words do,
  quoted next to the rule.
- `procedures/neuroplasticity.md` collects the candidates of all your projects;
  you say which become general; the kit gets a new version.

## Tools

In `_session/kit/tools/` (PowerShell):

| Script | Does | Changes files |
|---|---|---|
| `start.ps1` | Report at session start | appends one journal line |
| `check.ps1` | Names, line width, tasks, journal, kit unchanged | no |
| `times.ps1` | Journal to `timetable.md` | that one file |
| `task.ps1` | Open, close, switch a task; index | task files, journal, index |
| `renumber.ps1` | New number for a task after a pull | task file, journal |
| `manifest.ps1` | Hashes of the kit files (kit master only) | `manifest` |

Only `start.ps1` runs without your word. For the others the assistant
asks, unless you list them in `baseline.md`, "Allowed Without Asking".

## Sharing the Kit

The kit holds nothing personal. Someone else gets the kit folder, starts a
session, and answers the two surveys. Language, reply style, shell and
what the assistant may do come from their answers.
