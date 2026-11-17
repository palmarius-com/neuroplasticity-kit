# start.ps1 - run at every session start (named in .start.md, approved by installing the kit).
# Prints a short report and appends the "session start" line to the journal. Changes nothing else.

# -Source is given by the session start hook (startup, resume, clear, compact). With "compact"
# the journal line says "context compacted", not "session start": the session goes on.
param([string]$Source = '')

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$p = Get-SessionPaths

$version = '(no version file)'
$versionLines = Read-TextLines (Join-Path $p.Kit 'version')
if ($versionLines.Count -gt 0) { $version = $versionLines[0].Trim() }

Write-Output ("Kit version: {0}" -f $version)
Write-Output ("Now: {0}  {1}  machine {2}" -f (Get-Timecode), (Get-UtcOffsetText), (Get-MachineName))
Write-Output ("Repository: {0}" -f $p.Repo)

# Version control
if (Test-Path -LiteralPath (Join-Path $p.Repo '.git')) {
    $name = ''; $mail = ''; $branch = ''
    try {
        $name = (& git -C $p.Repo config user.name 2>$null)
        $mail = (& git -C $p.Repo config user.email 2>$null)
        $branch = (& git -C $p.Repo branch --show-current 2>$null)
    } catch { }
    Write-Output ("Git: yes. Identity: {0} <{1}>. Branch: {2}" -f $name, $mail, $branch)
    # The identity belongs to the person: user.md, "Commit as" (never baseline.md).
    foreach ($userLine in (Read-TextLines (Join-Path $p.User 'user.md'))) {
        if ($userLine -match '^- \*\*Commit as\*\*:\s*(.+)$') {
            $want = $Matches[1].Trim()
            if ($want -notmatch 'FILL IN' -and $want -ne 'none' -and "$mail" -ne '' -and $want.IndexOf("$mail", [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
                Write-Output ("WARN: configured identity is not 'Commit as' in user.md ({0}). Tell the user." -f $want)
            }
        }
    }
} else {
    Write-Output 'Git: no .git folder here.'
}

# People and project files
$todo = @()
if (-not (Test-Path -LiteralPath (Join-Path $p.User 'user.md'))) { $todo += 'no _session/user/user.md: task T002 (introduce yourself)' }
$baseline = Read-TextLines (Join-Path $p.This 'baseline.md')
if ($baseline.Count -eq 0) { $todo += 'no _session/this_repo/baseline.md' }
elseif (@($baseline | Where-Object { $_ -match 'FILL IN' }).Count -gt 0) { $todo += 'baseline.md holds FILL IN: task T001 (project survey)' }
foreach ($line in $todo) { Write-Output ("TODO: {0}" -f $line) }

# Tasks and journal
$tasks = @(Get-TaskFiles)
$open = @($tasks | Where-Object { $_.State -eq 'open' })
$journal = @(Read-Journal)
Write-Output ("Tasks: {0} open, {1} closed. Current task: {2}. Next free: {3}" -f $open.Count, ($tasks.Count - $open.Count), (Get-CurrentTask), (Get-NextTaskId))

if ($journal.Count -eq 0) {
    Write-Output 'Journal: empty. This is the first session.'
} else {
    $last = $journal[$journal.Count - 1]
    $since = ((Get-Date) - (ConvertTo-Time $last.Code)).TotalHours
    Write-Output ("Last journal line: {0} {1} {2}" -f $last.Code, $last.Task, $last.Text)
    Write-Output ("Time since then: {0} hours" -f (Format-Hours $since))

    # Tasks worked on last that are still open
    $seen = @{}
    $shown = 0
    Write-Output 'Worked on last and still open:'
    for ($i = $journal.Count - 1; $i -ge 0 -and $shown -lt 3; $i--) {
        $row = $journal[$i]
        if ($row.Task -eq 'T000' -or $seen.ContainsKey($row.Task)) { continue }
        $seen[$row.Task] = $true
        $task = @($open | Where-Object { $_.Id -eq $row.Task })
        if ($task.Count -gt 0) {
            Write-Output ("  {0} {1} (last line {2})" -f $task[0].Id, $task[0].Title, $row.Code)
            $shown++
        }
    }
    if ($shown -eq 0) { Write-Output '  (none)' }

    # Gaps to ask the user about
    $gaps = @(Get-OpenGaps $journal)
    if ($since -gt 2) {
        $gaps += [pscustomobject]@{ After = $last.Code; Until = 'now'; Hours = $since; TaskBefore = $last.Task; TaskAfter = '' }
    }
    if ($gaps.Count -gt 0) {
        Write-Output ("Open gaps over 2 hours: {0}. ASK THE USER (rules/tasks.md, Gaps):" -f $gaps.Count)
        foreach ($gap in ($gaps | Select-Object -Last 5)) {
            Write-Output ("  after {0} ({1}) until {2}: {3} hours unaccounted" -f $gap.After, $gap.TaskBefore, $gap.Until, (Format-Hours $gap.Hours))
        }
    } else {
        Write-Output 'Open gaps over 2 hours: none.'
    }
}

# One start line per start: the hook runs this script, and the assistant may run it again
# when the user says "read .start.md". A start line of this machine that is younger than
# 5 minutes stands.
$machine = Get-MachineName
$recent = @($journal | Where-Object {
    $_.Text -match '^session start' -and $_.File -like ("*_{0}.md" -f $machine) -and ((Get-Date) - (ConvertTo-Time $_.Code)).TotalMinutes -lt 5
})
if ($Source -eq 'compact') {
    $line = Add-JournalLine (Get-CurrentTask) ("context compacted (hook) {0} machine {1}" -f (Get-UtcOffsetText), $machine)
    Write-Output ("Journal: {0}" -f $line)
} elseif ($recent.Count -gt 0) {
    Write-Output ("Journal: the session start line of {0} stands, no second line." -f $recent[$recent.Count - 1].Code)
} else {
    $line = Add-JournalLine 'T000' ("session start {0} machine {1}" -f (Get-UtcOffsetText), $machine)
    Write-Output ("Journal: {0}" -f $line)
}
Write-Output 'Next: read _session/kit/core.md, _session/user/, _session/this_repo/baseline.md.'
