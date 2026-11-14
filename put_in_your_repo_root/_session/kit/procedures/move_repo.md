# Procedure: Move a Repository to Another Folder or Disk

One-off. Read only when doing it.

1. Before: note the file count and the output of `git status --ignored`.
2. Copy everything, also ignored and hidden files and folders
   (`robocopy /E` on Windows). A copy tool that skips `.gitignore`,
   `.gitattributes` or folders with common names (`obj`) breaks the build
   in ways that look like something else.
3. Ignored originals (`_external/`) and `_session/user/` are not in version
   control: they exist only in this copy. Check that they arrived.
4. After: compare file count and `git status --ignored` with the notes.
5. Paths in scripts and editor settings must be relative to the file or
   the workspace. List absolute ones and fix them.
6. A build that misses a downloaded dependency: move that dependency
   folder aside and build again (versions are pinned by the lock file).
7. Do not work from a folder that a sync service renames files in.
