$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendDir = Join-Path $repoRoot 'backend'
$outputPath = Join-Path $backendDir 'sub2api2.exe'
$versionFile = Join-Path $backendDir 'cmd\server\VERSION'

if (-not (Test-Path $versionFile)) {
  throw "Version file not found: $versionFile"
}

$version = (Get-Content $versionFile -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($version)) {
  throw "Version file is empty: $versionFile"
}

Write-Host "Building embedded Windows test binary..."
Write-Host "Output: $outputPath"
Write-Host "Version: $version"

Push-Location $backendDir
try {
  $env:CGO_ENABLED = '0'
  go build -tags embed -ldflags "-s -w -X main.Version=$version" -o $outputPath .\cmd\server
}
finally {
  Pop-Location
}

Write-Host "Build completed: $outputPath"
