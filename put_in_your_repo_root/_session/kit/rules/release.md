# Situation Rules: Release and Shipping

Kit file, identical in every project, changed only through the kit. Read
before a release, before a unit ships and before a package is sent.

- What has shipped cannot be fixed by us. Anything that can reach a shipped
  unit (firmware, update, licence, storage, calibration) is proven on a
  test unit first, in the exact state the shipped units are in, update path
  included, and must be fail-safe. When in doubt, do not ship it.
- Before a release: the full test, the release check as a user
  (`rules/testing.md`) and the fixed regression set of known faults.
- Log every unit that leaves, before it ships: build, state, what went with
  it, how, date. In the task and in the journal.
- A sent package is never changed again. One folder per send,
  `_session/this_repo/transfer/<timecode>_<what>/` (tracked), the sent
  archive beside it (ignored). A new send gets a new folder.
- Release binaries: `_session/this_repo/releases/<timecode>_<version>/`
  (ignored), published as a release of the online repository. Keep only
  builds that were deployed and that the user approves.
- Work on the next version stays uncommitted until the user has seen it.
