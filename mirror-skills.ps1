<#
.SYNOPSIS
    Reconcile a curated skill profile from a clean Git checkout.
.DESCRIPTION
    Default: add or update selected skills, backing up replaced directories.
    -Check: read-only exact file-set and SHA-256 comparison; fails on managed drift.
    -Reconcile: also archive retired and out-of-profile directories.
    -WhatIf: preview writes; never create directories or backups.
    Unknown entries are never modified. No target files are deleted.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('agents', 'opencode')]
    [string]$Profile,
    [string]$RepoPath = $PSScriptRoot,
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,
    [switch]$Check,
    [switch]$Reconcile,
    [string[]]$IncludeSkill = @()
)
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'

function Get-NormalPath {
    param([string]$Path)
    $full = [IO.Path]::GetFullPath($Path)
    if ($full.Length -gt [IO.Path]::GetPathRoot($full).Length) {
        return $full.TrimEnd([char[]]@('\', '/'))
    }
    return $full
}
function Test-Within {
    param([string]$Path, [string]$Root)
    $a = (Get-NormalPath $Path).TrimEnd([char[]]@('\', '/'))
    $b = (Get-NormalPath $Root).TrimEnd([char[]]@('\', '/'))
    return ($a.Equals($b, [StringComparison]::OrdinalIgnoreCase) -or
        $a.StartsWith($b + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase))
}
function Assert-NoReparseAncestors {
    param([string]$Path)
    $p = Get-NormalPath $Path
    while ($p) {
        $item = Get-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue
        if ($null -ne $item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Refusing a symbolic link or reparse point: $p"
        }
        $parent = [IO.Directory]::GetParent($p)
        if ($null -eq $parent) { break }
        $p = $parent.FullName
    }
}
function Assert-Names {
    param([object[]]$Names, [string]$Label)
    $seen = @{}
    foreach ($name in $Names) {
        if ($name -isnot [string] -or $name -cnotmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
            throw ("Invalid skill name in {0}: {1}" -f $Label, $name)
        }
        if ($seen.ContainsKey($name)) { throw ("Duplicate skill in {0}: {1}" -f $Label, $name) }
        $seen[$name] = $true
    }
}
function Get-FileMap {
    param([string]$Root)
    $rootPath = Get-NormalPath $Root
    Assert-NoReparseAncestors $rootPath
    if (-not (Test-Path -LiteralPath $rootPath -PathType Container)) { throw "Expected a directory: $rootPath" }
    $pending = New-Object 'System.Collections.Generic.Stack[string]'
    $pending.Push($rootPath)
    $result = @{}
    while ($pending.Count -gt 0) {
        $dir = $pending.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $dir -Force)) {
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Refusing a symbolic link or reparse point: $($item.FullName)"
            }
            if ($item.PSIsContainer) { $pending.Push($item.FullName); continue }
            $relative = $item.FullName.Substring($rootPath.Length + 1).Replace('\', '/')
            if ($result.ContainsKey($relative)) { throw "Case-insensitive path collision: $relative" }
            $result[$relative] = [pscustomobject]@{
                Path = $item.FullName
                Hash = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash
            }
        }
    }
    return $result
}
function Test-FileMapsEqual {
    param([hashtable]$Left, [hashtable]$Right)
    if ($Left.Count -ne $Right.Count) { return $false }
    foreach ($relative in $Left.Keys) {
        if (-not $Right.ContainsKey($relative) -or $Left[$relative].Hash -ne $Right[$relative].Hash) {
            return $false
        }
    }
    return $true
}
function Copy-MainFileStream {
    param([string]$Source, [string]$Destination)
    # Copy file contents, not NTFS alternate streams; never modify the source.
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    $inputStream = [IO.File]::OpenRead($Source)
    try {
        $outputStream = [IO.File]::Open($Destination, [IO.FileMode]::CreateNew,
            [IO.FileAccess]::Write, [IO.FileShare]::None)
        try { $inputStream.CopyTo($outputStream) }
        finally { $outputStream.Dispose() }
    }
    finally { $inputStream.Dispose() }
}

if ($Check -and $Reconcile) { throw '-Check is read-only; do not combine it with -Reconcile.' }
$RepoPath = Get-NormalPath $RepoPath
$TargetPath = Get-NormalPath $TargetPath
Assert-NoReparseAncestors $RepoPath
Assert-NoReparseAncestors $TargetPath
if ((Test-Within $TargetPath $RepoPath) -or (Test-Within $RepoPath $TargetPath)) {
    throw 'Source and destination must be disjoint directories.'
}
if ((Test-Path -LiteralPath $TargetPath) -and -not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
    throw "Target is not a directory: $TargetPath"
}

$gitRoot = & git -C $RepoPath rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0 -or -not $gitRoot) { throw 'Source must be a Git checkout.' }
$gitRootPath = Get-NormalPath ([string]$gitRoot)
if (-not $gitRootPath.Equals($RepoPath, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'RepoPath must identify the root of the skills checkout.'
}
$revision = & git -C $RepoPath rev-parse HEAD
if ($LASTEXITCODE -ne 0) { throw 'Cannot determine source commit.' }
$dirty = @(& git -C $RepoPath status --porcelain --untracked-files=all -- skills/ skills-policy.json)
if ($LASTEXITCODE -ne 0) { throw 'Cannot inspect source checkout status.' }
if ($dirty.Count -gt 0) { throw ('Refusing to mirror uncommitted skill or policy changes: ' + ($dirty -join '; ')) }

$tracked = @(& git -C $RepoPath -c core.quotepath=false ls-files -- skills-policy.json skills/)
if ($LASTEXITCODE -ne 0) { throw 'Cannot enumerate tracked skills.' }
if ($tracked -notcontains 'skills-policy.json') { throw 'The deployment policy must be tracked in Git.' }
$policy = Get-Content -LiteralPath (Join-Path $RepoPath 'skills-policy.json') -Raw -Encoding UTF8 | ConvertFrom-Json
if ($policy.schemaVersion -ne 1) { throw 'Unsupported skills-policy.json version.' }
$agents = @($policy.profiles.agents)
$opencode = @($policy.profiles.opencode)
$optional = @($policy.optional)
$retired = @($policy.retired)
$repoOnly = @($policy.repoOnly)
$nexus = @($policy.nexusCandidates)
Assert-Names $agents 'agents profile'
Assert-Names $opencode 'opencode profile'
Assert-Names $optional 'optional'
Assert-Names $retired 'retired'
Assert-Names $repoOnly 'repoOnly'
Assert-Names $nexus 'nexusCandidates'
if (@($agents | Where-Object { $opencode -notcontains $_ }).Count -gt 0 -or
    @($nexus | Where-Object { $agents -notcontains $_ }).Count -gt 0) {
    throw 'Profile subset policy is inconsistent.'
}
$active = @($opencode + $optional)
Assert-Names $active 'all retained skills'
Assert-Names @($active + $retired + $repoOnly) 'active, retired and repo-only skills'
$sourceNames = @($tracked | ForEach-Object { if ($_ -match '^skills/([^/]+)/SKILL\.md$') { $Matches[1] } })
if ($sourceNames.Count -ne $active.Count -or
    @($sourceNames | Where-Object { $active -notcontains $_ }).Count -gt 0) {
    throw 'Tracked skill roots do not match the deployment policy.'
}
Assert-Names $IncludeSkill 'explicit include list'
foreach ($name in $IncludeSkill) {
    if ($active -notcontains $name) { throw "Unknown or retired requested skill: $name" }
}
$desired = @((@($policy.profiles.$Profile) + $IncludeSkill) | Sort-Object -Unique)
$known = @($active + $retired + $repoOnly)
$targetIndex = @{}
if (Test-Path -LiteralPath $TargetPath -PathType Container) {
    foreach ($entry in @(Get-ChildItem -LiteralPath $TargetPath -Force)) {
        if ($targetIndex.ContainsKey($entry.Name)) { throw "Case-insensitive target collision: $($entry.Name)" }
        $targetIndex[$entry.Name] = $entry
    }
}

$plan = @()
$unchanged = @()
foreach ($name in $desired) {
    $source = Join-Path (Join-Path $RepoPath 'skills') $name
    $sourceMap = Get-FileMap $source
    $prefix = "skills/$name/"
    $trackedRelative = @($tracked | Where-Object { $_.StartsWith($prefix, [StringComparison]::Ordinal) } |
        ForEach-Object { $_.Substring($prefix.Length) })
    if ($trackedRelative.Count -ne $sourceMap.Count -or
        @($trackedRelative | Where-Object { -not $sourceMap.ContainsKey($_) }).Count -gt 0) {
        throw "Skill includes missing or untracked files: $name"
    }
    $destination = Join-Path $TargetPath $name
    $oldMap = $null
    if ($targetIndex.ContainsKey($name)) {
        $entry = $targetIndex[$name]
        if (-not $entry.PSIsContainer) { throw "Target name is not a directory: $destination" }
        $oldMap = Get-FileMap $destination
        if (Test-FileMapsEqual $sourceMap $oldMap) { $unchanged += $name; continue }
        $action = 'Replace (archive old directory first)'
    }
    else { $action = 'Add' }
    $plan += [pscustomobject]@{
        Name = $name; Action = $action; Destination = $destination
        SourceMap = $sourceMap; OldMap = $oldMap
    }
}
$extra = @($known | Where-Object { $desired -notcontains $_ -and $targetIndex.ContainsKey($_) } | Sort-Object)
$unmanaged = @($targetIndex.Keys | Where-Object { $known -notcontains $_ } | Sort-Object)
if ($Reconcile) {
    foreach ($name in $extra) {
        $destination = Join-Path $TargetPath $name
        if (-not $targetIndex[$name].PSIsContainer) { throw "Managed name is not a directory: $destination" }
        $oldMap = Get-FileMap $destination
        $plan += [pscustomobject]@{
            Name = $name; Action = 'Archive retired/out-of-profile directory'
            Destination = $destination; SourceMap = $null; OldMap = $oldMap
        }
    }
}
Write-Output "Source commit: $revision"
Write-Output "Profile: $Profile | Target: $TargetPath | Selected: $($desired.Count)"
Write-Output "Unchanged selected: $($unchanged.Count)"
foreach ($item in $plan) { Write-Output ("  {0}: {1}" -f $item.Action, $item.Name) }
Write-Output "Retired/out-of-profile entries: $($extra.Count)"
foreach ($name in $extra) { Write-Output "  excluded: $name" }
Write-Output "Unmanaged entries (untouched): $($unmanaged.Count)"
foreach ($name in $unmanaged) { Write-Output "  unmanaged: $name" }
if ($Check) {
    if ($plan.Count -gt 0 -or $extra.Count -gt 0) { throw 'Managed skill drift detected. No files were changed.' }
    Write-Output 'CHECK PASS: selected skill file sets and SHA-256 hashes match; no known excluded entries.'
    return
}
if ($plan.Count -eq 0) {
    if ($extra.Count -gt 0) { Write-Output 'Excluded entries remain; preview -Reconcile -WhatIf to archive them.' }
    else { Write-Output 'Nothing to change.' }
    return
}

$targetParent = Split-Path -Parent $TargetPath
if (-not $targetParent) { throw 'A target at the filesystem root is not supported.' }
$backupParent = Join-Path $targetParent 'skill-mirror-backups'
Assert-NoReparseAncestors $backupParent
if ((Test-Within $backupParent $RepoPath) -or (Test-Within $backupParent $TargetPath) -or
    (Test-Within $TargetPath $backupParent)) { throw 'Backup directory overlaps the source or active target.' }
$runName = "$Profile-$(Get-Date -Format 'yyyyMMdd-HHmmss-fff')-$([Guid]::NewGuid().ToString('N'))"
$runPath = Join-Path $backupParent $runName
$archiveRoot = Join-Path $runPath 'archived'
$stagingRoot = Join-Path $runPath 'staging'
$applied = 0

foreach ($item in $plan) {
    if (-not $PSCmdlet.ShouldProcess($item.Destination, $item.Action)) { continue }
    Assert-NoReparseAncestors $TargetPath
    Assert-NoReparseAncestors $backupParent
    $exists = Test-Path -LiteralPath $item.Destination
    if ($null -eq $item.OldMap) {
        if ($exists) { throw "Target appeared after planning: $($item.Destination)" }
    }
    else {
        if (-not $exists -or -not (Test-FileMapsEqual $item.OldMap (Get-FileMap $item.Destination))) {
            throw "Target changed after planning: $($item.Destination)"
        }
    }
    if (-not (Test-Path -LiteralPath $runPath)) {
        New-Item -ItemType Directory -Path $archiveRoot -Force | Out-Null
        New-Item -ItemType Directory -Path $stagingRoot -Force | Out-Null
    }
    $archive = Join-Path $archiveRoot $item.Name
    if ($null -eq $item.SourceMap) {
        Move-Item -LiteralPath $item.Destination -Destination $archive
        $applied++
        continue
    }
    $stage = Join-Path $stagingRoot $item.Name
    New-Item -ItemType Directory -Path $stage | Out-Null
    foreach ($relative in $item.SourceMap.Keys) {
        Copy-MainFileStream $item.SourceMap[$relative].Path (Join-Path $stage $relative)
    }
    if (-not (Test-FileMapsEqual $item.SourceMap (Get-FileMap $stage))) {
        throw "Staged copy failed hash verification: $($item.Name)"
    }
    if (-not (Test-Path -LiteralPath $TargetPath -PathType Container)) {
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    }
    $movedOld = $false
    try {
        if ($null -ne $item.OldMap) {
            Move-Item -LiteralPath $item.Destination -Destination $archive
            $movedOld = $true
        }
        if (Test-Path -LiteralPath $item.Destination) { throw "Unexpected target collision: $($item.Destination)" }
        Move-Item -LiteralPath $stage -Destination $item.Destination
    }
    catch {
        if ($movedOld -and -not (Test-Path -LiteralPath $item.Destination)) {
            Move-Item -LiteralPath $archive -Destination $item.Destination
        }
        throw
    }
    $applied++
}
Write-Output "Applied directory operations: $applied of $($plan.Count)"
if ($applied -gt 0) { Write-Output "Recovery/staging directory: $runPath" }
if (-not $Reconcile -and $extra.Count -gt 0) {
    Write-Output 'Excluded entries were preserved. Preview -Reconcile -WhatIf before archiving.'
}
Write-Output 'Use -Check to verify the final managed state. Keep backups until the host has been checked.'
