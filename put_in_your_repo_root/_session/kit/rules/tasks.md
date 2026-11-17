# Topic Rules: Tasks, Journal, Time

Kit file. Formats are in `core.md`.

## Tasks

- Everything is a task, also setup, rules work and talk about rules. New
  topic or change of topic: new task with the next free number.
- One task per coherent piece of work, not per changed line. Do not split
  into tiny tasks.
- Every finding (bug, discovery) is its own task: symptom, cause, fix. One
  line in the parent names it. Never bundle findings, never bury one in
  another task. Not fixable now = stays open.
- Work done before a task existed gets a retrospective task. A task that
  is split keeps its number; the follow-ups get new ones.
- Keep the task file current while working (work done, findings, what is
  open), without being told.
- Open: create `tasks/open/tNNN.md` from `kit/templates/task.md`, write the
  journal line `Tnnn opened: title`, put the number into `current_task`.
- Switch: change `current_task` first, then work. The hooks stamp with the
  number they find there.
- Close as soon as the work is done, without asking: move the file,
  unchanged, to `tasks/closed/`, write the journal line `Tnnn closed`.
- "Waiting for the user" or "blocked" is not a status. It is the first
  line under "Open" in the task file.
- `tools/task.ps1` does open, close, switch and the index in one step. It
  is used when `baseline.md` allows it, else the same steps by hand.
- After a pull: two machines can hand out the same number. The check
  script finds it; `tools/renumber.ps1` renames the local task and writes
  the `renumber` line.

## Journal

- Append only. Never change or delete a line. A correction is a new line
  that names the old one.
- A line says when, in one line. What and why go into the task file. Do
  not write the same fact in three places.
- Every line carries the task number it belongs to.
- Facts only. `(seed)` marks a line written later from records. A guess
  says "guess".
- One file per day and machine, so two machines never edit the same file.

## Time

- Time is the user's real time. It is never written into a task file; it
  is computed by `tools/times.ps1` into `timetable.md`.
- Columns per task: `user` (from a reply to the next prompt: reading,
  thinking, writing), `assistant` (from a prompt to its reply; counts also
  when the user is away), `running` (from `run start` to `run end`),
  `adjust` (lines the user dictates). The sum is all four.
- Work that runs without anyone (over-night test): write `run start` when
  it starts and `run end` when its result is read.

## Gaps

- No break is ever assumed. An interval of up to 2 hours between two
  journal lines is counted in full. The timetable lists these intervals;
  the user corrects one with an `adjust` line.
- An interval of more than 2 hours counts zero until the user has answered.
  The start script lists them. Ask with the question tool, one question
  per gap: "After <time> you worked how long on <task>?", four options in
  steps of 15 minutes (the most likely values), "other" as free-text option.
- Write the answer as `- <now> <Tnnn> gap <timecode of the line before the
  gap> <hours>h`.
- Ask at session start also for work done without the assistant (bench,
  phone, CAD). Each answer is an `adjust` line with its task number.
