[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$RepoPath = $PSScriptRoot,
    [string]$TargetPath = (Join-Path $env:USERPROFILE '.agents\skills'),
    [switch]$Check,
    [switch]$Reconcile,
    [string[]]$IncludeSkill = @()
)
$ErrorActionPreference = 'Stop'
$params = @{
    Profile = 'agents'
    RepoPath = $RepoPath
    TargetPath = $TargetPath
    Check = $Check
    Reconcile = $Reconcile
    IncludeSkill = $IncludeSkill
}
if ($PSBoundParameters.ContainsKey('WhatIf')) { $params.WhatIf = $PSBoundParameters['WhatIf'] }
if ($PSBoundParameters.ContainsKey('Confirm')) { $params.Confirm = $PSBoundParameters['Confirm'] }
& (Join-Path $PSScriptRoot 'mirror-skills.ps1') @params
