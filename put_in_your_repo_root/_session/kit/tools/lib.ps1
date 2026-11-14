# lib.ps1 - shared helpers of the kit tools. Dot-sourced by the other scripts, never run alone.

$script:Inv = [System.Globalization.CultureInfo]::InvariantCulture
$script:Utf8 = New-Object System.Text.UTF8Encoding($false)

function Get-SessionPaths {
    $kit = Split-Path -Parent $PSScriptRoot          # tools -> kit
    $session = Split-Path -Parent $kit               # kit -> _session
    $this = Join-Path $session 'this_repo'
    return @{
        Repo    = Split-Path -Parent $session
        Session = $session
        Kit     = $kit
        User    = Join-Path $session 'user'
        This    = $this
        Journal = Join-Path $this 'journal'
        Open    = Join-Path $this 'tasks\open'
        Closed  = Join-Path $this 'tasks\closed'
    }
}

function Get-Timecode { return (Get-Date).ToString('yyyyMMdd_HHmmss', $script:Inv) }

function ConvertTo-Time([string]$code) {
    return [datetime]::ParseExact($code, 'yyyyMMdd_HHmmss', $script:Inv)
}

function Format-Hours([double]$hours) { return $hours.ToString('0.00', $script:Inv) }

function Get-MachineName {
    $name = [Environment]::MachineName.ToLowerInvariant()
    return ($name -replace '[^a-z0-9-]', '-')
}

function Get-UtcOffsetText {
    $offset = [System.TimeZoneInfo]::Local.GetUtcOffset([datetime]::Now)
    $sign = '+'
    if ($offset -lt [timespan]::Zero) { $sign = '-' }
    return ('utc{0}{1:00}:{2:00}' -f $sign, [math]::Abs($offset.Hours), [math]::Abs($offset.Minutes))
}

function Add-TextLine([string]$path, [string]$line) {
    [System.IO.File]::AppendAllText($path, $line + "`n", $script:Utf8)
}

function Write-TextFile([string]$path, [string[]]$lines) {
    [System.IO.File]::WriteAllText($path, (($lines -join "`n") + "`n"), $script:Utf8)
}

function Read-TextLines([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return @() }
    return @([System.IO.File]::ReadAllLines($path))
}

function Get-NormalizedHash([string]$path) {
    $text = [System.IO.File]::ReadAllText($path).Replace("`r`n", "`n")
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $bytes = $sha.ComputeHash($script:Utf8.GetBytes($text))
    return (($bytes | ForEach-Object { $_.ToString('x2') }) -join '')
}

function Get-CurrentTask {
    $p = Get-SessionPaths
    $lines = Read-TextLines (Join-Path $p.This 'current_task')
    if ($lines.Count -gt 0 -and $lines[0].Trim() -match '^T\d{3,}$') { return $lines[0].Trim() }
    return 'T000'
}

function Get-JournalFile {
    $p = Get-SessionPaths
    if (-not (Test-Path -LiteralPath $p.Journal)) { New-Item -ItemType Directory -Force -Path $p.Journal | Out-Null }
    $day = (Get-Date).ToString('yyyyMMdd', $script:Inv)
    $machine = Get-MachineName
    $file = Join-Path $p.Journal ("{0}_{1}.md" -f $day, $machine)
    if (-not (Test-Path -LiteralPath $file)) {
        Write-TextFile $file @("# Journal $day $machine", '')
    }
    return $file
}

function Add-JournalLine([string]$task, [string]$text) {
    $line = '- {0} {1} {2}' -f (Get-Timecode), $task, $text
    Add-TextLine (Get-JournalFile) $line
    return $line
}

# All journal lines of all files, oldest first, renumbering applied.
function Read-Journal {
    $p = Get-SessionPaths
    $rows = New-Object System.Collections.Generic.List[object]
    if (-not (Test-Path -LiteralPath $p.Journal)) { return @() }
    $seq = 0
    foreach ($file in (Get-ChildItem -LiteralPath $p.Journal -File | Where-Object { $_.Name -match '^\d{8}_.+\.md$' } | Sort-Object Name)) {
        $n = 0
        foreach ($line in (Read-TextLines $file.FullName)) {
            $n++
            if ($line -match '^- (\d{8}_\d{6}) (T\d+) (.*)$') {
                $seq++
                $rows.Add([pscustomobject]@{ Code = $Matches[1]; Task = $Matches[2]; Text = $Matches[3]; File = $file.Name; Line = $n; Seq = $seq })
            }
        }
    }
    $sorted = @($rows | Sort-Object Code, Seq)
    $map = @{}
    foreach ($row in $sorted) {
        if ($row.Text -match '^renumber (T\d+) -> (T\d+)') { $map[$Matches[1]] = $Matches[2] }
    }
    foreach ($row in $sorted) {
        $guard = 0
        while ($map.ContainsKey($row.Task) -and $guard -lt 10) { $row.Task = $map[$row.Task]; $guard++ }
    }
    return $sorted
}

# Task files: Id, Title, State (open / closed), Path.
function Get-TaskFiles {
    $p = Get-SessionPaths
    $result = @()
    foreach ($state in 'open', 'closed') {
        $dir = $p.Open
        if ($state -eq 'closed') { $dir = $p.Closed }
        if (-not (Test-Path -LiteralPath $dir)) { continue }
        foreach ($file in (Get-ChildItem -LiteralPath $dir -File | Where-Object { $_.Name -match '^t(\d+)\.md$' } | Sort-Object Name)) {
            $id = 'T' + ($file.BaseName.Substring(1))
            $title = ''
            $head = ''
            $lines = Read-TextLines $file.FullName
            if ($lines.Count -gt 0) { $head = $lines[0] }
            if ($head -match '^# (T\d+):\s*(.*)$') { $title = $Matches[2] }
            $result += [pscustomobject]@{ Id = $id; Title = $title; State = $state; Path = $file.FullName; Head = $head }
        }
    }
    return $result
}

function Get-NextTaskId {
    $max = 0
    foreach ($t in (Get-TaskFiles)) { $num = [int]$t.Id.Substring(1); if ($num -gt $max) { $max = $num } }
    return ('T{0:000}' -f ($max + 1))
}

# Intervals of more than 2 hours between two journal lines that have no "gap" answer yet.
function Get-OpenGaps($journal) {
    $answered = @{}
    foreach ($row in $journal) {
        if ($row.Text -match '^gap (\d{8}_\d{6}) ') { $answered[$Matches[1]] = $true }
    }
    $gaps = @()
    for ($i = 1; $i -lt $journal.Count; $i++) {
        $prev = $journal[$i - 1]
        $cur = $journal[$i]
        $hours = ((ConvertTo-Time $cur.Code) - (ConvertTo-Time $prev.Code)).TotalHours
        if ($hours -gt 2 -and -not $answered.ContainsKey($prev.Code)) {
            $gaps += [pscustomobject]@{ After = $prev.Code; Until = $cur.Code; Hours = $hours; TaskBefore = $prev.Task; TaskAfter = $cur.Task }
        }
    }
    return $gaps
}
