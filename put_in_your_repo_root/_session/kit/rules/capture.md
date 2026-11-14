# Topic Rules: Capture and Documentation

Kit file. Hard Rules 9 and 10 apply first.

## Originals and Gist

- Originals go to `_external/`, which is git-ignored (clean room: as
  little as possible is exposed to version control):
  - `_external/screenshots/<timecode>_<brief_what_we_see>.<ext>` for
    screenshots and pasted pictures, format as received;
  - `_external/documents/<timecode>_<what>.<ext>` for documents, mails,
    attachments, logs;
  - `_external/downloads/<timecode>_<what>.<ext>` for what was fetched
    from the web.
- Every original gets its gist in the repository, in the same turn:
  transcription or description, with the file name of the original, in the
  task file or in the docs next to the work. The gist must be enough to
  work without the original.
- Text screenshots (forum, chat, mail) are transcribed in full: text as
  posted, typos kept, numbers and times. A summary may follow, never
  replace.
- Pasted pictures live only in the scratchpad of the session: copy them to
  `_external/screenshots/` before answering.
- Originals stay on the machine where they were saved. The user carries
  them to another machine by hand when needed and backs them up
  (`_session/user/preferences.md` says how).
- An attachment handed over: check its size (0 bytes = destroyed, look for
  another copy).

## Nothing Stays Only in the Chat

- Every pasted text longer than a few lines, every spoken fact and every
  decision is written down in the same turn.
- Facts found while working (specs, web pages, data sheet values) go into
  the docs next to the work, with the source.
- Never cite evidence without saying where its file is, or "NOT IN REPO".
- Evidence gaps are listed in `baseline.md`, "Pending". Ask for them at
  session start and at each change of topic, again and again, until they
  are in. Here the assistant is meant to be annoying (evidence only; never
  for commit, push or release).

## Documentation

- Update the docs as you go, not at the end. A turn is not finished until
  the docs are done or the deferral is stated.
- `README.md` is for a human reading years later: plain prose, no task
  numbers, no operator rules, no command lists. The root README lists all
  other READMEs. Touch it only when the story a newcomer reads has
  changed.
- `baseline.md` holds no session story: events go to the journal, findings
  to the task.
- Wrong comments or docs are replaced, not corrected by appending.
- Deliverables, evidence that may be shared, derived files and helper
  scripts go in a visible folder of the repository. Delete what is not
  needed.
