# session_start.ps1 - SessionStart hook (source: startup, resume, clear, compact).
# Runs the kit start script and tells the assistant to do the session start of
# .start.md before it does anything else. After a context summary (compact) the
# harness says "resume directly"; this hook says: read the rules first, then resume.
# Prints to stdout (the harness adds it to the context) and never fails.
# Origin: a project of the kit's author, 2026-11-15: after a summary the start was skipped.

$ErrorActionPreference = 'SilentlyContinue'
$source = 'unknown'
try {
    $raw = [Console]::In.ReadToEnd()
    if ($raw) { $source = [string](($raw | ConvertFrom-Json).source) }
} catch { }
if ($source -notmatch '^[a-z]+$') { $source = 'unknown' }

$tools = Split-Path -Parent $PSScriptRoot
$root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $tools))
Set-Location $root

Write-Output "SESSION START (hook, source: $source). Do this first, before any other work, without asking:"
if ($source -eq 'compact') {
    Write-Output "A context summary was just made. Do NOT resume 'as if the break never happened'. The agreements of the kit are not in the summary."
}
Write-Output "1. Read the output of the start script below (it is already run by this hook; do not run it again)."
Write-Output "2. Read _session/kit/core.md in full, _session/user/user.md, _session/user/preferences.md, _session/this_repo/baseline.md."
if ($source -eq 'compact') {
    Write-Output "3. Ask only the gaps the report below lists. This is not a new session: no other start questions."
    Write-Output "4. Read the current task file and the last 20 journal lines, then continue that task. Say in one line that the rules were read again."
} else {
    Write-Output "3. Follow core.md 'Session Start': ask open gaps with the question tool, ask for work done without the assistant."
    Write-Output "4. Then continue the task named below. Say in one line that the start was done."
}
Write-Output "----- start.ps1 -----"
try {
    $shell = (Get-Process -Id $PID).Path
    & $shell -NoProfile -File (Join-Path $tools 'start.ps1') -Source $source 2>&1 | ForEach-Object { Write-Output $_ }
} catch { Write-Output "start.ps1 could not run: $_" }
exit 0
