[CmdletBinding()]
param(
  [string]$TargetBranch = "develop",
  [string]$UpstreamRef = "upstream/main",
  [switch]$Fetch,
  [switch]$FailOnOverlap
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$safeDirectory = $repoRoot -replace '\\', '/'

function Invoke-Git {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  $output = & git "-c" "safe.directory=$safeDirectory" @Args
  if ($LASTEXITCODE -ne 0) {
    throw "git $($Args -join ' ') failed:`n$output"
  }
  return $output
}

Set-Location $repoRoot

if ($Fetch) {
  Write-Host "Fetching upstream refs..." -ForegroundColor Cyan
  Invoke-Git -Args @("fetch", "upstream", "--prune") | Out-Null
}

$currentBranch = (Invoke-Git -Args @("branch", "--show-current")).Trim()
$targetCommit = (Invoke-Git -Args @("rev-parse", $TargetBranch)).Trim()
$upstreamCommit = (Invoke-Git -Args @("rev-parse", $UpstreamRef)).Trim()
$mergeBase = (Invoke-Git -Args @("merge-base", $TargetBranch, $UpstreamRef)).Trim()
$aheadBehind = (Invoke-Git -Args @("rev-list", "--left-right", "--count", "$TargetBranch...$UpstreamRef")).Trim()
$counts = $aheadBehind -split "\s+"

$localOnly = @(Invoke-Git -Args @("diff", "--name-only", "$mergeBase..$TargetBranch"))
$upstreamOnly = @(Invoke-Git -Args @("diff", "--name-only", "$mergeBase..$UpstreamRef"))
$overlap = Compare-Object $localOnly $upstreamOnly -IncludeEqual -ExcludeDifferent |
  Select-Object -ExpandProperty InputObject

$hotspotPattern = '^(frontend/src/router/index\.ts|frontend/src/components/layout/AppSidebar\.vue|frontend/src/App\.vue|frontend/src/views/public/HomeRouteEntry\.vue|frontend/src/custom/active\.ts|frontend/src/i18n/locales/en\.ts|frontend/src/i18n/locales/zh\.ts|deploy/|script/|package\.json)'
$hotspots = $overlap | Where-Object { $_ -match $hotspotPattern }

Write-Host ""
Write-Host "Current branch : $currentBranch" -ForegroundColor Yellow
Write-Host "Target branch  : $TargetBranch" -ForegroundColor Yellow
Write-Host "Target commit  : $targetCommit" -ForegroundColor Yellow
Write-Host "Upstream ref   : $UpstreamRef" -ForegroundColor Yellow
Write-Host "Upstream commit: $upstreamCommit" -ForegroundColor Yellow
Write-Host "Merge base     : $mergeBase" -ForegroundColor Yellow
Write-Host "Ahead/Behind   : local=$($counts[0]) upstream=$($counts[1])" -ForegroundColor Yellow

Write-Host ""
Write-Host "Overlap files since merge base: $($overlap.Count)" -ForegroundColor Cyan
if ($overlap.Count -eq 0) {
  Write-Host "  none" -ForegroundColor Green
} else {
  $overlap | ForEach-Object { Write-Host "  $_" }
}

Write-Host ""
Write-Host "Hotspot overlap files: $($hotspots.Count)" -ForegroundColor Cyan
if ($hotspots.Count -eq 0) {
  Write-Host "  none" -ForegroundColor Green
} else {
  $hotspots | ForEach-Object { Write-Host "  $_" -ForegroundColor Magenta }
}

if ($FailOnOverlap -and $overlap.Count -gt 0) {
  throw "Upstream overlap detected. Resolve overlap files before syncing."
}
