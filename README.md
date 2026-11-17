# neuroplasticity-kit

Starter kit for working with AI coding assistants. Gives every session the
same start: rules, tasks, journal and time tracking live in files in the
repository, not in the model's memory.

## The Idea

An AI assistant forgets everything between sessions. A person does not
remember every word either. What stays with us is the gist, and when the
exact words matter we keep a diary. The kit gives an assistant the same
kind of memory:

| A mind | The kit |
|---|---|
| Changes through use | You correct the assistant; the correction becomes a rule; the rules of all your projects flow back into the kit |
| Keeps the gist, not the wording | Tasks, project baseline and transcripts are in version control |
| Needs a diary for exact recall | A journal, appended line by line, never rewritten |
| Does not store everything it saw | Screenshots, documents and big binaries stay outside version control; their gist is written down |

That is neuroplasticity: it evolves while you use it, and it keeps its
memory across sessions and across models.

## Install

1. Copy the **content** of `put_in_your_repo_root/` into the root of your
   repository. If you already have a `README.md` or a `.gitignore`, keep
   yours; the first session merges them.
2. Start a session with your assistant and say: "Read .start.md"
3. Answer two short surveys: one about the project, one about you. If you
   have a user folder from another project, give its path instead.
4. Once per machine: install the hooks
   (`_session/kit/tools/hooks/readme.md`). They stamp the journal with the
   real clock, start the session by themselves, bring the rules back after
   a context summary, and remind the assistant of the topic rules.

## How It Works

Everything a session must know is written down, in three places with
three owners:

| Folder | What | Who changes it |
|---|---|---|
| `_session/kit/` | The method: rules, procedures, tools. The same in every repository. | Nobody, in a project. It is replaced by a newer kit. |
| `_session/user/` | You: who you are, how you commit, your machines, how you like to work. | You. |
| `_session/this_repo/` | The project: what it is, the tasks, the journal. | Every session. |

The root of the repository keeps only `.start.md` (the pointer) and
`README.md` (for humans).

### Every Session

```
You: "Read .start.md"   (or the session start hook does it)
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

### What Is in Version Control and What Is Not

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
`_session/user/` is carried by hand too
(`_session/kit/procedures/handoff.md`).

### Several People in One Repository

Everything in `_session/this_repo/` is shared through version control, so
it holds only what is true for everyone: what the project is, its rules,
the tasks. What is true for one person or one machine (the name and
address you commit with, local paths, installed versions, whether the
hooks are installed) is in your own `_session/user/`, which is never
committed. Each person has their own; nobody overwrites anybody.

The journal has one file per day and machine, so two people never edit
the same file. Two people can hand out the same task number; the check
script finds it after a pull and `renumber.ps1` fixes it.

### Tasks

One file per task in `_session/this_repo/tasks/open/`. A task is closed by
moving its file, unchanged, to `tasks/closed/`: the folder is the status.
`tasklist.md` is a generated index.

### Journal and Time

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

### How Rules Change

- Tell the assistant when it does something you do not like. The fix is
  written into `_session/this_repo/kit_proposals.md`, with your words and
  the date, and holds in that project at once.
- The assistant also writes there what it finds wrong with the kit itself.
- The assistant never loosens a rule on its own. Only your own words do,
  quoted next to the rule.
- `_session/kit/procedures/neuroplasticity.md` collects the proposals of
  all your projects; you say which become general; the kit gets a new
  version.

### Tools

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

The kit holds nothing personal. Someone else gets the kit folder, starts
a session, and answers the two surveys. Language, reply style, shell and
what the assistant may do come from their answers.

## What You Get

- The assistant reads its rules on its own and asks before it changes your
  code.
- It never commits or pushes without your word.
- Every topic is a task with its own file. Nothing gets lost.
- A journal with real times, and a timetable computed from it.
- Clean room: originals stay on your disk, only their gist is in version
  control.
- When the assistant does something wrong, tell it. The fix becomes a
  rule, and the next session remembers.

## Needs

PowerShell for the tools (Windows PowerShell 5.1 or PowerShell 7). Git is
optional. Any assistant that can read files and run one command.

## Give Back

- Keep the credit line and the link where you use the kit.
- Send what you learned: a rule that proved itself, a rule that did harm,
  a test result for your model. By issue, not by pull request; why and
  how is in `CONTRIBUTING.md`.
- Setup, migration of existing repositories and training are offered as a
  service.

## Licence

neuroplasticity-kit by Dipl.Ing. C. Sale, Palmarius GmbH,
[www.palmarius.com](https://www.palmarius.com)

Creative Commons Attribution 4.0 International, see `LICENSE` and
`NOTICE.md`. Use it, change it, share it, also commercially; give the
credit line with the link, name the licence, and say what you changed.

A licence without the duty to give credit is available from the rights
holder on request; contact in `NOTICE.md`.

*Palmarius* is Latin: worthy of the palm, the prize of the victor. What
earned the palm was the masterpiece.
