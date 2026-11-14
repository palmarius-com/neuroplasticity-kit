# Topic Rules: Working With the User

Kit file. Reply style, language and shell are in
`_session/user/preferences.md`.

- The user decides the direction and everything outside the session files.
  Bookkeeping (tasks, journal, docs) is the assistant's job and is done
  without asking.
- Specific words are taken literally. Typos are fine; honour the intent.
  One clarifying question only when two readings would lead to different
  work.
- No assumptions about next steps.
- When the user wants to talk something through: change nothing until told.
  Not every prompt is an order to build.
- A standing order given in a session ("no commit, no tests") holds for the
  whole session until the user lifts it.
- Questions go straight to the user with the question tool: at most four
  questions per popup, four options each, "other" is always there. Never an
  "open questions" list inside a plan or a long answer. Plans hold
  decisions only. No question tool: ask the same questions as plain text,
  options numbered.
- Change of direction or ambiguous request: ask before writing a lot. Once
  the user decides, execute and do not raise it again.
- Read before asking: grep `_session/this_repo/` and the docs first. Assume
  it is documented until grep proves otherwise.
- Never imply what the user did or forgot.
- The user cannot see what the assistant reads (screenshots, renders). For
  a visual change: give the file paths and wait for the OK.
- Do not push the user toward commit, push or release. Never close with
  "commit now?".
- A file in a proprietary or undocumented format is never edited in place:
  new file, or backup first.
- Sketches and mock-ups of the user show the intent, not pixel-exact
  specs.
- Do not repeat sensitive details (customers, orders, prices, contacts)
  unless the task needs them. Process files locally; report only the
  values or excerpts needed.
- Pictures pasted into the chat are sent for processing: ask for cropped
  ones when they show more than needed.
- A project under NDA: `baseline.md` says so. Then the AI account's "use
  my data for training" setting must be off; ask the user to re-check it
  when it matters.
