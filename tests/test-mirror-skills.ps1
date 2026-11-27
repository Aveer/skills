# Windows PowerShell 5.1-compatible, isolated mirror behavior tests.
Set-StrictMode -Version 2.0
$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $PSScriptRoot
$engine = Join-Path $scriptRoot 'mirror-skills.ps1'
$agentsWrapper = Join-Path $scriptRoot 'mirror-skills-agents.ps1'
$ocWrapper = Join-Path $scriptRoot 'mirror-skills-opencode.ps1'
$fixture = Join-Path ([IO.Path]::GetTempPath()) ("skills-mirror-test-" + [Guid]::NewGuid().ToString('N'))
$repo = Join-Path $fixture 'source'
$target = Join-Path $fixture 'agents\skills'
$ocTarget = Join-Path $fixture 'opencode\skills'
$backupRoot = Join-Path $fixture 'agents\skill-mirror-backups'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$checks = 0

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "FAIL: $Message" }
    $script:checks++
}
function Assert-Fails {
    param([scriptblock]$Action, [string]$Expected)
    $failed = $false
    try { & $Action | Out-Null }
    catch {
        if ($_.Exception.Message -notlike "*$Expected*") { throw }
        $failed = $true
    }
    Assert-True $failed "expected failure: $Expected"
}
function Write-FixtureFile {
    param([string]$Path, [string]$Content)
    $dir = Split-Path -Parent $Path
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    [IO.File]::WriteAllText($Path, $Content, $utf8)
}
function Git-Checked {
    param([string[]]$Arguments)
    & git -C $repo @Arguments | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Fixture Git command failed: $Arguments" }
}
try {
    New-Item -ItemType Directory -Path $repo -Force | Out-Null
    Git-Checked @('init', '-q')
    Git-Checked @('config', 'user.name', 'Skill Mirror Fixture')
    Git-Checked @('config', 'user.email', 'fixture@example.invalid')
    Git-Checked @('config', 'core.autocrlf', 'false')
    foreach ($name in @('shared-skill', 'code-skill', 'optional-skill')) {
        Write-FixtureFile (Join-Path $repo "skills/$name/SKILL.md") "canonical $name"
        Write-FixtureFile (Join-Path $repo "skills/$name/references/nested.md") "reference $name"
    }
    $policy = @{
        schemaVersion = 1
        profiles = @{ agents = @('shared-skill'); opencode = @('shared-skill', 'code-skill') }
        optional = @('optional-skill')
        retired = @('old-skill')
        repoOnly = @('skills-maintenance')
        nexusCandidates = @('shared-skill')
    }
    Write-FixtureFile (Join-Path $repo 'skills-policy.json') ($policy | ConvertTo-Json -Depth 5)
    Git-Checked @('add', '--', 'skills/', 'skills-policy.json')
    Git-Checked @('commit', '-qm', 'fixture')
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Reconcile -WhatIf | Out-Null
    Assert-True (-not (Test-Path $target)) 'WhatIf must not create destination'
    Assert-True (-not (Test-Path $backupRoot)) 'WhatIf must not create backups'
    Assert-Fails { & $agentsWrapper -RepoPath $repo -TargetPath $target -Check } 'Managed skill drift'
    Assert-True (-not (Test-Path $target)) 'Check must not create destination'

    & $agentsWrapper -RepoPath $repo -TargetPath $target | Out-Null
    Assert-True (Test-Path (Join-Path $target 'shared-skill/references/nested.md')) 'shared skill installed'
    Assert-True (-not (Test-Path (Join-Path $target 'code-skill'))) 'local-only skill excluded from shared profile'
    Assert-True (-not (Test-Path (Join-Path $target 'optional-skill'))) 'optional skill excluded by default'
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Check | Out-Null

    Write-FixtureFile (Join-Path $target 'private-skill/SKILL.md') 'private sentinel'
    Write-FixtureFile (Join-Path $target 'old-skill/SKILL.md') 'retired sentinel'
    Write-FixtureFile (Join-Path $target 'skills-maintenance/SKILL.md') 'repo-only sentinel'
    Write-FixtureFile (Join-Path $target 'code-skill/SKILL.md') 'out-of-profile sentinel'
    Write-FixtureFile (Join-Path $target 'shared-skill/SKILL.md') 'local edit sentinel'
    Write-FixtureFile (Join-Path $target 'shared-skill/stale.md') 'stale sentinel'
    Assert-Fails { & $agentsWrapper -RepoPath $repo -TargetPath $target -Check } 'Managed skill drift'
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Reconcile -WhatIf | Out-Null
    Assert-True ((Get-Content (Join-Path $target 'shared-skill/SKILL.md') -Raw) -eq 'local edit sentinel') 'preview preserves local edit'
    Assert-True (Test-Path (Join-Path $target 'old-skill')) 'preview preserves retired skill'
    & $agentsWrapper -RepoPath $repo -TargetPath $target | Out-Null
    Assert-True (Test-Path (Join-Path $target 'old-skill')) 'default mirror preserves retired names'
    Assert-True (-not (Test-Path (Join-Path $target 'shared-skill/stale.md'))) 'replacement removes stale active file'
    $archivedEdits = @(Get-ChildItem -LiteralPath $backupRoot -Filter 'stale.md' -Recurse -File)
    Assert-True ($archivedEdits.Count -eq 1) 'stale local file is backed up'
    Assert-True ((Get-Content -LiteralPath $archivedEdits[0].FullName -Raw) -eq 'stale sentinel') 'backup contents preserved'
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Reconcile | Out-Null
    foreach ($name in @('old-skill', 'skills-maintenance', 'code-skill')) {
        Assert-True (-not (Test-Path (Join-Path $target $name))) "$name archived outside discovery"
        Assert-True (@(Get-ChildItem -LiteralPath $backupRoot -Recurse -Directory -Filter $name).Count -ge 1) "$name has a recovery directory"
    }
    Assert-True ((Get-Content (Join-Path $target 'private-skill/SKILL.md') -Raw) -eq 'private sentinel') 'unknown skill preserved'
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Check | Out-Null
    $backupCount = @(Get-ChildItem -LiteralPath $backupRoot -Directory).Count
    & $agentsWrapper -RepoPath $repo -TargetPath $target -Reconcile | Out-Null
    Assert-True (@(Get-ChildItem -LiteralPath $backupRoot -Directory).Count -eq $backupCount) 'unchanged mirror is idempotent'

    & $ocWrapper -RepoPath $repo -TargetPath $ocTarget -IncludeSkill 'optional-skill' | Out-Null
    Assert-True (Test-Path (Join-Path $ocTarget 'code-skill/SKILL.md')) 'OpenCode profile installs local reference'
    Assert-True (Test-Path (Join-Path $ocTarget 'optional-skill/SKILL.md')) 'explicit optional include installed'
    & $ocWrapper -RepoPath $repo -TargetPath $ocTarget -IncludeSkill 'optional-skill' -Check | Out-Null
    Assert-Fails { & $ocWrapper -RepoPath $repo -TargetPath $ocTarget -Check } 'Managed skill drift'
    Assert-Fails { & $ocWrapper -RepoPath $repo -TargetPath $ocTarget -IncludeSkill 'old-skill' -WhatIf } 'Unknown or retired'

    Write-FixtureFile (Join-Path $repo 'skills/shared-skill/SKILL.md') 'dirty source'
    Assert-Fails { & $agentsWrapper -RepoPath $repo -TargetPath $target -WhatIf } 'uncommitted'
    Git-Checked @('checkout', '--', 'skills/shared-skill/SKILL.md')
    Assert-Fails { & $agentsWrapper -RepoPath $repo -TargetPath (Join-Path $repo 'nested') -WhatIf } 'disjoint'

    # A junction is a Windows reparse point; do not follow it into another tree.
    $junctionTarget = Join-Path $fixture 'junction-test'
    $junctionOutside = Join-Path $fixture 'junction-outside'
    New-Item -ItemType Directory -Path $junctionTarget, $junctionOutside -Force | Out-Null
    Write-FixtureFile (Join-Path $junctionOutside 'sentinel.txt') 'outside'
    $link = Join-Path $junctionTarget 'shared-skill'
    try {
        New-Item -ItemType Junction -Path $link -Target $junctionOutside | Out-Null
        Assert-Fails { & $engine -Profile agents -RepoPath $repo -TargetPath $junctionTarget -WhatIf } 'reparse point'
        Assert-True ((Get-Content (Join-Path $junctionOutside 'sentinel.txt') -Raw) -eq 'outside') 'junction target untouched'
    }
    finally {
        if (Test-Path -LiteralPath $link) {
            & cmd.exe /d /c "rmdir ""$link""" | Out-Null
            if ($LASTEXITCODE -ne 0) { throw 'Could not remove temporary test junction safely.' }
        }
    }
    Write-Output "PASS: $checks mirror assertions."
}
finally {
    # Only the unique disposable fixture is removed; actual host targets are never used.
    if (Test-Path -LiteralPath $fixture) {
        Remove-Item -LiteralPath $fixture -Recurse -Force
    }
}
