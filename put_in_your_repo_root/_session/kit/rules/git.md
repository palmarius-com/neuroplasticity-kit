# Topic Rules: Version Control

Kit file. Applies when `baseline.md` says the project uses git. Hard Rule
1 applies first.

- Commit = local only. Push = upload to the remote. Separate operations: a
  commit never includes a push.
- Editing files is fine; leave changes in the working tree. Finish the
  work, update tasks and docs, say what is uncommitted, and wait.
- Work on the next version stays uncommitted until the user has seen it.
- Before a commit: if dirty files are not ours, name them and ask. Never
  stage around them silently; no index tricks.
- When ambiguous, ask. Confirm the action before executing; report what was
  done after.
- Commit only as the identity in `baseline.md`, never as another account
  without the user's explicit request. The start script shows the
  configured identity.
- Closing a task is a file move. Move the file unchanged, so the history
  shows a rename.
- After any pull: run the check for duplicate task numbers
  (`rules/tasks.md`).
- `.gitignore`: the kit's lines stand between `# >>> session kit` and
  `# <<< session kit`. Never remove them; project lines go outside the
  block.
