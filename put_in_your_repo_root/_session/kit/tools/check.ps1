# check.ps1 - checks what a script can check. Read-only: it changes nothing.
# Exit code 0 = no errors, 1 = errors.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$p = Get-SessionPaths
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Get-Relative([string]$path) { return $path.Substring($p.Repo.Length + 1).Replace('\', '/') }

Write-Output ("Checking: {0}" -f $p.Repo)

# 1. Required files and folders
foreach ($rel in '.start.md', 'README.md', '_session\kit\core.md', '_session\kit\version', '_session\this_repo\baseline.md', '_session\this_repo\current_task', '_session\this_repo\tasks\open', '_session\this_repo\tasks\closed', '_session\this_repo\journal') {
    if (-not (Test-Path -LiteralPath (Join-Path $p.Repo $rel))) { $errors.Add("missing: $($rel.Replace('\', '/'))") }
}

# 2. Names inside _session: lower case a-z, digits, - _ .
foreach ($item in (Get-ChildItem -LiteralPath $p.Session -Recurse -Force)) {
    if ($item.Name -cnotmatch '^[a-z0-9._-]+$') { $errors.Add("name not lower-case ASCII: $(Get-Relative $item.FullName)") }
}

# 3. Line width (README.md and markdown in _session; tables exempt)
$limit = 100
$migratedLong = 0
$migratedFiles = 0
foreach ($line in (Read-TextLines (Join-Path $p.User 'preferences.md'))) {
    if ($line -match '^- line_width_limit:\s*(\d+)') { $limit = [int]$Matches[1] }
}
$mdFiles = @(Get-ChildItem -LiteralPath $p.Session -Recurse -File -Filter '*.md')
$readme = Join-Path $p.Repo 'README.md'
if (Test-Path -LiteralPath $readme) { $mdFiles += Get-Item -LiteralPath $readme }
foreach ($file in $mdFiles) {
    if ($file.Name -in 'tasklist.md', 'timetable.md') { continue }
    # The legacy folder holds the files of the old layout unchanged: not checked.
    if ($file.FullName -like '*\this_repo\legacy\*') { continue }
    $fileLines = Read-TextLines $file.FullName
    # Files migrated word for word keep their old line width: counted, not an error.
    $migrated = @($fileLines | Select-Object -First 6 | Where-Object { $_ -match '^Migrated ' }).Count -gt 0
    $long = 0
    $n = 0
    foreach ($line in $fileLines) {
        $n++
        if ($line.StartsWith('|')) { continue }
        if ($line.Length -gt $limit) {
            if ($migrated) { $long++ }
            else { $errors.Add(("line over {0} characters: {1}:{2} ({3})" -f $limit, (Get-Relative $file.FullName), $n, $line.Length)) }
        }
    }
    if ($long -gt 0) { $migratedLong += $long; $migratedFiles++ }
}
if ($migratedFiles -gt 0) { $warnings.Add("$migratedLong line(s) over $limit characters in $migratedFiles migrated file(s), kept word for word") }

# 4. Tasks: one file per task, the heading carries the number of the file name, no number twice
$tasks = @(Get-TaskFiles)
foreach ($t in $tasks) {
    if ($t.Head -notmatch ('^# ' + $t.Id + ':')) { $errors.Add("$($t.Id) ($($t.State)): first line is not '# $($t.Id): title'") }
}
foreach ($group in ($tasks | Group-Object Id | Where-Object { $_.Count -gt 1 })) {
    $errors.Add("task number twice (open and closed, or after a pull): $($group.Name). Use renumber.ps1")
}
foreach ($dir in $p.Open, $p.Closed) {
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    foreach ($file in (Get-ChildItem -LiteralPath $dir -File)) {
        if ($file.Name -notmatch '^t\d{3,}\.md$' -and $file.Name -ne 'readme.md') { $errors.Add("not a task file name: $(Get-Relative $file.FullName)") }
    }
}
$current = Get-CurrentTask
if ($current -ne 'T000' -and @($tasks | Where-Object { $_.Id -eq $current -and $_.State -eq 'open' }).Count -eq 0) {
    $warnings.Add("current_task is $current, which is not an open task")
}

# 5. Journal: every entry line has timecode and task number; a file never runs backwards
if (Test-Path -LiteralPath $p.Journal) {
    foreach ($file in (Get-ChildItem -LiteralPath $p.Journal -File)) {
        if ($file.Name -eq 'readme.md') { continue }
        if ($file.Name -notmatch '^\d{8}_[a-z0-9-]+\.md$') { $errors.Add("not a journal file name: $(Get-Relative $file.FullName)"); continue }
        $last = ''
        $n = 0
        foreach ($line in (Read-TextLines $file.FullName)) {
            $n++
            if (-not $line.StartsWith('- ')) { continue }
            if ($line -match '^- (\d{8}_\d{6}) T\d{3,} \S') {
                if ($last -and ($Matches[1] -lt $last)) { $errors.Add("journal runs backwards: $($file.Name):$n") }
                $last = $Matches[1]
            } else {
                $errors.Add("journal line without '- timecode Tnnn text': $($file.Name):$n")
            }
        }
    }
}
$known = @{ 'T000' = $true }
foreach ($t in $tasks) { $known[$t.Id] = $true }
$unknown = @(Read-Journal | Where-Object { -not $known.ContainsKey($_.Task) } | ForEach-Object { $_.Task } | Sort-Object -Unique)
foreach ($id in $unknown) { $warnings.Add("journal names $id, but there is no such task file") }

# 6. Placeholders and personal files
$baseline = Read-TextLines (Join-Path $p.This 'baseline.md')
$t001Open = @($tasks | Where-Object { $_.Id -eq 'T001' -and $_.State -eq 'open' }).Count -gt 0
if (@($baseline | Where-Object { $_ -match 'FILL IN' }).Count -gt 0) {
    if ($t001Open) { $warnings.Add('baseline.md holds FILL IN (T001 is open)') } else { $errors.Add('baseline.md holds FILL IN, and T001 is not open') }
}
if (-not (Test-Path -LiteralPath (Join-Path $p.User 'user.md'))) { $warnings.Add('no _session/user/user.md on this machine (T002, or carry the folder over)') }

# 7. .gitignore carries the kit block
if (Test-Path -LiteralPath (Join-Path $p.Repo '.git')) {
    $ignore = (Read-TextLines (Join-Path $p.Repo '.gitignore')) -join "`n"
    if ($ignore -notmatch '>>> session kit') { $warnings.Add('.gitignore has no "session kit" block: _session/user/ and _external/ may get committed') }
}

# 8. Names of originals
foreach ($sub in 'screenshots', 'documents', 'downloads') {
    $dir = Join-Path $p.Repo ("_external\" + $sub)
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    foreach ($file in (Get-ChildItem -LiteralPath $dir -File)) {
        if ($file.Name -notmatch '^\d{8}_\d{6}_.+\.[^.]+$') { $errors.Add("original without timecode at the start: _external/$sub/$($file.Name)") }
    }
}

# 9. Kit files against the manifest (was the kit edited in this repository?)
$manifest = Join-Path $p.Kit 'manifest'
if (Test-Path -LiteralPath $manifest) {
    $listed = @{}
    foreach ($line in (Read-TextLines $manifest)) {
        if ($line -match '^([0-9a-f]{64})  (.+)$') { $listed[$Matches[2]] = $Matches[1] }
    }
    foreach ($rel in $listed.Keys) {
        $file = Join-Path $p.Kit $rel.Replace('/', '\')
        if (-not (Test-Path -LiteralPath $file)) { $errors.Add("kit file missing: $rel") }
        elseif ((Get-NormalizedHash $file) -ne $listed[$rel]) { $errors.Add("kit file differs from the manifest (edited here?): $rel") }
    }
    foreach ($file in (Get-ChildItem -LiteralPath $p.Kit -Recurse -File)) {
        $rel = $file.FullName.Substring($p.Kit.Length + 1).Replace('\', '/')
        if ($rel -ne 'manifest' -and -not $listed.ContainsKey($rel)) { $errors.Add("file in kit folder that is not in the manifest: $rel") }
    }
} else {
    $warnings.Add('no _session/kit/manifest: kit files cannot be verified (run manifest.ps1 in the kit master)')
}

$version = Read-TextLines (Join-Path $p.Kit 'version')
if ($version.Count -gt 0) { Write-Output ("Kit version: {0}" -f $version[0].Trim()) }
Write-Output ("Tasks: {0} open, {1} closed." -f @($tasks | Where-Object { $_.State -eq 'open' }).Count, @($tasks | Where-Object { $_.State -eq 'closed' }).Count)
foreach ($w in $warnings) { Write-Output "WARN  $w" }
foreach ($e in $errors) { Write-Output "ERROR $e" }
if ($errors.Count -eq 0) { Write-Output 'RESULT: OK'; exit 0 }
Write-Output ("RESULT: {0} error(s)" -f $errors.Count)
exit 1
