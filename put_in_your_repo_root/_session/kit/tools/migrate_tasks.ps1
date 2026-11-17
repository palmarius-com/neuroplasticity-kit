# migrate_tasks.ps1 - one-off: turns an old task list into one file per task, and an old
# journal into the journal format of the kit. Nothing is deleted; the old files are only read.
#
#   migrate_tasks.ps1 -TaskFiles old\tasklist.md,old\tasklist_done.md [-Journal old\journal.md]
#
# Two old task formats are understood (detected per file):
#   heading:   "## T001: Title" followed by a block that holds "- **Status**: ..."
#   checkbox:  "- [x] T001 text ..." (done) or "- [ ] T001 text ..." (open), the block runs to the
#              next task line or the next "## " heading; "**T001**" and a letter suffix ("T107a") work
# Every entry is kept word for word. A task is closed only when all of its entries are closed.
# A number that appears twice, or with a letter suffix, goes into ONE file, entry after entry.
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

function Remove-TrailingBlank($lines) {
    $end = $lines.Count - 1
    while ($end -ge 0 -and ($lines[$end].Trim() -eq '' -or $lines[$end].Trim() -eq '---')) { $end-- }
    if ($end -ge 0) { return , @($lines[0..$end]) }
    return , @()
}

function New-Title([string]$text) {
    $text = ($text -replace '\*\*', '').Trim()
    if ($text.Length -le 100) { return $text }
    $cut = $text.Substring(0, 100)
    $space = $cut.LastIndexOf(' ')
    if ($space -gt 40) { $cut = $cut.Substring(0, $space) }
    return $cut.TrimEnd()
}

# number (digits) -> list of entries, in the order found
$entries = [ordered]@{}
function Add-Entry($entry) {
    if (-not $entries.Contains($entry.Num)) { $entries[$entry.Num] = New-Object System.Collections.Generic.List[object] }
    $entries[$entry.Num].Add($entry)
}

$formatCount = @{ heading = 0; checkbox = 0 }
foreach ($taskFile in $TaskFiles) {
    $fullPath = (Resolve-Path -LiteralPath $taskFile).Path
    $lines = Read-TextLines $fullPath
    $isHeading = @($lines | Where-Object { $_ -match '^## T\d+:' }).Count -gt 0
    if ($isHeading) {
        $formatCount.heading++
        $current = $null
        $n = 0
        foreach ($line in $lines) {
            $n++
            if ($line -match '^## ') {
                if ($current) { Add-Entry $current }
                $current = $null
                if ($line -match '^## (T(\d+)[a-z]?):\s*(.*)$') {
                    $current = [pscustomobject]@{ Id = $Matches[1]; Num = $Matches[2]; Title = $Matches[3]; State = 'open'; Section = ''; Line = $n; Body = (New-Object System.Collections.Generic.List[string]); First = $false }
                }
                continue
            }
            if ($current) {
                $current.Body.Add($line)
                if ($line -match '\*\*Status\*\*:\s*(.+)') { if ($Matches[1].Trim() -match '^Closed') { $current.State = 'closed' } }
            }
        }
        if ($current) { Add-Entry $current }
    } else {
        $formatCount.checkbox++
        $current = $null
        $section = ''
        $n = 0
        foreach ($line in $lines) {
            $n++
            if ($line -match '^#{1,3} ') {
                if ($current) { Add-Entry $current }
                $current = $null
                if ($line -match '^## (.*)$') { $section = $Matches[1].Trim() }
                continue
            }
            if ($line -match '^- \[([ xX])\] \**(T(\d+)[a-z]?)\**\s*(.*)$') {
                if ($current) { Add-Entry $current }
                $state = 'open'
                if ($Matches[1] -ne ' ') { $state = 'closed' }
                $id = $Matches[2]; $num = $Matches[3]; $rest = $Matches[4]
                $current = [pscustomobject]@{ Id = $id; Num = $num; Title = (New-Title $rest); State = $state; Section = $section; Line = $n; Body = (New-Object System.Collections.Generic.List[string]); First = $true }
                $current.Body.Add($line)
                continue
            }
            if ($current) { $current.Body.Add($line) }
        }
        if ($current) { Add-Entry $current }
    }
}

$written = 0
$skipped = 0
$multi = @()
$openCount = 0
$closedCount = 0
foreach ($num in $entries.Keys) {
    $list = $entries[$num]
    $first = $list[0]
    $allClosed = (@($list | Where-Object { $_.State -ne 'closed' }).Count -eq 0)
    $target = $p.Open
    if ($allClosed) { $target = $p.Closed }
    $file = Join-Path $target (('t' + $num).ToLowerInvariant() + '.md')
    $otherDir = $p.Closed
    if ($allClosed) { $otherDir = $p.Open }
    if ((Test-Path -LiteralPath $file) -or (Test-Path -LiteralPath (Join-Path $otherDir (('t' + $num).ToLowerInvariant() + '.md')))) {
        Write-Output ("exists, not overwritten: T{0}" -f $num); $skipped++; continue
    }
    $taskId = 'T' + $num
    $out = New-Object System.Collections.Generic.List[string]
    $out.Add("# ${taskId}: $($first.Title)")
    $out.Add('')
    $out.Add("Migrated $today from the old task list, word for word.")
    if ($list.Count -eq 1) {
        $state = $first.State
        $sectionText = ''
        if ($first.Section) { $sectionText = " Old section: $($first.Section)." }
        $out.Add("Old state: ${state}.${sectionText}")
    } else {
        $out.Add("$($list.Count) entries in the old list; the task is closed only if all are.")
        $multi += ("{0} ({1} entries: {2})" -f $taskId, $list.Count, (($list | ForEach-Object { $_.Id + ' ' + $_.State }) -join ', '))
    }
    $out.Add('The folder is the status now; the status and `time-spent` lines below')
    $out.Add('are history. Time comes from the journal.')
    $k = 0
    foreach ($e in $list) {
        $k++
        $out.Add('')
        if ($list.Count -gt 1) {
            $sectionText = ''
            if ($e.Section) { $sectionText = ", section $($e.Section)" }
            $out.Add("## Entry $k of $($list.Count): $($e.Id), $($e.State)$sectionText, old line $($e.Line)")
            $out.Add('')
        }
        foreach ($b in (Remove-TrailingBlank @($e.Body))) { $out.Add($b) }
    }
    Write-TextFile $file $out.ToArray()
    $written++
    if ($allClosed) { $closedCount++ } else { $openCount++ }
}
Write-Output ("formats found: heading {0}, checkbox {1}" -f $formatCount.heading, $formatCount.checkbox)
Write-Output ("task files written: {0} (open {1}, closed {2}), skipped: {3}" -f $written, $openCount, $closedCount, $skipped)
foreach ($m in $multi) { Write-Output ("  several entries: {0}" -f $m) }

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
