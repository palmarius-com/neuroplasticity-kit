# manifest.ps1 - writes _session/kit/manifest: one line "hash  path" per kit file.
# Run only in the kit master, after the kit was changed and `version` was set.
# check.ps1 uses the manifest to see whether a repository's copy of the kit was edited.

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib.ps1')
$p = Get-SessionPaths

$lines = @()
foreach ($file in (Get-ChildItem -LiteralPath $p.Kit -Recurse -File | Sort-Object FullName)) {
    $rel = $file.FullName.Substring($p.Kit.Length + 1).Replace('\', '/')
    if ($rel -eq 'manifest') { continue }
    $lines += ('{0}  {1}' -f (Get-NormalizedHash $file.FullName), $rel)
}
$lines = @($lines | Sort-Object { $_.Substring(66) })
Write-TextFile (Join-Path $p.Kit 'manifest') $lines
Write-Output ("manifest written: {0} files" -f $lines.Count)
