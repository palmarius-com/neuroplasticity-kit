# Hooks: What the Harness Does So Nothing Is Forgotten

A hook is the user's own automation: the harness runs it, not the
assistant. The user installs the hooks once per machine. Whether they are
installed on a machine is noted in `_session/user/user.md`, "Machines";
the shared `baseline.md` does not say it.

| Script | Event | Does |
|---|---|---|
| `journal_stamp.ps1` | every prompt, every reply | writes the `prompt` and `reply` journal lines with the real clock |
| `session_start.ps1` | session start, resume, clear, compaction | runs `start.ps1` and orders the session start of `core.md` |
| `topic_reminder.ps1` | every prompt | names the topic files of `core.md` the prompt touches |

Not installed: the assistant writes the journal lines itself, and the user
says "read .start.md" at every start and after every compaction.

## Journal Stamp

Writes `prompt` and `reply` lines, so no time is invented and no line is
forgotten. The task number comes from `_session/this_repo/current_task`.

## Session Start

A compaction replaces a long conversation by a summary. The rules the
assistant read at session start are gone with it, and the harness says
"resume directly". Only a hook at the same moment wins against that text.
`session_start.ps1` runs at every start and after every compaction: it
runs `start.ps1` and tells the assistant to read `core.md`, the user files
and `baseline.md` before any other work.

After a compaction the journal line is `context compacted (hook)`, not
`session start`: the session goes on, and the time of the turn is counted
on. `start.ps1` writes one start line per start: a second run within 5
minutes (the assistant after "read .start.md") writes no second line.

## Topic Reminder

`core.md` says "before mail work read `messages.md`". Nothing makes that
happen. `topic_reminder.ps1` matches words of the prompt (English and
German) against the topic table and adds one reminder line; no match, no
output. It also repeats Hard Rule 1 (git) and Hard Rule 4 (mail client)
when the prompt names them. The word table is at the top of the script. A
project with its own words (customers, products) copies the script into
its own `tools/hooks/` folder and installs that copy.

## Claude Code

In `.claude/settings.local.json` of the repository (personal, not
committed) or in the user settings:

```json
{
  "hooks": {
    "SessionStart": [ { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/session_start.ps1"
    } ] } ],
    "UserPromptSubmit": [ { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/journal_stamp.ps1 -Event prompt"
    } ] }, { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/topic_reminder.ps1"
    } ] } ],
    "Stop": [ { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/journal_stamp.ps1 -Event reply"
    } ] } ]
  }
}
```

`SessionStart` without a matcher runs for all four sources. If a hook does
not run with the repository as working folder, give the full path to the
script. After a change of the settings file: reload the window or open
`/hooks` once.

Verified with the harness on Windows (2026-11-14 and 2026-11-15): the
journal stamps, the topic reminder, and the session start after a real
compaction (the hook text won against "resume directly"). On macOS
(2026-11-16): the journal stamps by the harness, the other two by hand
with sample input.

## Cline and Others

Not written yet. Cline has task hooks; the event names and the file they
are configured in must be read from its documentation first. The scripts
to call are the same.

## What a Hook Cannot Know

- Whether the user was at the desk. The timetable shows `assistant` time
  (prompt to reply) in its own column for that reason.
- A change of task inside one prompt. The assistant changes
  `current_task` when the topic changes; lines before that carry the old
  number.
- Whether the assistant read a file. A hook can only remind.
