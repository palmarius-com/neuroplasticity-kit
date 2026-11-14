# Situation Rules: Hardware and Bench

Kit file, identical in every project, changed only through the kit. Read
before flashing, bench work, wiring or bringing up new hardware. `core.md`,
Hard Rules 2 and 3 apply first.

- Flashing or writing to a device: ask first, every time, until the user
  says otherwise. Read-only access is fine.
- Before every bench step say what the user has to do (hold, switch, plug,
  press). Never poll hardware silently.
- After a flash say what was flashed and what the user must do next (e.g.
  power cycle).
- One change per flash, so each result has one cause.
- Bring new hardware or components up one at a time.
- Write explicit regions only. Never a merged image and never an erase that
  can wipe stored keys, calibration or logs.
- Take a backup image before the first write; it is the way back.
- Wiring and hardware design are drawings (schematic with real symbols,
  wire colours), not text.
- Same orientation in every block of a drawing. Never mirror a block to
  make the drawing fit; move the notes instead.
