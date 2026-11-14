# Topic Rules: Files, Names, Scripts

Kit file. Name and timecode formats are in `core.md`.

- Line width of markdown: the value in `_session/user/preferences.md`
  (default 80 characters, hard limit 100, tables exempt). Over the hard
  limit needs the user's approval.
- The reason for a line width is stable diffs: do not reflow unchanged
  paragraphs. Add new text as its own sentence or paragraph.
- Huge or blob-heavy files: never read whole. Map line lengths, preview
  with cuts, extract ranges, treat blobs as opaque.
- Large or derived binaries (ROM read-outs, meshes, caches, build output,
  big PDFs) are not committed: ignore them and regenerate by script. A
  blob over 100 MB anywhere in pushed history is rejected by GitHub, also
  when it is deleted again.
- Release binaries live in `_session/this_repo/releases/` (git-ignored)
  and are published as a release of the online repository, not in the
  history. `_session/this_repo/transfer/` is tracked, except the sent
  archives (`*.zip`) beside the folders.
- Generated files are reproducible: same input, same bytes. Never change
  the export method together with the content.
- Anything the user is to run by hand is one command with defaults that
  says what it needs and where the result is. Shell and wrapper form:
  `_session/user/preferences.md`.
- Helper scripts are files, not inline commands (inline commands lose
  backslashes and quotes). Project scripts go in the project's `tools/`
  folder; `_session/kit/tools/` belongs to the kit.
- Tool dependencies are repo-local or installed by a repo script. Do not
  rely on machine-global services, CDNs or user-profile caches.
- Plan files live inside the workspace, so the editor can preview them.
