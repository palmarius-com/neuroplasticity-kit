# Topic Rules: Debugging

Kit file.

- Faults (hangs, timing problems, crashes) are read, not guessed. First
  step is evidence: logs, stack traces of all threads or tasks, timestamps.
  Not a configuration experiment.
- One change per experiment, so each result has one cause.
- Do not filter logs or output while looking for a cause.
- Before suspecting our code, check the known limits of the tool or
  simulator in use.
- Deploy only from a clean build. An incremental build can miss changes.
- Every verification run gets a short report in the task file, in the same
  session: setup, expected, measured, result, findings with task numbers,
  what was not tested.
