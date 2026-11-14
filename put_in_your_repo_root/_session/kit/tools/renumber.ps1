# renumber.ps1 - gives a task a new number (after a pull, when two machines used the same one).
#
#   renumber.ps1 -From T031 -To T033
#
# Renames the task file, changes the number in its first line, writes the journal line
# "T000 renumber T031 -> T033" (the journal itself is never changed; the tools follow the line)
# and lists the files that still name the old number.

param(
    [Parameter(Mandatory = $true)][string]$From,
    [Parameter(Mandatory = $true)][string]$To
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$p = Get-SessionPaths
$From = $From.ToUpperInvariant()
$To = $To.ToUpperInvariant()
if ($From -notmatch '^T\d{3,}$' -or $To -notmatch '^T\d{3,}$') { throw 'numbers must look like T031' }

$tasks = @(Get-TaskFiles)
if (@($tasks | Where-Object { $_.Id -eq $To }).Count -gt 0) { throw "$To exists already" }
$source = @($tasks | Where-Object { $_.Id -eq $From })
if ($source.Count -eq 0) { throw "no task file for $From" }
if ($source.Count -gt 1) { throw "$From exists more than once (open and closed): rename one by hand first" }

$old = $source[0].Path
$new = Join-Path (Split-Path -Parent $old) ($To.ToLowerInvariant() + '.md')
$lines = Read-TextLines $old
if ($lines.Count -gt 0) { $lines[0] = $lines[0] -replace ('^# ' + $From + ':'), ('# ' + $To + ':') }
Write-TextFile $new $lines
Remove-Item -LiteralPath $old
if ((Get-CurrentTask) -eq $From) { Write-TextFile (Join-Path $p.This 'current_task') @($To) }
$line = Add-JournalLine 'T000' ("renumber $From -> $To")
Write-Output $line

Write-Output "Files that still name ${From} (journal files are left as they are):"
$found = 0
foreach ($file in (Get-ChildItem -LiteralPath $p.This -Recurse -File -Filter '*.md')) {
    if ($file.DirectoryName -eq $p.Journal) { continue }
    if ($file.Name -in 'tasklist.md', 'timetable.md') { continue }
    $n = 0
    foreach ($text in (Read-TextLines $file.FullName)) {
        $n++
        if ($text -match ('\b' + $From + '\b')) { Write-Output ("  {0}:{1}" -f $file.FullName.Substring($p.Repo.Length + 1), $n); $found++ }
    }
}
if ($found -eq 0) { Write-Output '  (none)' }
Write-Output 'Then run: task.ps1 index'
