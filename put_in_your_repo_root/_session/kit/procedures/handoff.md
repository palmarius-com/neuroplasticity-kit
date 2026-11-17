# Procedure: Handoff to Another Machine

One-off. Read only when doing it. Git carries the repository; it does not
carry what is ignored on purpose. Without a list the first hour on the new
machine is spent finding out what is missing.

This is a task. Write the handoff file before the old machine is left:
`_session/this_repo/handoff_<machine>_<yyyyMMdd>.md`. No secret and no
personal detail in it: it is in version control. It says where a thing
is, not what it holds.

## What the File Holds

1. Carry by hand (not in git, on purpose): `_session/user/`, the
   originals in `_external/`, keys and certificates, built binaries and
   `_session/this_repo/releases/`, mail archives, the settings of the
   harness (`.claude/settings.local.json`, hooks). Per item: where it is,
   how it travels, whether the work can start without it.
2. First hour on the new machine: clone or pull, copy the hand-carried
   items, set the git identity (`user.md`, "Commit as"), install the
   hooks, session start, `tools/check.ps1` with the user's word.
3. What waits for the old machine: work that needs its hardware, its
   licences or its data. Each with its task number.
4. What can be done on the new machine.
5. State of the work: current task, uncommitted and unpushed changes
   (none is the goal), open branches and the decisions they wait for.
6. The agreements that cost most when forgotten, each with the file that
   holds it.

## Steps

1. Old machine: commit and push with the user's word, so nothing lives in
   one working tree only. Write the file. Note in
   `_session/user/user.md`, "Machines", what the old machine has that the
   new one will not.
2. New machine: follow "First hour". Add a block for the machine to
   `user.md`, "Machines". The start script names what is missing.
3. Journal line on each machine: handoff written, handoff read.
4. When the work goes back: the same file in the other direction, or a
   new one. An old handoff file is history; it is not edited.
