# Procedure: Neuroplasticity - Update the Kit From the Projects

One-off. Read only when doing it.

The session files evolve in every project. Same user, so the rules evolve
in the same direction. This procedure collects what is general, lets the
user decide, and brings out a new kit version.

## Constraints

- Write only to the kit master. Never write to a source project.
- No subagents. This is a task: task file, journal lines.
- No commit, no push.
- Nothing personal and nothing confidential in the kit: no names of
  customers or suppliers, prices, passwords, addresses, serial numbers.
  What is the taste of one user goes to that user's `_session/user/`, not
  into the kit.

## Steps

1. The user names the source projects (paths). Per source: kit version
   (`_session/kit/version`), or "old layout".
2. Collect candidates:
   - kit layout: `_session/this_repo/kit_proposals.md` (older projects:
     `baseline.md`, "Rule Candidates"); `baseline.md`, "Project Rules";
     the files in `project_rules/`;
     `user/principles.md` and `preferences.md`, "More";
   - old layout: the rule sections of its baseline or entry file only.
     Large files: map the headings first, do not read project history;
   - a kit file that differs from the manifest was edited in the project:
     list the difference as a candidate.
3. Sort every candidate: method (holds for any user in any project),
   person (this user's taste), project. A project rule that shows a
   general pattern is rewritten as the pattern.
4. Report to the user in one table: new rules, rules that sharpen an
   existing one, rules that would loosen one, conflicts between projects
   (the newest statement of the user is the proposal).
5. STOP and ask. The user decides each candidate. Nothing is promoted on
   the assistant's own judgement.
6. Write what was decided: `core.md` only for what must hold always (hard
   rules stay at about twelve), else the fitting file in `rules/`. One-off
   jobs go to `procedures/`.
7. Keep it compact for small models: short imperative sentences, one rule
   per bullet, no history. Every "never", "always", "only when", every
   number and every exception stays.
8. Set `version` to the current timecode. With the user's word run
   `tools/manifest.ps1` and `tools/check.ps1`.
9. Write a dated note in the kit master: what was promoted, from which
   project, what was refused, how conflicts were settled.
10. In each source project's `kit_proposals.md`, with the user's word:
    set the status of every proposal (in the kit since version ..., or
    refused, with the reason).
11. Report which projects are behind the new version. Replacing
    `_session/kit/` there is a copy, done by the user or as a task in that
    project.
