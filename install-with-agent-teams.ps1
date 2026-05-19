# Galaxy Maps - install the Agent Teams skill bundle (7 skills)
#
# Usage:
#   .\install-with-agent-teams.ps1                # personal install -> %USERPROFILE%\.claude\skills\
#   .\install-with-agent-teams.ps1 -Project       # project install -> .\.claude\skills\
#   .\install-with-agent-teams.ps1 -Dest <dir>    # custom destination
#
# Or via irm (no clone needed):
#   irm https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-with-agent-teams.ps1 | iex
#
# Idempotent - re-running pulls latest on already-installed repos.

[CmdletBinding()]
param(
    [switch]$Project,
    [string]$Dest
)

$ErrorActionPreference = 'Stop'

$Org = 'Galaxy-Maps'
$BundleName = 'agent-teams'
$Repos = @(
    'gm-agent-01a-orchestrator-with-agent-teams',
    'gm-agent-02-intent',
    'gm-agent-03a-curriculum-with-agent-teams',
    'gm-agent-04a-curriculum-critiquer-with-agent-teams',
    'gm-agent-05a-branching-with-agent-teams',
    'gm-agent-06a-mission-builder-with-agent-teams',
    'gm-agent-07a-mission-critiquer-with-agent-teams'
)

if (-not $Dest) {
    if ($Project) {
        $Dest = Join-Path (Get-Location) '.claude\skills'
    } else {
        $Dest = Join-Path $env:USERPROFILE '.claude\skills'
    }
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error 'git is required but was not found in PATH'
    exit 1
}

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

Write-Host "Galaxy Maps - installing $BundleName bundle ($($Repos.Count) skills)"
Write-Host "Destination: $Dest"
Write-Host ''

$installed = 0
$updated = 0
$failed = @()

foreach ($repo in $Repos) {
    $target = Join-Path $Dest $repo
    $url = "https://github.com/$Org/$repo.git"

    if (Test-Path (Join-Path $target '.git')) {
        Write-Host "  > updating  $repo"
        Push-Location $target
        try {
            git pull --quiet --ff-only
            if ($LASTEXITCODE -eq 0) { $updated++ } else { $failed += "$repo (pull failed)" }
        } finally {
            Pop-Location
        }
    } elseif (Test-Path $target) {
        Write-Host "  x $target exists but is not a git repo - skipping"
        $failed += "$repo (target not a git repo)"
    } else {
        Write-Host "  > cloning   $repo"
        git clone --quiet --depth 1 $url $target
        if ($LASTEXITCODE -eq 0) { $installed++ } else { $failed += "$repo (clone failed)" }
    }
}

Write-Host ''
Write-Host "Done - $installed new install(s), $updated update(s)."

if ($failed.Count -gt 0) {
    Write-Host ''
    Write-Host 'Failures:'
    foreach ($f in $failed) { Write-Host "  - $f" }
    exit 1
}

Write-Host ''
Write-Host 'Next: in Claude Code, type /gm-agent-01a-orchestrator-with-agent-teams to start a Galaxy Map.'
