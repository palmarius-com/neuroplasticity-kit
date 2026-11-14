# Hooks: the Harness Stamps the Journal

A hook is the user's own automation: the harness runs it, not the
assistant. It writes `prompt` and `reply` lines with the real clock, so no
time is invented and no line is forgotten. The user installs it once per
machine. Not installed: the assistant writes these lines itself.

The task number comes from `_session/this_repo/current_task`.

## Claude Code

In `.claude/settings.json` of the repository (or the user settings):

```json
{
  "hooks": {
    "UserPromptSubmit": [ { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/journal_stamp.ps1 -Event prompt"
    } ] } ],
    "Stop": [ { "hooks": [ {
"type": "command",
"command": "pwsh -NoProfile -File _session/kit/tools/hooks/journal_stamp.ps1 -Event reply"
    } ] } ]
  }
}
```

Not verified on a machine yet (written 2026-11-14): whether the hook runs
with the repository as working folder on Windows. If not, give the full
path to the script.

## Cline and Others

Not written yet. Cline has task hooks; the event names and the file they
are configured in must be read from its documentation first. The script to
call is the same.

## What the Hook Cannot Know

- Whether the user was at the desk. The timetable shows `assistant` time
  (prompt to reply) in its own column for that reason.
- A change of task inside one prompt. The assistant changes
  `current_task` when the topic changes; lines before that carry the old
  number.
