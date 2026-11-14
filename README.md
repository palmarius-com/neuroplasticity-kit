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
3. Answer two short surveys: one about the project, one about you.

Then read `_session/kit/how_does_it_work.md` in your repository. It
explains the folders, the journal, how time is counted and how rules
change.

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
