# journal_stamp.ps1 - called by a harness hook. Appends one journal line with the real clock:
#   - <timecode> <current task> prompt      (the user's prompt arrived)
#   - <timecode> <current task> reply       (the assistant's reply was sent)
# Prints nothing and never fails, so it cannot disturb the session.

param([Parameter(Mandatory = $true)][ValidateSet('prompt', 'reply')][string]$Event)

try {
    . (Join-Path (Split-Path -Parent $PSScriptRoot) 'lib.ps1')
    [void](Add-JournalLine (Get-CurrentTask) $Event)
} catch { }
exit 0
