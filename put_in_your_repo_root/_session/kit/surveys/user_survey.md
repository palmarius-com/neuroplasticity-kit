# User Survey (Task T002: "Introduce Yourself")

Kit file. Asked once, when `_session/user/user.md` is missing.

First ask one question: "Do you already have a user folder from another
project?" Options: Yes, I give you the path; No, ask me; Later. With a
path: copy that folder's files into `_session/user/`, show the user what
was copied, ask whether "Commit as" holds in this repository too, add a
block for this machine under "Machines" if there is none, close T002.
"Later": T002 stays open; work with the kit defaults.

Otherwise six questions, each with four options; the question tool adds
"other". Two popups: questions 1 to 4, then 5 and 6.

Every answer sets a line. Copy `kit/templates/user/*.md` to
`_session/user/` and fill them.

| # | Question | Options | Sets |
|---|---|---|---|
| 1 | Which language for replies and for the files? | English; German; Replies in my language, files in English; As I write to you | `preferences.md`: `language_replies`, `language_files` |
| 2 | How should replies read? | Very short, fragments; Short and plain; Detailed, with reasons; Teach me step by step | `preferences.md`: `reply_style` |
| 3 | How much experience do you have? | Professional engineer; I program as a hobby; I am learning; I do not program | `user.md`: Experience, "Explain in terms of" |
| 4 | Which machine and shell? | Windows, PowerShell; macOS, zsh; Linux, bash; Several machines | `preferences.md`: `shell`, `machines`; `user.md`: a block under "Machines" for this machine; commands the assistant proposes |
| 5 | What may the assistant do without asking? | Nothing beyond reading; Edit files, ask before running anything; Also build and test; Also commit locally | `preferences.md`: `allowed_without_asking`. The Hard Rules stay; an answer that loosens one is the user's word and is quoted with the date |
| 6 | Originals in `_external/` are not in version control and live on this disk only. How are they backed up? | This disk is backed up; A synced or cloud folder; I carry them by hand; No backup, I accept the loss | `preferences.md`: `originals_backup`; no backup: the gist in the repository must be complete enough to work without them |

After the answers:

1. Fill `user.md` and `preferences.md`. `principles.md` stays empty until
   the user states a principle; then it is written there with the date.
2. With version control: show the identity the start script printed and
   ask "Commit as this identity here?" The answer is `user.md`, "Commit
   as". It is never written into `baseline.md`.
3. Tell the user: `_session/user/` is git-ignored, it is personal. It is
   carried to another machine or project by hand. Every person who works
   in the repository has their own.
4. Journal line: "T002 user files written". No personal detail in the
   journal. Close T002.
