$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendDir = Join-Path $repoRoot 'backend'
$binaryPath = Join-Path $backendDir 'sub2api2.exe'

if (-not (Test-Path $binaryPath)) {
  throw "Binary not found: $binaryPath`nRun `npm.cmd run build:sub2api2` first."
}

Push-Location $backendDir
try {
  & $binaryPath
}
finally {
  Pop-Location
}
