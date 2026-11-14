# Situation Rules: Testing

Kit file, identical in every project, changed only through the kit. Read
before writing or changing a test, before a release check and before
driving the real window. `core.md`, Hard Rules 3 and 4 apply first.

## Running Things

- Tell the cost first: time, load, side effects, money or minutes.
- Metered services: estimate the wall time, pass a tight timeout, guard the
  call with a wall-clock kill. Never profile by re-running long jobs.
- Run only what a change requires.

## What a Test Is Worth

- Every expected value needs a source. Order of references: specification
  or handbook, then the real device, then our model of it. Our own output
  is never a reference.
- A failing test stays failing. Never change or remove it to match our
  output; change a value only when the source proves it wrong.
- A test must be able to fail: an example that gives the same result with
  the bug proves nothing.
- A test is at least as strict as what it certifies. It uses the same rule
  as the real function (one shared function, never a copy of the
  conditions) and gives the same plain reason. A check added to a function
  is added to its test in the same change.
- A test that passes while the real function fails is a defect in the test
  and gets its own task.

## How Much to Run

- The full test runs before a release, not after every change.
- A change that tests cannot see (skin, menu, dialog) needs a build and the
  user's eye, not a test run.
- A bench run gets its own report file `<timecode>_testreport.md` plus the
  raw logs, written in the same session, before the next unit.

## Release Check

- Use the product as a user does: real window, mouse and keyboard, no API,
  no arguments. The API is for finding bugs quickly while working; it
  misses what only the real window shows.

## Driving the Real Window

- Say what the run does and what it does not cover, ask, wait for the OK.
  One OK covers one run, also a second rehearsal needs its own.
- Prefer what moves nothing: the app's API, messages posted to the app's
  own window.
- Never click near the window that holds this conversation.
- Never run a scripted take blind: stage by stage, a screenshot after each,
  the next click decided from what is really on screen.
