# migrate_tasks.ps1 - one-off: turns an old task list into one file per task, and an old
# journal into the journal format of the kit. Nothing is deleted; the old files are only read.
#
#   migrate_tasks.ps1 -TaskFiles old\tasklist.md,old\tasklist_done.md [-Journal old\journal.md]
#
# Old task format: blocks that start with "## T001: Title" and hold a line "- **Status**: ...".
# A block whose status starts with "Closed" goes to tasks/closed, every other to tasks/open.
# The body of a block is kept word for word (status and time lines included, as history).
# Old journal format: lines "- yyyyMMdd_HHmmss text"; "T000" is put in where no task number follows.

param(
    [Parameter(Mandatory = $true)][string[]]$TaskFiles,
    [string]$Journal = ''
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$p = Get-SessionPaths
foreach ($dir in $p.Open, $p.Closed, $p.Journal) {
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
}
$today = (Get-Date).ToString('yyyy-MM-dd', $script:Inv)
# "pwsh -File" hands a list over as one string: split it here.
$TaskFiles = @($TaskFiles | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().Trim('"') } | Where-Object { $_ })
$written = 0
$skipped = 0

foreach ($taskFile in $TaskFiles) {
    $lines = Read-TextLines (Resolve-Path -LiteralPath $taskFile).Path
    $blocks = @()
    $current = $null
    foreach ($line in $lines) {
        if ($line -match '^## ') {
            if ($current) { $blocks += $current }
            $current = $null
            if ($line -match '^## (T\d+):\s*(.*)$') {
                $current = [pscustomobject]@{ Id = $Matches[1]; Title = $Matches[2]; Body = (New-Object System.Collections.Generic.List[string]) }
            }
            continue
        }
        if ($current) { $current.Body.Add($line) }
    }
    if ($current) { $blocks += $current }

    foreach ($block in $blocks) {
        $body = @($block.Body)
        # drop separator lines and blank lines at the end of the block
        $end = $body.Count - 1
        while ($end -ge 0 -and ($body[$end].Trim() -eq '' -or $body[$end].Trim() -eq '---')) { $end-- }
        if ($end -ge 0) { $body = @($body[0..$end]) } else { $body = @() }
        $status = ''
        foreach ($line in $body) { if ($line -match '\*\*Status\*\*:\s*(.+)') { $status = $Matches[1].Trim(); break } }
        $target = $p.Open
        if ($status -match '^Closed') { $target = $p.Closed }
        $file = Join-Path $target ($block.Id.ToLowerInvariant() + '.md')
        if (Test-Path -LiteralPath $file) { Write-Output ("exists, not overwritten: {0}" -f $file); $skipped++; continue }
        $out = @("# $($block.Id): $($block.Title)", '', "Migrated $today from the old task list, word for word. The status and", 'time lines below are history: the folder is the status now, and time', 'comes from the journal.', '') + $body
        Write-TextFile $file $out
        $written++
    }
}
Write-Output ("task files written: {0}, skipped: {1}" -f $written, $skipped)

if ($Journal) {
    $source = (Resolve-Path -LiteralPath $Journal).Path
    $machine = Get-MachineName
    $perDay = @{}
    $order = New-Object System.Collections.Generic.List[string]
    $day = ''
    $count = 0
    $inBody = $false
    foreach ($line in (Read-TextLines $source)) {
        if (-not $inBody) { if ($line.Trim() -eq '---') { $inBody = $true }; continue }
        if ($line -match '^- (\d{8})_(\d{6}) (.*)$') {
            $day = $Matches[1]
            $time = $Matches[2]
            $rest = $Matches[3]
            # the next -match overwrites $Matches, so day and time are taken first
            if ($rest -notmatch '^T\d{3,} ') { $rest = 'T000 ' + $rest }
            if (-not $perDay.ContainsKey($day)) { $perDay[$day] = New-Object System.Collections.Generic.List[string]; $order.Add($day) }
            $perDay[$day].Add(('- {0}_{1} {2}' -f $day, $time, $rest))
            $count++
        } elseif ($day -and $line.Trim() -ne '') {
            $perDay[$day].Add($line)
        }
    }
    foreach ($d in $order) {
        $file = Join-Path $p.Journal ("{0}_{1}.md" -f $d, $machine)
        if (Test-Path -LiteralPath $file) { Write-Output ("exists, not overwritten: {0}" -f $file); continue }
        Write-TextFile $file (@("# Journal $d $machine", '', 'Migrated from the old journal; lines unchanged except for the task number', '`T000` where none was given.', '') + $perDay[$d].ToArray())
    }
    Write-Output ("journal lines migrated: {0} into {1} file(s)" -f $count, $order.Count)
}
Write-Output 'Next: task.ps1 index, then check.ps1'
