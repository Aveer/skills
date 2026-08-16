<#
.SYNOPSIS
    Mirrors skills from this repo to the cross-harness .agents skills folder.

.DESCRIPTION
    Additive, non-destructive sync (repo -> .agents skills folder):
      - New skills (repo skill directories that are missing in the target)
        are copied over in full.
      - Existing skills are updated file-by-file: files that are missing or
        changed in the target are overwritten from the repo.
      - Files or skills that exist ONLY in the target are NEVER removed.
        Local-only skills and local-only files are always preserved.

    The target is %USERPROFILE%\.agents\skills, the de-facto global skills
    folder read natively by Codex CLI, Cursor, Gemini CLI, VS Code/Copilot,
    and OpenCode (compat). Claude Code does not read this folder (it uses
    %USERPROFILE%\.claude\skills).

    The repo is the source of truth. To remove a skill, delete it from the
    repo and clean the target folder manually - this script never deletes.

.PARAMETER RepoPath
    Path to the skills repo. Defaults to the folder containing this script.

.PARAMETER TargetPath
    Path to the .agents skills folder.
    Defaults to %USERPROFILE%\.agents\skills

.EXAMPLE
    .\mirror-skills-agents.ps1
    Mirror all skills from this repo to the default .agents skills folder.

.EXAMPLE
    .\mirror-skills-agents.ps1 -WhatIf
    Preview what would be added or updated without changing anything.

.EXAMPLE
    .\mirror-skills-agents.ps1 -TargetPath D:\backup\skills
    Mirror to a custom target folder.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$RepoPath = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$TargetPath = (Join-Path $env:USERPROFILE '.agents\skills')
)

$ErrorActionPreference = 'Stop'

# Strip Windows "Mark of the Web" (Zone.Identifier) and other alternate data
# streams from a file. Copy-Item preserves ADS, which would otherwise
# propagate junk streams into the target folder.
function Clear-FileStreams {
    param([string]$FilePath)
    $streams = Get-Item -LiteralPath $FilePath -Stream * |
        Where-Object { $_.Stream -ne ':$DATA' }
    foreach ($s in $streams) {
        Remove-Item -LiteralPath $FilePath -Stream $s.Stream -ErrorAction SilentlyContinue
    }
}

if (-not (Test-Path -LiteralPath $RepoPath)) {
    throw "Repo path not found: $RepoPath"
}
if (-not (Test-Path -LiteralPath $TargetPath)) {
    if ($PSCmdlet.ShouldProcess($TargetPath, 'Create target folder')) {
        New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    }
}

$added = @()
$updated = @()
$unchanged = @()
$skipped = @()

# Skills live under skills/; the meta skill (skills-maintenance) lives at
# the repo root. Scan both locations.
$skills = @()
$skillsRoot = Join-Path $RepoPath 'skills'
if (Test-Path -LiteralPath $skillsRoot) {
    $skills += Get-ChildItem -LiteralPath $skillsRoot -Directory
}
$skills += Get-ChildItem -LiteralPath $RepoPath -Directory |
    Where-Object { $_.Name -ne '.git' -and $_.Name -ne 'skills' }

foreach ($skill in $skills) {
    $skillMd = Join-Path $skill.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillMd)) {
        $skipped += $skill.Name
        Write-Warning "Skipping '$($skill.Name)': no SKILL.md found (not a skill)"
        continue
    }

    $targetSkill = Join-Path $TargetPath $skill.Name

    if (-not (Test-Path -LiteralPath $targetSkill)) {
        # New skill: copy the whole directory.
        if ($PSCmdlet.ShouldProcess($skill.Name, 'Add new skill')) {
            Copy-Item -Path $skill.FullName -Destination $targetSkill -Recurse -Force
            Get-ChildItem -LiteralPath $targetSkill -Recurse -File -Force |
                ForEach-Object { Clear-FileStreams -FilePath $_.FullName }
        }
        $added += $skill.Name
        continue
    }

    # Existing skill: sync files additively. Never delete target-only files.
    $changed = $false
    $files = Get-ChildItem -LiteralPath $skill.FullName -Recurse -File
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($skill.FullName.Length).TrimStart('\')
        $destFile = Join-Path $targetSkill $relative
        $destDir = Split-Path -Parent $destFile

        $needsCopy = -not (Test-Path -LiteralPath $destFile)
        if (-not $needsCopy) {
            $srcHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
            $dstHash = (Get-FileHash -LiteralPath $destFile -Algorithm SHA256).Hash
            $needsCopy = ($srcHash -ne $dstHash)
        }

        if ($needsCopy) {
            if ($PSCmdlet.ShouldProcess($destFile, 'Update file')) {
                if (-not (Test-Path -LiteralPath $destDir)) {
                    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
                }
                Copy-Item -LiteralPath $file.FullName -Destination $destFile -Force
                Clear-FileStreams -FilePath $destFile
            }
            $changed = $true
        }
    }

    if ($changed) { $updated += $skill.Name } else { $unchanged += $skill.Name }
}

Write-Output ''
Write-Output '=== Skills mirror summary ==='
Write-Output ("Target:  {0}" -f $TargetPath)
Write-Output ("Added:     {0}" -f $added.Count)
$added | ForEach-Object { Write-Output "  + $_" }
Write-Output ("Updated:   {0}" -f $updated.Count)
$updated | ForEach-Object { Write-Output "  ~ $_" }
Write-Output ("Unchanged: {0}" -f $unchanged.Count)
if ($skipped.Count -gt 0) {
    Write-Output ("Skipped (no SKILL.md): {0}" -f $skipped.Count)
    $skipped | ForEach-Object { Write-Output "  - $_" }
}
